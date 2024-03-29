import * as functions from "firebase-functions";
import { getOSMCoordinatesFromAddress } from "../functions/getOSMCoordinatesFromAddress";
import { getDistanceFromLatLonInMeters } from "../functions/getDistanceFromLatLonInMeters";
import * as admin from "firebase-admin";
import { getOSMSuburbFromCoords } from "../functions/getOSMSuburbFromCoords";
import * as logger from "firebase-functions/logger";
import * as ngeohash from 'ngeohash';

const MAX_DISTANCE_METERS = 4444000;

const db = admin.firestore();

export const checkAddressWithDeviceLocation = functions.region('europe-west1')
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

    const userInternAddressRef = db
      .collection("users")
      .doc(uid)
      .collection("intern")
      .doc("address");
    const userDoc = await userInternAddressRef.get();

    const userCoordsRef = db
      .collection("userCoords")
      .doc(uid);
    const userCoordsDoc = await userInternAddressRef.get();

    if (userDoc.exists && userCoordsDoc.exists) {
      logger.error("Address coordinates have already been written!");
      throw new functions.https.HttpsError(
        "failed-precondition",
        "You are already been verified."
      );
    }

    let addressCoordinates;
    try {
      addressCoordinates = await getOSMCoordinatesFromAddress(address);
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
    if (distance == null) {
      logger.error(
        `NULL Exeption: The distance between the address and the verification code could not be calculated. Distance: ${distance}`
      );
      throw new functions.https.HttpsError(
        "failed-precondition",
        "The distance between the address and the verification code could not be calculated."
      );
    }

    if (distance < 0 || distance > MAX_DISTANCE_METERS) {
      logger.error(
        `The distance between the address and the verification code is too large. Distance: ${distance} > ${MAX_DISTANCE_METERS}`
      );
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Bitte schalten deinen Standort in den Einstellungen > Standort > Genauen Standort verwenden um die Adresse zu bestätigen."
      );
    }

    const deviceCoordinates = new admin.firestore.GeoPoint(
      deviceLatitudeCoordinate,
      deviceLongitudeCoordinate
    );

    await userInternAddressRef.set({
      coords: addressCoordinates,
    });

    var geohash = ngeohash.encode(deviceLatitudeCoordinate, deviceLongitudeCoordinate, 12);

    await userCoordsRef.set({
      g: {
        geohash: geohash,
        geopoint: deviceCoordinates
      },
    });

    const userInternVerificationRef = db
      .collection("users")
      .doc(uid)
      .collection("intern")
      .doc("verification");

    await userInternVerificationRef.set({
      deviceCoords: deviceCoordinates,
      distance: distance,
    });

    const suburb = await getOSMSuburbFromCoords(
      addressCoordinates.latitude,
      addressCoordinates.longitude
    );

    const userPublicRef = db.collection("users").doc(uid);
    await userPublicRef.set({ suburb: suburb }, { merge: true });
    logger.info(`✅ User: ${uid} verified with Location.`);
    return true;
  });
