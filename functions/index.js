const functions = require('firebase-functions');

var admin = require("firebase-admin");

var serviceAccount = require("./key.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://itrellis-dealership.firebaseio.com"
});

const express = require('express');

var app = express()

var db = admin.database();
var vehicleRef = db.ref("vehicles");

//Gets all cars from server endpoint.
app.get('/vehicles/all', (req, res) => {
  var vehicles = [];

  // Attach an asynchronous callback to read the data at our posts reference
  vehicleRef.on("value", function (snapshot) {

    console.log(snapshot.val());
    vehicles = snapshot.val();
    console.log(vehicles);
    res.json(vehicles);

  }, function (errorObject) {

    res.status(500).send("The read failed: " + errorObject.code);
  });


});

//TODO: Handle 404 and errors
app.use(function (req, res, next) {
  res.status(404).send("Sorry can't find that!")
})

exports.api = functions.https.onRequest(app);