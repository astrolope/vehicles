const functions = require('firebase-functions');

var admin = require("firebase-admin");

var serviceAccount = require("servicekey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://itrellis-dealership.firebaseio.com"
});

const app = require('express');

//Gets all cars from server endpoint.
app.get('/vehicles/all', (req, res) => {

    
  

});

//TODO: Handle 404 and errors

exports.api = functions.https.onRequest(app);
