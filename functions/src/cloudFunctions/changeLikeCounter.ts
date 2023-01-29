import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

var db = admin.firestore();

export const incrementLikeCounter = functions
  .region("europe-west1")
  .firestore.document("users/{userId}/private/record/likedPosts/{likedPostId}")
  .onCreate(async (snapshot, context) => {
    const likedPostId = context.params.likedPostId;

    const likedPost = db.collection("posts").doc(likedPostId);

    await db.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(likedPost);
      const newLikeCounter = snapshot.get("likes") + 1;
      transaction.update(likedPost, { likes: newLikeCounter });
    });
  });

export const decrementLikeCounter = functions
  .region("europe-west1")
  .firestore.document("users/{userId}/private/record/likedPosts/{likedPostId}")
  .onDelete(async (snapshot, context) => {
    const likedPostId = context.params.likedPostId;

    const likedPost = db.collection("posts").doc(likedPostId);

    await db.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(likedPost);
      const newLikeCounter = snapshot.get("likes") - 1;
      transaction.update(likedPost, { likes: newLikeCounter });
    });
  });
