import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { getDistanceFromLatLonInMeters } from "../functions/getDistanceFromLatLonInMeters";
import { getNearestDistance } from "../functions/getNearestDistance";
import * as logger from "firebase-functions/logger";

const db = admin.firestore();

export const getDistanceFromTwoUsers = functions.https.onCall(
  async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "The request is not authenticated."
      );
    }
    const uid = context.auth.uid;
    const postId: string = data.postId;

    // query under posts / postid / range to get the range
    const postSnapshot = await db.collection("posts").doc(postId).get();
    if (!postSnapshot.exists) {
      logger.error("The specified post could not be found: " + postId);
      throw new functions.https.HttpsError(
        "not-found",
        "The specified post could not be found"
      );
    }
    const postData = postSnapshot.data();

    //if postdata user is null throw error else save the user id as post user id
    if (!postData?.uid) {
      logger.error("Post user is required");
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Post user is required"
      );
    }
    const postUserId = postData?.uid;

    //check if post range is set
    if (!postData?.range) {
      logger.error("Post range is required" + postData?.range);
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Post range is required"
      );
    }
    const postRange = postData?.range;

    const postUserSnapshot = await db
      .collection("users")
      .doc(postUserId)
      .collection("intern")
      .doc(postUserId)
      .get();
    const userSnapshot = await db
      .collection("users")
      .doc(uid)
      .collection("intern")
      .doc(uid)
      .get();

    if (!postUserSnapshot.exists || !userSnapshot.exists) {
      logger.error(
        `The specified user could not be found: ${postUserSnapshot.exists} ${postUserId} ${userSnapshot.exists} ${uid} `
      );
      throw new functions.https.HttpsError(
        "not-found",
        "The specified user could not be found"
      );
    }

    const snapshot = await db
      .collection("users")
      .doc(postUserId)
      .collection("intern")
      .doc(postUserId)
      .get();
    const userAddressCoordinates = snapshot.data()?.addressCoordinates;

    const snapshot2 = await db
      .collection("users")
      .doc(uid)
      .collection("intern")
      .doc(uid)
      .get();
    const currentUserAddressCoordinates = snapshot2.data()?.addressCoordinates;

    if (!userAddressCoordinates || !currentUserAddressCoordinates) {
      logger.error(
        "Coordinates for both users are required: " +
        postUserId +
        " " +
        uid +
        currentUserAddressCoordinates +
        userAddressCoordinates
      );

      throw new functions.https.HttpsError(
        "invalid-argument",
        "Error: while getting coordinates for both users"
      );
    }

    const distance = getDistanceFromLatLonInMeters(
      userAddressCoordinates.latitude,
      userAddressCoordinates.longitude,
      currentUserAddressCoordinates.latitude,
      currentUserAddressCoordinates.longitude
    );

    if (distance > postRange) {
      logger.error(
        `The specified user is out of range: ${distance} > ${postRange}`
      );
      throw new functions.https.HttpsError(
        "invalid-argument",
        "The specified user is out of range"
      );
    }
    logger.info(`User: ${uid} got the range of post: ${postId}`);

    return getNearestDistance(distance);
  }
);
