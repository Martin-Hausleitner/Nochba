// Import the Firebase and Firestore libraries, as well as the FieldValue type
// from the Firestore library
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { FieldValue, GeoPoint } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

// Import some helper functions for getting coordinates from an address and
// calculating the distance between two sets of coordinates
// import { getCoordinatesFromAddress } from "../functions/getCoordinatesFromAddress";
import { getDistanceFromLatLonInMeters } from "../functions/getDistanceFromLatLonInMeters";

// Import a function for verifying a verification code
import { verifyVerificationCode } from "../functions/verifyVerificationCode";
import { getOSMCoordinatesFromAddress } from "../functions/getOSMCoordinatesFromAddress";
import { getOSMSuburbFromCoords } from "../functions/getOSMSuburbFromCoords";

const db = admin.firestore();

export const checkVerificationCode = functions.region('europe-west1').https.onCall(
  async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "The request is not authenticated."
      );
    }
    const uid = context.auth.uid;
    const verificationCode = data.verificationCode;

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
    } catch (e) {
      logger.error(
        `The verification code does not have the correct format! Error: ${e}`
      );
      throw new functions.https.HttpsError(
        "invalid-argument",
        "The verification code is invalid"
      );
    }

    const codeRef = db.collection("codes").doc(verificationCode);
    const codeDoc = await codeRef.get();

    if (!codeDoc.exists) {
      logger.error("The Verification Code does not exist!");
      throw new functions.https.HttpsError(
        "not-found",
        "The Verification Code does not exist!"
      );
    }

    if (codeDoc.data()?.isActive == false) {
      logger.error("The Verification Code is deactivated!");
      throw new functions.https.HttpsError(
        "failed-precondition",
        "The Verification Code is deactivated!"
      );
    }

    //check if the usedCodeCount is under the maxCodeLimit
    const { maxCodeLimit } = codeDoc.data();
    const { usedCodeCount } = codeDoc.data();
    if (usedCodeCount >= maxCodeLimit) {
      logger.error(
        `The Verification Code has the maximum number of uses reached: ${usedCodeCount} >= ${maxCodeLimit}}`
      );
      throw new functions.https.HttpsError(
        "failed-precondition",
        "The Verification Code has the maximum number of uses reached"
      );
    }

    const userInternAddressRef = db
      .collection("users")
      .doc(uid)
      .collection("intern")
      .doc("address");
    const userDoc = await userInternAddressRef.get();
    if (userDoc.exists && userDoc.data()?.coords) {
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

    // Check if distance is null
    if (distance == null) {
      logger.error(
        `NULL Exeption: The distance between the address and the verification code could not be calculated. Distance: ${distance}`
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

    await userInternAddressRef.set({
      coords: addressCoordinates,
      // distanceInMeter: distance,
      // usedVerificationCode: verificationCode,
    });

    const userInternVerificationRef = db
      .collection("users")
      .doc(uid)
      .collection("intern")
      .doc("verification");

    await userInternVerificationRef.set({
      code: verificationCode,
      distance: distance,
    });

    const suburb = await getOSMSuburbFromCoords(
      addressCoordinates.latitude,
      addressCoordinates.longitude
    );

    const userPublicRef = db.collection("users").doc(uid);
    await userPublicRef.set({ suburb: suburb }, { merge: true });

    try {
      // Code that performs operations on Firebase
      await db
        .collection("codes")
        .doc(verificationCode)
        .collection("usedForVerification")
        .doc(uid)
        .set({});

      await db
        .collection("codes")
        .doc(verificationCode)
        .set({ usedCodeCount: FieldValue.increment(1) }, { merge: true });
    } catch (error) {
      // Log the error message
      logger.error(error);

      // Throw an HttpsError with a custom error message
      throw new functions.https.HttpsError(
        "internal",
        "An error occurred while saving the verification code"
      );
    }

    logger.info(`✅ User: ${uid} verified with code: ${verificationCode}.`);
    return true;
  }
);
