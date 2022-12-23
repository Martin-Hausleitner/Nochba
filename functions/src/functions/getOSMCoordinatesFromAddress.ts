//import node fetch
import fetch from "node-fetch";

export async function getOSMCoordinatesFromAddress(
  address: string
): Promise<[number, number]> {
  const response = await fetch(
    `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(
      address
    )}`
  );
  const data = await response.json();
  const firstResult = data[0];

  if (!firstResult) {
    throw new Error(`No results found for address: ${address}`);
  }

  return [Number(firstResult.lat), Number(firstResult.lon)];
}
