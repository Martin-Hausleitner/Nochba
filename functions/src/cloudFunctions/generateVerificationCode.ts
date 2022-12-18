import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { generateRandomVerificationCode } from "../functions/generateRandomVerificationCode";
import { FieldValue, GeoPoint, Timestamp } from "firebase-admin/firestore";

const db = admin.firestore();

export const generateVerificationCode = functions.https.onCall(
  async (data, context) => {
    // Check that the request is authenticated and that the user is authorized
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

    if (userPrivateInfoDoc.exists) {
      // Check if the user has generated a verification code in the past 24 hours
      const generatedVerificationCodes = userPrivateInfoDoc.get(
        "generatedVerificationCodes"
      );
      const currentTimestamp = Date.now();
      if (generatedVerificationCodes) {
        //get the last generated verification code
        const lastGeneratedVerificationCode =
          generatedVerificationCodes[generatedVerificationCodes.length - 1];
        const lastGeneratedVerificationCodeTimestamp =
          lastGeneratedVerificationCode.timestamp;
        const timeDifference =
          currentTimestamp - lastGeneratedVerificationCodeTimestamp;
        if (timeDifference < 86400000) {
          return {
            verificationCode: lastGeneratedVerificationCode.verificationCode,
            timeLeft: 86400000 - timeDifference,
          };
        }
      }
    }

    //TODO: check if the  userPrivateInfoRef has generatedVerificationCodes if yes go on if not check if the user hasnt generated a code 1 day ago generatedVerificationCodes

    // Generate a random verification code
    // const verificationCode = await generateRandomVerificationCode();
    // Generate a random verification code
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
    // Check if the code already exists in the database
    // const codeRef = db.collection("verificationCodes").doc(verificationCode);
    // const codeSnapshot = await codeRef.get();
    // if (codeSnapshot.exists) {
    //   throw new functions.https.HttpsError(
    //     "already-exists",
    //     "The verification code already exists."
    //   );
    //   //now rerun the function
    // }

    const userDoc = await userRef.get();
    if (!userDoc.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "The specified user does not exist."
      );
    }

    if (!userInternInfoDoc.exists) {
      // throw new functions.https.HttpsError(
      //   "not-found",
      //   "The specified user does not have intern info."
      // );
      //then create a new userInternInfo document
      await userInternInfoRef.set({});
    }

    const coordinates = userInternInfoDoc.get("addressCoordinates");
    if (!coordinates) {
      throw new functions.https.HttpsError(
        "not-found",
        "The specified user does not have coordinates."
      );
      //then create a new userInternInfo document
      // await userInternInfoRef.set({
      //   addressCoordinates: new admin.firestore.GeoPoint(0, 0),
      // });
    }

    // Save the code in the database
    const codeRef = db.collection("verificationCodes").doc(verificationCode);
    await codeRef.set({
      userId: context.auth.uid,
      active: true,
      addressCoordinate: coordinates,
      rangeInMeters: 1000,
      creationDate: FieldValue.serverTimestamp(),
      // timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    // // Save a ref of the new code in the users collection in userPublicInfo

    //if generatedVerification doesent exist create a new userPrivateInfo document generatedVerificationC
    // userPrivateInfoRef dosen't exist then create a new document
    if (!userPrivateInfoDoc.exists) {
      await userPrivateInfoRef.set({
        generatedVerificationCodes: [verificationCode],
      });
    } else {
      await userPrivateInfoRef.update({
        generatedVerificationCodes: FieldValue.arrayUnion(uid),
      });
    }

    // Return the verification code to the client
    return verificationCode;
  }
);
