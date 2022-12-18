// Import the Firebase and Firestore libraries, as well as the FieldValue type
// from the Firestore library
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { FieldValue, GeoPoint } from "firebase-admin/firestore";

// Import some helper functions for getting coordinates from an address and
// calculating the distance between two sets of coordinates
import { getCoordinatesFromAddress } from "../functions/getCoordinatesFromAddress";
import { getDistanceFromLatLonInMeters } from "../functions/getDistanceFromLatLonInMeters";

// Import a function for verifying a verification code
import { verifyVerificationCode } from "../functions/verifyVerificationCode";

// Initialize the Firestore database
const db = admin.firestore();

// Export the checkVerificationCode function as a Cloud Function that can be
// called by a client via HTTPS
export const checkVerificationCode = functions.https.onCall(
  async (data, context) => {
    // Destructure the verification code and address from the request data
    const verificationCode = data.verificationCode;
    try {
      await verifyVerificationCode(verificationCode);
    } catch (error) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "The verification code is invalid"
      );
    }

    if (!context.auth || !context.auth.uid) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Missing or invalid context. Please ensure that the request is properly authenticated."
      );
    }
    const uid = context.auth?.uid;

    const userRef = db
      .collection("users")
      .doc(uid)
      .collection("userInternInfo")
      .doc(uid);
    const userDoc = await userRef.get();
    if (userDoc.exists && userDoc.data()?.addressCoordinates) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Address coordinates have already been written!"
      );
    }

    const address = data.address;
    //check if address is not null
    let addressCoordinates;
    try {
      addressCoordinates = await getCoordinatesFromAddress(address);
    } catch (error) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Error getting coordinates from address. Error: " + error.massage
      );
    }

    // Get a reference to the verification code document in the database
    const codeRef = db.collection("verificationCodes").doc(verificationCode);

    // Get the data for the verification code document
    const codeSnap = await codeRef.get();
    if (!codeSnap.exists) {
      // If the verification code document does not exist, throw an error
      throw new functions.https.HttpsError(
        "not-found",
        "The verification code was not found."
      );
    }
    const codeData = codeSnap.data();

    // const addressCoordinates = { latitude: 0, longitude: 0 };

    // Calculate the distance between the given address and the address associated
    // with the verification code
    const distance = getDistanceFromLatLonInMeters(
      addressCoordinates.latitude,
      addressCoordinates.longitude,
      codeData.addressCoordinate.lat,
      codeData.addressCoordinate.lng
    );

    if (distance > codeData.rangeInMeters) {
      // If the distance is greater than the allowed range, throw an error
      throw new functions.https.HttpsError(
        "out-of-range",
        "The given address is out of range."
      );
    }

    // Update the verification code document to include the user's ID
    await db
      .collection("verificationCodes")
      .doc(verificationCode)
      .update({
        usedForVerification: FieldValue.arrayUnion(uid),
      });

    // Update the user's document to include the verification code
    await db
      .collection("users")
      .doc(uid)
      .collection("userInternInfo")
      .doc(uid)
      .update({ usedVerificationCode: verificationCode });

    return true;
  }
);
