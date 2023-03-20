import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { getDistanceFromLatLonInMeters } from "../functions/getDistanceFromLatLonInMeters";
import { getNearestDistance } from "../functions/getNearestDistance";
import * as logger from "firebase-functions/logger";

const db = admin.firestore();

export const getDistanceToOtherUser = functions.region('europe-west1').https.onCall(
    async (data, context) => {
        if (!context.auth) {
            throw new functions.https.HttpsError(
                "unauthenticated",
                "The request is not authenticated."
            );
        }
        const uid = context.auth.uid;
        const userId: string = data.userId;

        const postUserSnapshot = await db
            .collection("users")
            .doc(userId)
            .collection("intern")
            .doc("address")
            .get();
        const userSnapshot = await db
            .collection("users")
            .doc(uid)
            .collection("intern")
            .doc("address")
            .get();

        if (!postUserSnapshot.exists || !userSnapshot.exists) {
            logger.error(
                `The specified user could not be found: ${postUserSnapshot.exists} ${userId} ${userSnapshot.exists} ${uid} `
            );
            throw new functions.https.HttpsError(
                "not-found",
                "The specified user could not be found"
            );
        }

        const snapshot = await db
            .collection("users")
            .doc(userId)
            .collection("intern")
            .doc("address")
            .get();
        const userAddressCoordinates = snapshot.data()?.coords;

        const snapshot2 = await db
            .collection("users")
            .doc(uid)
            .collection("intern")
            .doc("address")
            .get();
        const currentUserAddressCoordinates = snapshot2.data()?.coords;

        if (!userAddressCoordinates || !currentUserAddressCoordinates) {
            logger.error(
                "Coordinates for both users are required: " +
                userId +
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

        logger.info(`User: ${uid} got the distance: ${distance} to user: ${userId}`);

        return getNearestDistance(distance);
    }
);
