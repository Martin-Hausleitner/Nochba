import * as functions from "firebase-functions";
import { getCoordinatesFromAddress } from "../functions/getCoordinatesFromAddress";
import { getDistanceFromLatLonInMeters } from "../functions/getDistanceFromLatLonInMeters";

interface Coordinates {
    longitude: number;
    latitude: number;
  }

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
    } catch (err: any) {
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
      console.log("Distance:" + distance);
      if (distance < 40) {
        return {
          success: true,
          distance: distance,
        };
      }
    } else {
      return {
        success: false,
        error:
          "Address is not in the radius of 40m Distance: " + distance + "m",
      };
    }

    return {
      success: false,
      error: "I Dont Know",
    };
  });