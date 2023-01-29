import axios from "axios";

export async function getOSMSuburbFromCoords(
  lat: number,
  lon: number
): Promise<string> {
  try {
    const url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lon}&zoom=18&addressdetails=1`;
    const response = await axios.get(url);
    const data = response.data;
    if (data && data.address && data.address.suburb) {
      return data.address.suburb;
    } else {
      //if town is not null return town else return city else null
      if (data && data.address && data.address.town) {
        return data.address.town;
      }
      if (data && data.address && data.address.city) {
        return data.address.city;
      }
      return null;
    }
  } catch (error) {
    throw error;
  }
}
