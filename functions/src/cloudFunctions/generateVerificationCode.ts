import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { generateRandomVerificationCode } from "../functions/generateRandomVerificationCode";

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

    // Generate a random verification code
    const verificationCode = generateRandomVerificationCode();

    // Check if the code already exists in the database
    const codeRef = db.collection("verificationCodes").doc(verificationCode);
    const codeSnapshot = await codeRef.get();
    if (codeSnapshot.exists) {
      throw new functions.https.HttpsError(
        "already-exists",
        "The verification code already exists."
      );
    }

    // Get the user's coordinates from the database
    const userRef = db.collection("users").doc(context.auth.uid);
    const userSnapshot = await userRef.get();
    if (!userSnapshot.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "The user: " + context.auth.uid + " 1was not found in the database."
      );
    }
    const userData = userSnapshot.data();
    if (
      !userData ||
      !userData.userInternInfo ||
      !userData.userInternInfo.addressCoordinate
    ) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "5The user does not have a valid address coordinate."
      );
    }

    // Save the verification code in the database
    await codeRef.set({
      uid: context.auth.uid,
      active: true,
      addressCoordinate: userData.userInternInfo.addressCoordinate,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Return the verification code to the client
    return { verificationCode };
  }
);
