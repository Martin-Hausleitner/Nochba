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
import { getOSMCoordinatesFromAddress } from "../functions/getOSMCoordinatesFromAddress";

// Initialize the Firestore database
const db = admin.firestore();

// Export the checkVerificationCode function as a Cloud Function that can be
// called by a client via HTTPSms

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

    const codeRef = db.collection("verificationCodes").doc(verificationCode);
    //TODO: test if in teh doc verificationCode the boolean isVerified is false then throw error
    const codeDoc = await codeRef.get();
    if (codeDoc.data()?.isActive == false) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "The Verification Code is deactivated!"
      );
    }

    const userRef = db
      .collection("users")
      .doc(uid)
      .collection("userInternInfo")
      .doc(uid);
    const userDoc = await userRef.get();
    if (userDoc.exists && userDoc.data()?.addressCoordinates) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "The user has already been verified."
      );
    }
    const address = data.address;

    let addressCoordinates = new GeoPoint(0, 0);
    //check if address is not null
    try {
      addressCoordinates = await getOSMCoordinatesFromAddress(address);
    } catch (error) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Can't get coordinates from address!" + error
      );
    }
    //check if addressCoordinates is not null
    if (!addressCoordinates) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Can't get coordinates from address!"
      );
    }

    // // Get a reference to the verification code document in the database

    // Get the data for the verification code document
    let codeData;
    try {
      codeData = await codeRef.get();
    } catch (error) {
      throw new functions.https.HttpsError(
        "not-found",
        "The verification code was not found."
      );
    }

    // return codeSnap;
    if (!codeData.addressCoordinate || !codeData.addressCoordinate.lat || !codeData.addressCoordinate.lng) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "The verification code does not have a valid address coordinate."
      );
    }
    
    if (typeof codeData.addressCoordinate.lat !== "number" || typeof codeData.addressCoordinate.lng !== "number") {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "The address coordinate of the verification code is not a valid number."
      );
    }
    
    try {
      let codeAddressCoordinates = new GeoPoint(
        codeData.addressCoordinate.lat,
        codeData.addressCoordinate.lng
      );
      // Do something with the codeAddressCoordinates object
    } catch (error) {
      if (error.message === "The verification code does not have a valid address coordinate.") {
        // Handle the error and provide a helpful message to the user
      } else {
        // Rethrow the error if it's not one that we're expecting
        throw error;
      }
    }

    // const addressCoordinates = { latitude: 0, longitude: 0 };

    // Calculate the distance between the given address and the address associated
    // with the verification code
    let distance = 1;
    try {
      distance = await getDistanceFromLatLonInMeters(
        addressCoordinates.latitude,
        addressCoordinates.longitude,
        codeData.addressCoordinate.lat,
        codeData.addressCoordinate.lng
      );
    } catch (error) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Error: getDistanceFromLatLonInMeters" + error
      );
    }

    // return distance.toString();

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

    try {
      await userRef.set({
        addressCoordinates: addressCoordinates,
        distance: distance,
        usedVerificationCode: verificationCode,
      });
    } catch (error) {
      throw new functions.https.HttpsError(
        "internal",
        "Error updating user document. Please try again Error: " + error
      );
    }

    return {
      message: "Verification successful!",
      addressCoordinatesLatitude: addressCoordinates.latitude,
      addressCoordinatesLongitude: addressCoordinates.longitude,
      distance: distance,
      // codeData.addressCoordinate.lat,
      // codeData.addressCoordinate.lat,
      // codeDataAddressCoordinateLat: codeData.addressCoordinate.lat,
      // codeDataAddressCoordinateLng: codeData.addressCoordinate.lng,
    };
  }
);
