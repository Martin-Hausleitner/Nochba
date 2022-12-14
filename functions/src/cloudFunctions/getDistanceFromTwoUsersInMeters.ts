import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { getDistanceFromLatLonInMeters } from "../functions/getDistanceFromLatLonInMeters";

const db = admin.firestore();

export const getDistanceFromTwoUsersInMeters = functions.https.onCall(
  async (data, context) => {
    const userId = data.userId;
    const currentUserId = context.auth?.uid;

    if (!userId || !currentUserId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "userId and currentUserId are required"
      );
    }

    const userSnapshot = await db.collection("users").doc(userId).get();
    const currentUserSnapshot = await db
      .collection("users")
      .doc(currentUserId)
      .get();

    if (!userSnapshot.exists || !currentUserSnapshot.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "The specified user could not be found"
      );
    }

    const userData = userSnapshot.data();
    const currentUserData = currentUserSnapshot.data();

    const userCoords = userData?.userInternInfo?.[userId]?.add;
    const currentUserCoords =
      currentUserData?.userInternInfo?.[currentUserId]?.add;

    if (!userCoords || !currentUserCoords) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Coordinates for both users are required"
      );
    }

    const distance = getDistanceFromLatLonInMeters(
      userCoords.lat,
      userCoords.lng,
      currentUserCoords.lat,
      currentUserCoords.lng
    );

    return { distance };
  }
);
