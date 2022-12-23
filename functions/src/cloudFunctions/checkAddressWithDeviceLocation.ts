import * as functions from "firebase-functions";
import { getCoordinatesFromAddress } from "../functions/getCoordinatesFromAddress";
import { getOSMCoordinatesFromAddress } from "../functions/getOSMCoordinatesFromAddress";
import { getDistanceFromLatLonInMeters } from "../functions/getDistanceFromLatLonInMeters";
import * as admin from "firebase-admin";
import { GeoPoint } from "firebase-admin/firestore";
import { getOSMSuburbFromCoords } from "../functions/getOSMSuburbFromCoords";

const MAX_DISTANCE_METERS = 44440;

const db = admin.firestore();

export const checkAddressWithDeviceLocation = functions
  .runWith({
    enforceAppCheck: false, // Requests without valid App Check tokens will be rejected.
    // secrets: ["GOOGLE_MAPS_API_KEY"],
  })
  .https.onCall(async (data, context) => {
    const { address, deviceLongitudeCoordinate, deviceLatitudeCoordinate } =
      data;

    if (!address || !deviceLongitudeCoordinate || !deviceLatitudeCoordinate) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing required data. Please provide a valid address and device coordinates."
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

    // try addressCoordinates
    let addressCoordinates;
    try {
      addressCoordinates = await getCoordinatesFromAddress(address);
      // addressCoordinates = await getCoordinatesFromAddress(address);
    } catch (error) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Error getting coordinates from address. Error: " + error.massage
      );
    }

    const distance = getDistanceFromLatLonInMeters(
      deviceLatitudeCoordinate,
      deviceLongitudeCoordinate,
      addressCoordinates.latitude,
      addressCoordinates.longitude
    );

    if (distance < 0 || distance > MAX_DISTANCE_METERS) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Bitte schalten deinen Standort in den Einstellungen > Standort > Genauen Standort verwenden um die Adresse zu bestätigen."
      );
    }

    const deviceCoordinates = new GeoPoint(
      deviceLatitudeCoordinate,
      deviceLongitudeCoordinate
    );

    try {
      await userRef.set({
        addressCoordinates: addressCoordinates,
        deviceCoordinates: deviceCoordinates,
        distanceOfDeviceAndAddressInMeter: distance,
      });
    } catch (error) {
      throw new functions.https.HttpsError(
        "internal",
        "Error updating user document. Please try again Error: " + error
      );
    }

    const subUrb = await getOSMSuburbFromCoords(
      addressCoordinates.latitude,
      addressCoordinates.longitude
    );

    const userPublicInfpRef = db
      .collection("users")
      .doc(uid)
      .collection("userPublicInfo")
      .doc(uid);
    try {
      await userPublicInfpRef.update({
        subUrb: subUrb,
      });
    } catch (error) {
      throw new functions.https.HttpsError(
        "internal",
        "Error updating user document. Please try again Error: " + error
      );
    }

    return true;
  });
