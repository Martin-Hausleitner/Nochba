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
    if (userPublicInfoSnapshot.exists) {
      const codeRef = userPublicInfoSnapshot.get("verificationCodeRef");
      if (codeRef) {
        const codeSnapshot = await codeRef.get();
        if (codeSnapshot.exists) {
          const code = codeSnapshot.id;
          return { verificationCode: code };
        }
      }
    }

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

    const userInternInfoRef = userRef.collection("userInternInfo").doc(userId);
    const userInternInfoDoc = await userInternInfoRef.get();
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
      uid: context.auth.uid,
      active: true,
      addressCoordinate: coordinates,
      rangeInMeters: 50,
      // timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    // // Save a ref of the new code in the users collection in userPublicInfo
    const userPublicInfoReff = userRef.collection("userPublicInfo").doc(userId);

    await userPublicInfoReff.set({ verificationCodeRef: codeRef });

    // Return the verification code to the client
    return verificationCode;
  }
);
