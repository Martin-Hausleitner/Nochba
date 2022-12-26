import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { generateRandomVerificationCode } from "../functions/generateRandomVerificationCode";
import { FieldValue, GeoPoint, Timestamp } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

const GENERATION_INTERVAL = 24 * 60 * 60 * 1000; // 24 hours

const MAX_CODE_LIMIT = 1000;

const RANGE_IN_METERS = 1000;

const db = admin.firestore();

export const generateVerificationCode = functions.https.onCall(
  async (data, context) => {
    if (!context.auth) {
      logger.error("The request is not authenticated.");
      throw new functions.https.HttpsError(
        "unauthenticated",
        "The request is not authenticated."
      );
    }
    const uid = context.auth.uid;

    const userRef = db.collection("users").doc(uid);
    const userInternInfoRef = userRef.collection("userInternInfo").doc(uid);
    const userInternInfoDoc = await userInternInfoRef.get();
    const userPrivateInfoRef = userRef.collection("userPrivateInfo").doc(uid);
    const userPrivateInfoDoc = await userPrivateInfoRef.get();
    const coordinates = userInternInfoDoc.get("addressCoordinates");
    logger.info(`User: ${uid} generating verification code.`);

    // get /users/Hs7OuEPhToXg6qPw1ejjuTOFgDo1/userPrivateInfo/Hs7OuEPhToXg6qPw1ejjuTOFgDo1/ lastGeneratedCode
    const lastGeneratedCodeDate = userPrivateInfoDoc.get(
      "lastGeneratedCodeDate"
    );
    if (lastGeneratedCodeDate && lastGeneratedCodeDate !== null) {
      const currentTimestamp = Timestamp.fromDate(new Date());
      if (
        currentTimestamp.toMillis() - lastGeneratedCodeDate.toMillis() <
        GENERATION_INTERVAL
      ) {
        const lastGeneratedCode = userPrivateInfoDoc.get("lastGeneratedCode");
        logger.info(
          `User: ${uid} got last verification code: ${lastGeneratedCode}`
        );
        return lastGeneratedCode;
      }
    }

    let verificationCode;
    while (true) {
      verificationCode = await generateRandomVerificationCode();
      const codeRef = db.collection("verificationCodes").doc(verificationCode);
      const codeSnapshot = await codeRef.get();
      if (!codeSnapshot.exists) {
        break;
      }
    }

    if (!coordinates) {
      logger.error(`User: ${uid} has no coordinates`);
      throw new functions.https.HttpsError(
        "not-found",
        "You are not verified yet."
      );
    }

    const codeRef = db.collection("verificationCodes").doc(verificationCode);
    await codeRef.set({
      userId: context.auth.uid,
      isActive: true,
      addressCoordinate: coordinates,
      rangeInMeter: RANGE_IN_METERS,
      generationDate: FieldValue.serverTimestamp(),
      maxCodeLimit: MAX_CODE_LIMIT,
    });

    await userPrivateInfoRef
      .collection("generatedVerificationCodes")
      .doc(verificationCode)
      .set({});

    await userPrivateInfoRef.set(
      {
        lastGeneratedCodeDate: FieldValue.serverTimestamp(),
        lastGeneratedCode: verificationCode,
      },
      { merge: true }
    );

    logger.info(
      `User: ${uid} generated verification code: ${verificationCode}`
    );

    return verificationCode;
  }
);
