import { Client, GeocodeResponse } from "@googlemaps/google-maps-services-js";
import * as functions from "firebase-functions";
// import const { defineInt, defineString } = require('firebase-functions/params');
//convert google maps api key to string

const client = new Client({});

interface Coordinates {
  longitude: number;
  latitude: number;
}

interface CoordinatesError {
  success: boolean;
  error: string;
}

export async function getCoordinatesFromAddress(
  address: string
  //google map api key
): Promise<Coordinates | CoordinatesError> {
  try {
    const geocodeResponse: GeocodeResponse = await client.geocode({
      params: {
        address,
        key: process.env.GOOGLE_MAPS_API_KEY,
      },
    });

    // Check if the response has any results
    if (geocodeResponse.data.results.length === 0) {
      return {
        success: false,
        error: "No results found for the given address",
      };
    }

    const location = geocodeResponse.data.results[0].geometry.location;
    const addressCoordinates = {
      longitude: location.lng,
      latitude: location.lat,
    };

    return { success: true, ...addressCoordinates };
  } catch (error) {
    return {
      success: false,
      error: error.message + "fuction" + functions.config(),
    };
  }
}
