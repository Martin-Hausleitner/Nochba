import axios from "axios";
import { GeoPoint } from "firebase-admin/firestore";

export async function getOSMCoordinatesFromAddress(
  address: string
): Promise<GeoPoint> {
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
    // return new GeoPoint(1.1, 1.1);
    
    return new GeoPoint(Number(firstResult.lat), Number(firstResult.lon));
  } catch (error) {
    // you can handle the error here
    console.error(error);
    throw "lol"+error; // or rethrow it if you want to propagate it up the call stack
  }
}
