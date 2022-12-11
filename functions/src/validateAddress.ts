import * as firebase from 'firebase-admin';

export const validateAddress = (
  address: string,
  x: number,
  y: number
): boolean => {
  // Initialize Firebase App
  firebase.initializeApp();

  // Retrieve current location coordinates
  const currentLocation = new firebase.firestore.GeoPoint(x, y);

  // Use the "google-maps-geocoding" package to convert the address to coordinates
  const geocoder = require('google-maps-geocoding')({
    key: '<YOUR_GOOGLE_MAPS_API_KEY>'
  });
  geocoder.find(address, (err, res) => {
    if (err) {
      // Handle error
    }

    // Retrieve the latitude and longitude of the address
    const latitude = res[0].geometry.location.lat;
    const longitude = res[0].geometry.location.lng;

    // Convert the coordinates to a Firebase GeoPoint
    const addressLocation = new firebase.firestore.GeoPoint(latitude, longitude);

    // Calculate the distance between the two locations
    const distance = currentLocation.distance(addressLocation);

    // Return true if the distance is within 40 meters, and false otherwise
    return distance <= 40;
  });
}