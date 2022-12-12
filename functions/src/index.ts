import * as functions from "firebase-functions";
import { Client, GeocodeResponse } from "@googlemaps/google-maps-services-js";

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const client = new Client({});

export const checkAddress = functions.https.onCall(async (data) => {
  const { address, deviceLongitudeCoordinate, deviceLatitudeCoordinate } = data;

  interface Coordinates {
    longitude: number;
    latitude: number;
  }

  //   const addressCoordinates = await getCoordinatesFromAddress(address); use try catch
  let addressCoordinates: Coordinates | undefined;
  try {
    addressCoordinates = await getCoordinatesFromAddress(address);
  } catch (err: any) {
    return {
      success: false,
      error: err.toString(),
    };
  }

  //delcare distance as number
  let distance: number = 0;
  if (addressCoordinates != null) {
    distance = getDistanceFromLatLonInMeters(
      deviceLatitudeCoordinate,
      deviceLongitudeCoordinate,
      addressCoordinates.latitude,
      addressCoordinates.longitude
    );
    console.log(distance);
    if (distance < 40) {
      return {
        success: true,
      };
    }
  } else {
    return {
      success: false,
      // return error that it is not it the radius of 40m show the variable distance
      error: "Address is not in the radius of 40m Distance: " + distance + "m",
    };
  }
  // return undefined; error
  return {
    success: false,
    error: "I Dont Know",
  };

  //create interface addressCoordinates

  //write a function which calls the google maps api and returns the coordinates of the address
  async function getCoordinatesFromAddress(
    address: string
  ): Promise<Coordinates | undefined> {
    const geocodeResponse: GeocodeResponse = await client.geocode({
      params: {
        address,
        key: functions.config().googlemaps.key,
      },
    });

    const location = geocodeResponse.data.results[0].geometry.location;
    const addressCoordinates = {
      longitude: location.lng,
      latitude: location.lat,
    };

    return addressCoordinates;
  }

  function getDistanceFromLatLonInMeters(
    lat1: number,
    lon1: number,
    lat2: number,
    lon2: number
  ): number {
    const R = 6371e3; // radius of Earth in meters
    const φ1 = lat1 * (Math.PI / 180); // convert lat1 to radians
    const φ2 = lat2 * (Math.PI / 180); // convert lat2 to radians
    const Δφ = (lat2 - lat1) * (Math.PI / 180); // difference in latitudes, converted to radians
    const Δλ = (lon2 - lon1) * (Math.PI / 180); // difference in longitudes, converted to radians

    const a =
      Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
      Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    const d = R * c; // distance in meters
    return d;
  }
});
