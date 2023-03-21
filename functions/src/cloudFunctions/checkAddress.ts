import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import { getOSMCoordinatesFromAddress } from "../functions/getOSMCoordinatesFromAddress";
import * as logger from "firebase-functions/logger";

const db = admin.firestore();

export const checkAddress = functions.region('europe-west1')
    .https.onCall(async (data, context) => {

        logger.info('Enter CheckAddress');

        if (!context.auth) {
            throw new functions.https.HttpsError(
                "unauthenticated",
                "The request is not authenticated."
            );
        }
        const uid: string = context.auth.uid;

        logger.info(`User: ${uid}`);

        const { street, streetNumber, city, zip } =
            data as { street: string, streetNumber: string, city: string, zip: string };

        if (!street || !streetNumber || !city || !zip) {
            throw new functions.https.HttpsError(
                "invalid-argument",
                "Missing required data. Please provide valid address data."
            );
        }

        const address: string = street + ' ' + streetNumber + ', ' + zip + ' ' + city + ', Austria';

        logger.info(`Address: ${address}`);

        let addressCoordinates;
        try {
            addressCoordinates = await getOSMCoordinatesFromAddress(address);
        } catch (error) {
            throw new functions.https.HttpsError(
                "invalid-argument",
                "Error getting coordinates from address. Error: " + error
            );
        }

        logger.info(`Latitude: ${addressCoordinates.latitude}, Longitude: ${addressCoordinates.longitude}`);

        try {
            await db.collection('user').doc(uid).collection('private').doc('address').create({
                'street': street,
                'streetNumber': streetNumber,
                'city': city,
                'zip': zip
            });
        } catch (e) {
        }

        return true;
    });
