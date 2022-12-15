import * as functions from "firebase-functions";
import { getCoordinatesFromAddress } from "../functions/getCoordinatesFromAddress";
import { getDistanceFromLatLonInMeters } from "../functions/getDistanceFromLatLonInMeters";

interface Coordinates {
  longitude: number;
  latitude: number;
}

const MAX_DISTANCE_METERS = 50;

export const checkAddressWithDeviceLocation = functions
  .runWith({
    enforceAppCheck: true, // Requests without valid App Check tokens will be rejected.
  })
  .https.onCall(async (data) => {
    const { address, deviceLongitudeCoordinate, deviceLatitudeCoordinate } =
      data;

    let addressCoordinates: Coordinates | undefined;
    try {
      addressCoordinates = await getCoordinatesFromAddress(address);
    } catch (err) {
      return {
        success: false,
        error: err.toString(),
      };
    }

    let distance: number = 50;
    if (addressCoordinates != null) {
      distance = getDistanceFromLatLonInMeters(
        deviceLatitudeCoordinate,
        deviceLongitudeCoordinate,
        addressCoordinates.latitude,
        addressCoordinates.longitude
      );
      if (distance > 50) {
        return {
          success: false,
          error:
            "Bitte schalten deinen Standort in den Einstellungen > Standort > Genauen Standort verwenden um die Adresse zu bestätigen.",
        };
      }
      if (distance <= 50) {
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
