import { Client, GeocodeResponse } from "@googlemaps/google-maps-services-js";
import * as functions from "firebase-functions";
import { GeoPoint } from "firebase-admin/firestore";

// import const { defineInt, defineString } = require('firebase-functions/params');
//convert google maps api key to string

const client = new Client({});

export async function getCoordinatesFromAddress(
  address: string
  //google map api key
): Promise<GeoPoint> {
  try {
    const geocodeResponse: GeocodeResponse = await client.geocode({
      params: {
        address,
        key: process.env.GOOGLE_MAPS_API_KEY,
      },
    });
    return new GeoPoint(
      geocodeResponse.data.results[0].geometry.location.lat,
      geocodeResponse.data.results[0].geometry.location.lng
    );
  } catch (error) {
    console.error(error);
    throw new functions.https.HttpsError(
      "internal",
      "There was an error while trying to retrieve coordinates from the provided address:" +
        error
    );
  }
}
