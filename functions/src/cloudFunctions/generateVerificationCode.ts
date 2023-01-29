import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { generateRandomVerificationCode } from "../functions/generateRandomVerificationCode";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

const GENERATION_INTERVAL = 24 * 60 * 60 * 1000; // 24 hours

const MAX_CODE_LIMIT = 1000;

const RANGE_IN_METERS = 1000;

const db = admin.firestore();

export const generateVerificationCode = functions.region('europe-west1').https.onCall(
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
    // const userInternRef = userRef.collection("intern").doc("address");
    // const userInternDoc = await userInternRef.get();
    const userPrivateRef = userRef.collection("private").doc("codes");
    const userPrivateDoc = await userPrivateRef.get();
    // const coordinates = userInternDoc.get("coords");
    logger.info(`User: ${uid} generating verification code.`);

    // get /users/Hs7OuEPhToXg6qPw1ejjuTOFgDo1/userPrivateInfo/Hs7OuEPhToXg6qPw1ejjuTOFgDo1/ lastGeneratedCode
    const lastGeneratedCodeDate = userPrivateDoc.get("lastGeneratedCodeDate");
    if (lastGeneratedCodeDate && lastGeneratedCodeDate !== null) {
      const currentTimestamp = Timestamp.fromDate(new Date());
      if (
        currentTimestamp.toMillis() - lastGeneratedCodeDate.toMillis() <
        GENERATION_INTERVAL
      ) {
        const lastGeneratedCode = userPrivateDoc.get("lastGeneratedCode");
        logger.info(
          `User: ${uid} got last verification code: ${lastGeneratedCode}`
        );
        return lastGeneratedCode;
      }
    }

    let verificationCode;
    while (true) {
      verificationCode = await generateRandomVerificationCode();
      const codeRef = db.collection("codes").doc(verificationCode);
      const codeSnapshot = await codeRef.get();
      if (!codeSnapshot.exists) {
        break;
      }
    }

    const coordsRef = userRef.collection("intern").doc("address").get();
    const coordsSnapshot = await coordsRef;
    const coordinates = coordsSnapshot.get("coords");
    if (!coordinates) {
      logger.error(`User: ${uid} has no coordinates`);
      throw new functions.https.HttpsError(
        "not-found",
        "You are not verified yet."
      );
    }

    const codeRef = db.collection("codes").doc(verificationCode);
    await codeRef.set({
      uid: context.auth.uid,
      isActive: true,
      addressCoordinate: coordinates,
      rangeInMeter: RANGE_IN_METERS,
      generationDate: FieldValue.serverTimestamp(),
      maxCodeLimit: MAX_CODE_LIMIT,
    });

    await userPrivateRef
      .collection("generatedCodes")
      .doc(verificationCode)
      .set({});

    await userPrivateRef.set(
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
