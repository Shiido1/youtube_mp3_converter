const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
exports.getSubCollections = functions.https.onCall(async (data, context) => {
  const docPath = data.docPath;
  const collections = await admin.firestore().doc(docPath).listCollections();
  const collectionIds = collections.map((col) => col.id);
  return { collections: collectionIds };
});
