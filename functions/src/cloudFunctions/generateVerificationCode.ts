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
    const userId = context.auth.uid;

    const userRef = db.collection("users").doc(userId);

    // Check if a code already exists for the user
    const userPublicInfoRef = userRef.collection("userPublicInfo").doc(userId);
    const userPublicInfoSnapshot = await userPublicInfoRef.get();
    if (
      userPublicInfoSnapshot.exists &&
      userPublicInfoSnapshot.get("verificationCodeRef")
    ) {
      // A code already exists, so retrieve it from the referenced document
      const verificationCodeRef = userPublicInfoSnapshot.get(
        "verificationCodeRef"
      );
      const verificationCodeSnapshot = await verificationCodeRef.get();
      if (verificationCodeSnapshot.exists) {
        const verificationCode = verificationCodeSnapshot.get("code");
        return { verificationCode };
      }
    }

    // If no code exists, generate a

    // Check if a verification code has already been generated

    // Generate a random verification code
    const verificationCode = await generateRandomVerificationCode();

    // Check if the code already exists in the database
    const codeRef = db.collection("verificationCodes").doc(verificationCode);
    const codeSnapshot = await codeRef.get();
    if (codeSnapshot.exists) {
      throw new functions.https.HttpsError(
        "already-exists",
        "The verification code already exists."
      );
    }

    const userDoc = await userRef.get();
    if (!userDoc.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "The specified user does not exist."
      );
    }

    const userInternInfoRef = userRef.collection("userInternInfo").doc(userId);
    const userInternInfoDoc = await userInternInfoRef.get();
    if (!userInternInfoDoc.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "The specified user intern info does not exist."
      );
    }

    const coordinates = userInternInfoDoc.get("addressCoordinates");
    if (!coordinates) {
      throw new functions.https.HttpsError(
        "not-found",
        "The specified user does not have coordinates."
      );
    }

    // // Save a ref of the new code in the users collection in userPublicInfo
    const userPublicInfoReff = userRef.collection("userPublicInfo").doc(userId);

    await userPublicInfoReff.set({ verificationCodeRef: codeRef });

    //check if this ref already exists in the database if yes return the code

    // Return the verification code to the client
    return { verificationCode };
  }
);
