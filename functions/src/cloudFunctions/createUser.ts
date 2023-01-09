import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

var db = admin.firestore();

export const createUser = functions.firestore
    .document('users/{userId}')
    .onCreate(async (snapshot, context) => {
        const userId = context.params.userId;

        await db.collection('users').doc(userId).collection('test').doc().set({});

        logger.log('User was created');
    });
