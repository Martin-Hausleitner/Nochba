// Import the Firebase and Firestore libraries, as well as the FieldValue type
// from the Firestore library
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { FieldValue, GeoPoint } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

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
    const uid = context.auth?.uid;

    logger.info(`User: ${uid} VerificationCode: ${verificationCode}`);

    if (!context.auth || !context.auth.uid) {
      logger.error("Missing or invalid context.auth.uid");
      throw new functions.https.HttpsError(
        "permission-denied",
        "Missing or invalid context. Please ensure that the request is properly authenticated."
      );
    }

    try {
      await verifyVerificationCode(verificationCode);
    } catch (error) {
      logger.error(
        `The verification code does not have the correct format! Error: ${error}`
      );
      throw new functions.https.HttpsError(
        "invalid-argument",
        "The verification code is invalid"
      );
    }

    const codeRef = db.collection("verificationCodes").doc(verificationCode);
    const codeDoc = await codeRef.get();
    if (codeDoc.data()?.isActive == false) {
      logger.error("The Verification Code is deactivated!");
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
      logger.error("The user has already addressCoordinates in the Database!");
      throw new functions.https.HttpsError(
        "failed-precondition",
        "You are already been verified."
      );
    }
    const address = data.address;

    let addressCoordinates: GeoPoint;
    try {
      addressCoordinates = await getOSMCoordinatesFromAddress(address);
    } catch (error) {
      logger.error(
        `An error occurred while attempting to retrieve coordinates from the given address with the API. Error: ${error} `
      );
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Can't get coordinates from your address!"
      );
    }

    let codeData;
    try {
      codeData = await codeRef.get();
    } catch (error) {
      logger.error(
        `The provided verification code was not found in the database. Error: ${error}`
      );
      throw new functions.https.HttpsError(
        "not-found",
        "The verification code does not exist."
      );
    }
    const { addressCoordinate } = codeData.data();
    let codeAddressCoordinates = new GeoPoint(
      Number(addressCoordinate._latitude),
      Number(addressCoordinate._longitude)
    );

    let distance = null;
    try {
      distance = await getDistanceFromLatLonInMeters(
        addressCoordinates.latitude,
        addressCoordinates.longitude,
        codeAddressCoordinates.latitude,
        codeAddressCoordinates.longitude
      );
    } catch (error) {
      logger.error(
        `The distance between the address and the verification code could not be calculated. Distance: ${distance} Error: ${error}`
      );
      throw new functions.https.HttpsError(
        "failed-precondition",
        "The distance between the address and the verification code could not be calculated."
      );
    }

    const { rangeInMeter } = codeData.data();

    if (distance > rangeInMeter) {
      logger.error(
        `The address is not within the allowed range. ${distance} > ${rangeInMeter}`
      );
      throw new functions.https.HttpsError(
        "out-of-range",
        "The address you provided is not within the allowed range of the verification code."
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
        distanceInMeter: distance,
        usedVerificationCode: verificationCode,
      });
    } catch (error) {
      logger.error(`Error updating user document. Error: ${error}`);
      throw new functions.https.HttpsError(
        "internal",
        "An internal error occurred while attempting to save your address coordinates."
      );
    }

    logger.info(
      `User: ${uid} has been verified with the verification code: ${verificationCode}.`
    );
    return true;
  }
);
