import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { generateRandomVerificationCode } from "../functions/generateRandomVerificationCode";
import { FieldValue, GeoPoint, Timestamp } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";


const GENERATION_INTERVAL = 24 * 60 * 60 * 1000; // 24 hours

const db = admin.firestore();

export const generateVerificationCode = functions.https.onCall(
  async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "The request is not authenticated."
      );
    }
    const uid = context.auth.uid;

    const userRef = db.collection("users").doc(uid);
    const userInternInfoRef = userRef.collection("userInternInfo").doc(uid);
    const userInternInfoDoc = await userInternInfoRef.get();
    const userPrivateInfoRef = userRef.collection("userPrivateInfo").doc(uid);
    const userPrivateInfoDoc = await userPrivateInfoRef.get();
    const coordinates = userInternInfoDoc.get("addressCoordinates");
    logger.info(`User: ${uid} coordinates: ${coordinates}`);


    let generatedVerificationCodes;
    if (userPrivateInfoDoc.exists) {
      generatedVerificationCodes = userPrivateInfoDoc.get(
        "generatedVerificationCodes"
      );

      // Check if the user has generated a verification code in the past 24 hours

      const currentTimestamp = Timestamp.fromDate(new Date());
      if (generatedVerificationCodes) {
        //get the last generated verification code
        const lastGeneratedVerificationCode =
          generatedVerificationCodes[generatedVerificationCodes.length - 1];
        //now query the time database for the last generated verification code
        const codeRef = db
          .collection("verificationCodes")
          .doc(lastGeneratedVerificationCode);
        const codeSnapshot = await codeRef.get();
        if (codeSnapshot.exists) {
          const generationDate = codeSnapshot.get("generationDate");
          if (
            currentTimestamp.toMillis() - generationDate.toMillis() <
            GENERATION_INTERVAL
          ) {
            return lastGeneratedVerificationCode;
          }
        }
      }
    }
    let verificationCode;
    while (true) {
      verificationCode = await generateRandomVerificationCode();
      // Check if the code already exists in the database
      const codeRef = db.collection("verificationCodes").doc(verificationCode);
      const codeSnapshot = await codeRef.get();
      if (!codeSnapshot.exists) {
        // Break out of the loop if the code doesn't exist
        break;
      }
    }

    const userDoc = await userRef.get();
    if (!userDoc.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "The specified user does not exist."
      );
    }

    if (!userInternInfoDoc.exists) {
      await userInternInfoRef.set({});
    }

   
    if (!coordinates) {
      throw new functions.https.HttpsError(
        "not-found",
        "The specified user does not have coordinates."
      );
    }

    // Save the code in the database
    const codeRef = db.collection("verificationCodes").doc(verificationCode);
    await codeRef.set({
      userId: context.auth.uid,
      isActive: true,
      addressCoordinate: coordinates,
      rangeInMeter: 1000,
      generationDate: FieldValue.serverTimestamp(),
    });

    //if userPrivateInfoRef/generatedVerificationCodes dosen't exist create a new userPrivateInfo document generatedVerification

    // // Save a ref of the new code in the users collection in userPublicInfo

    await userPrivateInfoRef.set(
      {
        generatedVerificationCodes: FieldValue.arrayUnion(verificationCode),
      },
      { merge: true }
    );

    return verificationCode;
  }
);
