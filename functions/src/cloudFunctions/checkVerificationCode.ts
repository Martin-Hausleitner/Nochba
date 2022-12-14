import * as functions from "firebase-functions";
import * as firebase from "firebase-admin";
import { getDistanceFromLatLonInMeters } from "../functions/getDistanceFromLatLonInMeters";
import { getCoordinatesFromAddress } from "../functions/getCoordinatesFromAddress";

interface Coordinates {
  longitude: number;
  latitude: number;
}

const firestore = firebase.firestore();

async function verifyVerificationCode(
  code: string,
  context: functions.https.CallableContext
): Promise<boolean> {
  // Verify the code using the existing `verifyVerificationCode` function
  if (!verifyVerificationCode(code)) {
    throw new functions.https.HttpsError("invalid-argument", "Invalid code");
  }

  // Check if the code exists in Firestore
  const snapshot = await firestore
    .collection("verificationCodes")
    .doc(code)
    .get();
  if (!snapshot.exists) {
    throw new functions.https.HttpsError("not-found", "Code not found");
  }

  // Get the current user from the context object
  const user = context.auth;
  if (!user) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User is not authenticated"
    );
  }

  // Get the address coordinates using the existing `getCoordinatesFromAddress` function
  let addressCoordinates: Coordinates | undefined;
  try {
    addressCoordinates = await getCoordinatesFromAddress(address);
  } catch (err: any) {
    // return {
    //   success: false,
    //   error: err.toString(),
    // };
  }

  // Calculate the distance between the address coordinates and the code's coordinates
  // using the existing `getDistanceFromLatLonInMeters` function
  const codeCoordinates = snapshot.get("addressCoordinates");
  const rangeInMeters = snapshot.get("rangeInMeters");
  const distance = getDistanceFromLatLonInMeters(
    addressCoordinates.lat,
    addressCoordinates.lng,
    codeCoordinates.lat,
    codeCoordinates.lng
  );

  // Check if the distance is within the specified range
  if (distance > rangeInMeters) {
    throw new functions.https.HttpsError(
      "out-of-range",
      "Code is out of range"
    );
  }

  // Add the current user to the list of users who have used the code
  await firestore
    .collection("verificationCodes")
    .doc(code)
    .update({
      usedForVerification: firebase.firestore.FieldValue.arrayUnion(user.uid),
    });

  // Write a reference to the code to the user's profile
  await firestore
    .collection("users")
    .doc(user.uid)
    .collection("userInternInfo")
    .doc(user.uid)
    .set({
      usedVerificationCodeRef: firestore.doc(`verificationCodes/${code}`),
    });

  return true;
}
