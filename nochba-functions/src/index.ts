import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { Client, GeocodeResponse } from "@googlemaps/google-maps-services-js";

// Initialize Firebase app
admin.initializeApp();

// Get a reference to the Firestore database
const db = admin.firestore();

//firebase emulators:start
// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", { structuredData: true });
  response.send("Hello from Firebase!");
});

interface Coordinates {
  longitude: number;
  latitude: number;
}

async function getCoordinatesFromAddress(
  address: string
): Promise<Coordinates | undefined> {
  const geocodeResponse: GeocodeResponse = await client.geocode({
    params: {
      address,
      key: "",
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

function generateRandomVerificationCode(): string {
  const characters =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  let result = "";

  for (let i = 0; i < 10; i++) {
    result += characters.charAt(Math.floor(Math.random() * characters.length));
  }

  return result;
}

const client = new Client({});

export const checkAddressWithDeviceLocation = functions.https.onCall(
  async (data) => {
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
  }
);

export const generateVerificationCode = functions.https.onCall(
  async (data, context) => {
    // Check that the request is authenticated and that the user is authorized
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "The request is not authenticated."
      );
    }

    // Generate a random verification code
    const verificationCode = generateRandomVerificationCode();

    // Check if the code already exists in the database
    const codeRef = db.collection("verificationCodes").doc(verificationCode);
    const codeSnapshot = await codeRef.get();
    if (codeSnapshot.exists) {
      throw new functions.https.HttpsError(
        "already-exists",
        "The verification code already exists."
      );
    }

    // Get the user's coordinates from the database
    const userRef = db.collection("users").doc(context.auth.uid);
    const userSnapshot = await userRef.get();
    if (!userSnapshot.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "The user: " + context.auth.uid + " 1was not found in the database."
      );
    }
    const userData = userSnapshot.data();
    if (
      !userData ||
      !userData.userInternInfo ||
      !userData.userInternInfo.addressCoordinate
    ) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "6The user does not have a valid address coordinate."
      );
    }

    // Save the verification code in the database
    await codeRef.set({
      uid: context.auth.uid,
      active: true,
      addressCoordinate: userData.userInternInfo.addressCoordinate,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Return the verification code to the client
    return { verificationCode };
  }
);
