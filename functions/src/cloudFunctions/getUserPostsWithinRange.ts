import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as geofirestore from "geofirestore";
import { getDistanceFromLatLonInMeters } from "../functions/getDistanceFromLatLonInMeters";
//import { getNearestDistance } from "../functions/getNearestDistance";
import * as logger from "firebase-functions/logger";

const db = admin.firestore();
const geoFirestore = geofirestore.initializeApp(db);

export const getUserPostsWithinRange = functions.region('europe-west1').https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError(
            "unauthenticated",
            "The request is not authenticated. Seas"
        );
    }

    const uid = context.auth.uid;

    logger.log(`uid: ${uid}`);

    const range: number = data.range;

    var userLocation: admin.firestore.DocumentSnapshot;

    try {
        userLocation = await db.collection('userCoords').doc(uid).get();
    } catch (e) {
        throw new functions.https.HttpsError(
            "failed-precondition",
            "Failed to check verification."
        );
    }

    if (!userLocation) {
        throw new functions.https.HttpsError(
            "failed-precondition",
            "You are not verified."
        );
    }

    const { latitude, longitude } = userLocation.data().g['geopoint'];

    const geopoint = new admin.firestore.GeoPoint(latitude, longitude);

    const query = geoFirestore.collection('userCoords').near({ center: geopoint, radius: range / 1000 });
    const querySnapshot = await query.get();
    const filteredUsers = querySnapshot.docs.map(doc => doc.id);

    if (filteredUsers.length != 0) {
        const nearPosts = await db.collection('posts').where('uid', 'in', filteredUsers).get();
        const filteredPosts = await Promise.all(nearPosts.docs.map(async element => {
            var post = element.data();
            var user = await db.collection('userCoords').doc(post.uid).get();

            const distance = getDistanceFromLatLonInMeters(
                latitude,
                longitude,
                user.data().g['geopoint'].latitude,
                user.data().g['geopoint'].longitude
            );

            // await db.collection('test').add({
            //     post: element.id,
            //     distance: distance,
            //     range: post.range,
            //     isInRange: distance < post.range
            // });

            return distance < post.range ? element : null;
        }));
        const validPosts = filteredPosts.filter(element => element !== null);

        return validPosts.map(post => post.id);
    } else {
        return [];
    }
});