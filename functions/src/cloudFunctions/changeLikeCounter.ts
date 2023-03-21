import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

var db = admin.firestore();

export const incrementLikeCounterOfPost = functions
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

export const decrementLikeCounterOfPost = functions
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


export const incrementLikeCounterOfComment = functions
  .region("europe-west1")
  .firestore.document("users/{userId}/private/record/likedComments/{likedCommentId}")
  .onCreate(async (snapshot, context) => {
    const likedCommentId = context.params.likedCommentId;
    const likedCommentRef = snapshot.ref;

    const likedComment = db.collection("posts").doc(likedCommentRef['post']).collection('comments').doc(likedCommentId);

    await db.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(likedComment);
      const newLikeCounter = snapshot.get("likes") + 1;
      transaction.update(likedComment, { likes: newLikeCounter });
    });
  });

export const decrementLikeCounterOfComment = functions
  .region("europe-west1")
  .firestore.document("users/{userId}/private/record/likedComments/{likedCommentId}")
  .onDelete(async (snapshot, context) => {
    const likedCommentId = context.params.likedCommentId;
    const likedCommentRef = snapshot.ref;

    const likedComment = db.collection("posts").doc(likedCommentRef['post']).collection('comments').doc(likedCommentId);

    await db.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(likedComment);
      const newLikeCounter = snapshot.get("likes") - 1;
      transaction.update(likedComment, { likes: newLikeCounter });
    });
  });

