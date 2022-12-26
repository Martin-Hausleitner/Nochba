import * as functions from "firebase-functions";
import { getCoordinatesFromAddress } from "../functions/getCoordinatesFromAddress";
import { getOSMCoordinatesFromAddress } from "../functions/getOSMCoordinatesFromAddress";
import { getDistanceFromLatLonInMeters } from "../functions/getDistanceFromLatLonInMeters";
import * as admin from "firebase-admin";
import { GeoPoint } from "firebase-admin/firestore";
import { getOSMSuburbFromCoords } from "../functions/getOSMSuburbFromCoords";
import * as logger from "firebase-functions/logger";

const MAX_DISTANCE_METERS = 44440;

const db = admin.firestore();

export const checkAddressWithDeviceLocation = functions
  .runWith({
    enforceAppCheck: false, // Requests without valid App Check tokens will be rejected.
  })
  .https.onCall(async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "The request is not authenticated."
      );
    }
    const uid = context.auth.uid;

    const { address, deviceLongitudeCoordinate, deviceLatitudeCoordinate } =
      data;

    if (!address || !deviceLongitudeCoordinate || !deviceLatitudeCoordinate) {
      logger.error(
        `Missing required data. Please provide a valid address and device coordinates.`
      );
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing required data. Please provide a valid address and device coordinates."
      );
    }

    logger.info(
      `User: ${uid} Cords: ${deviceLatitudeCoordinate} ${deviceLongitudeCoordinate} Address: ${address}`
    );

    const userRef = db
      .collection("users")
      .doc(uid)
      .collection("userInternInfo")
      .doc(uid);
    const userDoc = await userRef.get();

    if (userDoc.exists) {
      logger.error("Address coordinates have already been written!");
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Address coordinates have already been written!"
      );
    }

    // try addressCoordinates
    let addressCoordinates;
    try {
      addressCoordinates = await getCoordinatesFromAddress(address);
      // addressCoordinates = await getCoordinatesFromAddress(address);
    } catch (error) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Error getting coordinates from address. Error: " + error
      );
    }

    let distance = null;
    try {
      distance = await getDistanceFromLatLonInMeters(
        addressCoordinates.latitude,
        addressCoordinates.longitude,
        deviceLatitudeCoordinate,
        deviceLongitudeCoordinate
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
    if ((distance == null)) {
      logger.error(
        `NULL Exeption: The distance between the address and the verification code could not be calculated. Distance: ${distance}`
      );
      throw new functions.https.HttpsError(
        "failed-precondition",
        "The distance between the address and the verification code could not be calculated."
      );
    }

    if (distance < 0 || distance > MAX_DISTANCE_METERS) {
      logger.error(`The distance between the address and the verification code is too large. Distance: ${distance} > ${MAX_DISTANCE_METERS}`);
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Bitte schalten deinen Standort in den Einstellungen > Standort > Genauen Standort verwenden um die Adresse zu bestätigen."
      );
    }

    const deviceCoordinates = new GeoPoint(
      deviceLatitudeCoordinate,
      deviceLongitudeCoordinate
    );

    await userRef.set({
      addressCoordinates: addressCoordinates,
      deviceCoordinates: deviceCoordinates,
      distanceInMeter: distance,
    });

    const subUrb = await getOSMSuburbFromCoords(
      addressCoordinates.latitude,
      addressCoordinates.longitude
    );

    const userPublicInfpRef = db
      .collection("users")
      .doc(uid)
      .collection("userPublicInfo")
      .doc(uid);
    await userPublicInfpRef.set({ subUrb }, { merge: true });
    logger.info(
      `✅ User: ${uid} verified with Location.`
    );
    return true;
  });
