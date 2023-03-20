// import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// firebase emulators:start --only functions
// cd functions/ && tsc -w

// firebase functions:secrets:set GOOGLE_MAPS_API_KEY

// Initialize Firebase app
admin.initializeApp();

export { generateVerificationCode } from "./cloudFunctions/generateVerificationCode";
export { checkAddress } from "./cloudFunctions/checkAddress";
export { checkAddressWithDeviceLocation } from "./cloudFunctions/checkAddressWithDeviceLocation";
export { getDistanceFromTwoUsers } from "./cloudFunctions/getDistanceFromTwoUsers";
export { getDistanceToOtherUser } from "./cloudFunctions/getDistanceToOtherUser";
export { checkVerificationCode } from "./cloudFunctions/checkVerificationCode";
export {
  incrementLikeCounterOfPost,
  decrementLikeCounterOfPost,
  incrementLikeCounterOfComment,
  decrementLikeCounterOfComment
} from "./cloudFunctions/changeLikeCounter";
export { getUserPostsWithinRange } from "./cloudFunctions/getUserPostsWithinRange";
// export { createUser } from "./cloudFunctions/createUser.ts.old";
// Get a reference to the Firestore database
//firebase emulators:start
// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", { structuredData: true });
//   response.send("Hello from Firebasedddrrrr!tthhh");
// });
