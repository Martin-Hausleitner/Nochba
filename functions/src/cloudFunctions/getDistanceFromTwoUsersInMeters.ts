import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { getDistanceFromLatLonInMeters } from "../functions/getDistanceFromLatLonInMeters";
import { getNearestDistance } from "../functions/getNearestDistance";

const db = admin.firestore();

export const getDistanceFromTwoUsersInMeters = functions.https.onCall(
  async (data, context) => {
    const userId: string = data.userId;
    const postId: string = data.postId;
    const currentUserId = context.auth?.uid;

    if (!userId || !currentUserId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "userId and currentUserId are required"
      );
    }

    // query under posts / postid / range to get the range
    const postSnapshot = await db.collection("posts").doc(postId).get();
    if (!postSnapshot.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "The specified post could not be found"
      );
    }
    const postData = postSnapshot.data();

    //check if post range is set
    if (!postData?.range) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Post range is required"
      );
    }
    const postRange = postData?.range;

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

    const snapshot = await admin
      .firestore()
      .doc(`/users/${userId}/userInternInfo/${userId}`)
      .get();
    const userAddressCoordinates = snapshot.data()?.addressCoordinates;

    const snapshot2 = await admin
      .firestore()
      .doc(`/users/${currentUserId}/userInternInfo/${currentUserId}`)
      .get();
    const currentUserAddressCoordinates = snapshot2.data()?.addressCoordinates;
    //

    // const userData = userSnapshot.data();
    // const currentUserData = currentUserSnapshot.data();

    // const userAddressCoordinates = userData?.userInternInfo.addressCoordinates;
    // const currentUserAddressCoordinates =
    //   currentUserData?.userInternInfo.addressCoordinates;

    if (!userAddressCoordinates || !currentUserAddressCoordinates) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Coordinates for both users are required: " +
          userAddressCoordinates +
          " " +
          currentUserAddressCoordinates
      );
    }

    const distance = getDistanceFromLatLonInMeters(
      userAddressCoordinates.latitude,
      userAddressCoordinates.longitude,
      currentUserAddressCoordinates.latitude,
      currentUserAddressCoordinates.longitude
    );

    if (distance > postRange) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "The specified user is out of range:" +
          postRange +
          "m" +
          " Distance: " +
          distance +
          "m"
      );
    }

    // getNearestDistance

    return getNearestDistance(distance);
  }
);
