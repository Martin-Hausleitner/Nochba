import * as functions from "firebase-functions";
import { getCoordinatesFromAddress } from "../functions/getCoordinatesFromAddress";
import { getDistanceFromLatLonInMeters } from "../functions/getDistanceFromLatLonInMeters";
import * as admin from "firebase-admin";
import { GeoPoint } from "firebase-admin/firestore";



const db = admin.firestore();

const MAX_DISTANCE_METERS = 44440;

export const checkAddressWithDeviceLocation = functions
  .runWith({
    enforceAppCheck: false, // Requests without valid App Check tokens will be rejected.
    // secrets: ["GOOGLE_MAPS_API_KEY"],
  })
  .https.onCall(async (data, context) => {
    const { address, deviceLongitudeCoordinate, deviceLatitudeCoordinate } =
      data;

    let addressCoordinates: Coordinates | CoordinatesError;
    try {
      addressCoordinates = await getCoordinatesFromAddress(address);
    } catch (err) {
      return {
        success: false,
        error: err.toString(),
      };
    }
    // set addressCoordinates with dummy data
    // addressCoordinates = {
    //   longitude: 14.3035941,
    //   latitude: 48.3010965,
    // };

    if (isCoordinates(addressCoordinates)) {
      // addressCoordinates is a Coordinates object, so you can access its properties here
      addressCoordinates.longitude = addressCoordinates.longitude;
      addressCoordinates.latitude = addressCoordinates.latitude;
      // ...
    } else {
      // addressCoordinates is a CoordinatesError object, so you can handle the error here
      return {
        success: false,
        error: addressCoordinates.error,
      };
    }
    let distance;

    // let distance: number = 50;
    if (addressCoordinates != null) {
      distance = getDistanceFromLatLonInMeters(
        deviceLatitudeCoordinate,
        deviceLongitudeCoordinate,
        addressCoordinates.latitude,
        addressCoordinates.longitude
      );
      if (distance > MAX_DISTANCE_METERS) {
        return {
          success: false,
          error:
            "Bitte schalten deinen Standort in den Einstellungen > Standort > Genauen Standort verwenden um die Adresse zu bestätigen.",
        };
      }
      const uid = context.auth?.uid;
      if (distance <= MAX_DISTANCE_METERS) {
        const coordinates = new GeoPoint(
          addressCoordinates.latitude,
          addressCoordinates.longitude
        );
        const deviceCoordinates = new GeoPoint(
          deviceLatitudeCoordinate,
          deviceLongitudeCoordinate
        );

        const userRef = db
          .collection("users")
          .doc(uid)
          .collection("userInternInfo")
          .doc(uid);

        await userRef.set({
          addressCoordinates: coordinates,
          deviceCoordinates: deviceCoordinates,
          distanceOfDeviceAndAddressInMeter: distance,
        });

        return {
          success: true,
        };
      } else {
        return {
          success: false,
          error:
            "Deine Addresse ist zu weit von deinem Standort entfernt. Bitte versuche es erneut.",
        };
      }
    } else {
      return {
        success: false,
        error:
          "Address is not in the radius of 40m Distance: " + distance + "m",
      };
    }
  });

