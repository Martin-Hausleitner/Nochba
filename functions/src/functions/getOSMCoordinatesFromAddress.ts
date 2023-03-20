import axios from "axios";
import * as admin from "firebase-admin";

export async function getOSMCoordinatesFromAddress(
  address: string
): Promise<admin.firestore.GeoPoint> {
  try {
    const response = await axios.get(
      `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(
        address
      )}`
    );
    const data = response.data;
    const firstResult = data[0];

    if (!firstResult) {
      throw new Error(`No results found for address: ${address}`);
    }

    return new admin.firestore.GeoPoint(Number(firstResult.lat), Number(firstResult.lon));
  } catch (error) {
    console.error(error);
    throw error;
  }
}
