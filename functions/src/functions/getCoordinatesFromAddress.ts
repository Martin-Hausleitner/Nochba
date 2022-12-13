import { Client, GeocodeResponse } from "@googlemaps/google-maps-services-js";

const client = new Client({});

interface Coordinates {
  longitude: number;
  latitude: number;
}

export async function getCoordinatesFromAddress(
  address: string
): Promise<Coordinates | undefined> {
  const geocodeResponse: GeocodeResponse = await client.geocode({
    params: {
      address,
      key: "",
    },
  });

  const location = geocodeResponse.data.results[0].geometry.location;
  const addressCoordinates = {
    longitude: location.lng,
    latitude: location.lat,
  };

  return addressCoordinates;
}
