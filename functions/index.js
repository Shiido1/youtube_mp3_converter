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
// exports.getSubCollections = functions.https.onCall(async (data, context) => {
//   const docPath = data.docPath;
//   const collections = await admin.firestore().doc(docPath).listCollections();
//   const collectionIds = collections.map((col) => col.id);
//   return { collections: collectionIds };
// });

exports.createUser = functions.https.onCall(async (data, context) => {
  const name = data.name;
  const id = data.id;
  const url = data.url;
  await admin.database().ref("users").child(id).set({
    name: name,
    photoUrl: url,
  });
});

exports.updatePhoto = functions.https.onCall(async (data, context) => {
  const id = data.id;
  const url = data.url;
  await admin.database().ref("users").child(id).update({
    photoUrl: url,
  });
});
