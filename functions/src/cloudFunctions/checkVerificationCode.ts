import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { FieldValue } from "firebase-admin/firestore";

import { getCoordinatesFromAddress } from "../functions/getCoordinatesFromAddress";
import { getDistanceFromLatLonInMeters } from "../functions/getDistanceFromLatLonInMeters";
import { verifyVerificationCode } from "../functions/verifyVerificationCode";
const db = admin.firestore();

export const checkVerificationCode = functions.https.onCall(
  async (data, context) => {
    const verificationCode = data.verificationCode;
    const address = data.address;

    // try {
    // verify the code
    await verifyVerificationCode(verificationCode);

    // get the code details from firestore
    const codeRef = db.collection("verificationCodes").doc(verificationCode);
    const codeSnap = await codeRef.get();
    if (!codeSnap.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "The verification code was not found."
      );
    }
    const codeData = codeSnap.data();

    // get the coordinates of the given address

    // const addressCoordinates1 = await getCoordinatesFromAddress(address);
    const addressCoordinates = { latitude: 0, longitude: 0 };
    // calculate the distance between the given address and the address associated with the code
    const distance = getDistanceFromLatLonInMeters(
      addressCoordinates.latitude,
      addressCoordinates.longitude,
      codeData.addressCoordinate.lat,
      codeData.addressCoordinate.lng
    );

    // // // check if the distance is within the allowed range
    if (distance > codeData.rangeInMeters) {
      throw new functions.https.HttpsError(
        "out-of-range",
        "The given address is out of range."
      );
    }

    const userId = context.auth?.uid;
    if (!userId) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be logged in to call this function"
      );
    }
    // const test = "test1";
    // const usedForVerification = [test];

    // // get the verification code from the data object
    // const usedForVerification = [userId];
    // const usedForVerification = [ "

    // // save the user's ID to the list under /verificationCodes/code/usedforVerification
    await db
      .collection("verificationCodes")
      .doc(verificationCode)
      .update({
        usedForVerification: FieldValue.arrayUnion(userId),
      });

    await db
      .collection("users")
      .doc(userId)
      .collection("userInternInfo")
      .doc(userId)
      .update({ usedVerificationCode: verificationCode });

    // // // all checks passed, add the user to the list of users who have used this code

    // // return true to indicate success
    return true;
  }
);
