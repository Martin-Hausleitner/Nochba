// Import the Firebase and Firestore libraries, as well as the FieldValue type
// from the Firestore library
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { FieldValue } from "firebase-admin/firestore";

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
    const address = data.address;

    // Verify the verification code
    await verifyVerificationCode(verificationCode);

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

    // Get the coordinates for the given address
    // const addressCoordinates = await getCoordinatesFromAddress(address);
    const addressCoordinates = { latitude: 0, longitude: 0 };

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

    // Get the user's ID from the request context
    const userId = context.auth?.uid;
    // If the user is not logged in, throw an error
    if (!userId) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be logged in to call this function"
      );
    }

    // Update the verification code document to include the user's ID
    await db
      .collection("verificationCodes")
      .doc(verificationCode)
      .update({
        usedForVerification: FieldValue.arrayUnion(userId),
      });

    // Update the user's document to include the verification code
    await db
      .collection("users")
      .doc(userId)
      .collection("userInternInfo")
      .doc(userId)
      .update({ usedVerificationCode: verificationCode });

    return true;
  }
);
