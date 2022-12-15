import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// firebase emulators:start --only functions
// cd functions/ && tsc -w

// Initialize Firebase app
admin.initializeApp();

export { generateVerificationCode } from "./cloudFunctions/generateVerificationCode";
export { checkAddressWithDeviceLocation } from "./cloudFunctions/checkAddressWithDeviceLocation";
export { getDistanceFromTwoUsers } from "./cloudFunctions/getDistanceFromTwoUsers";
export { checkVerificationCode } from "./cloudFunctions/checkVerificationCode";
// Get a reference to the Firestore database
//firebase emulators:start
// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", { structuredData: true });
  response.send("Hello from Firebasedddrrrr!tthhh");
});
