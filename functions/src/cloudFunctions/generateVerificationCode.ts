import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { generateRandomVerificationCode } from "../functions/generateRandomVerificationCode";
import { FieldValue, GeoPoint, Timestamp } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

const GENERATION_INTERVAL = 24 * 60 * 60 * 1000; // 24 hours

const MAX_CODE_LIMIT = 1000;

const RANGE_IN_METERS = 1000;

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

      const currentTimestamp = Timestamp.fromDate(new Date());
      if (generatedVerificationCodes) {
        const lastGeneratedVerificationCode =
          generatedVerificationCodes[generatedVerificationCodes.length - 1];
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
      const codeRef = db.collection("verificationCodes").doc(verificationCode);
      const codeSnapshot = await codeRef.get();
      if (!codeSnapshot.exists) {
        break;
      }
    }

    if (!coordinates) {
      throw new functions.https.HttpsError(
        "not-found",
        "The specified user does not have coordinates."
      );
    }

    const codeRef = db.collection("verificationCodes").doc(verificationCode);
    await codeRef.set({
      userId: context.auth.uid,
      isActive: true,
      addressCoordinate: coordinates,
      rangeInMeter: RANGE_IN_METERS,
      generationDate: FieldValue.serverTimestamp(),
      maxCodeLimit: MAX_CODE_LIMIT,
    });


    await userPrivateInfoRef.set(
      {
        generatedVerificationCodes: FieldValue.arrayUnion(verificationCode),
      },
      { merge: true }
    );

    return verificationCode;
  }
);
