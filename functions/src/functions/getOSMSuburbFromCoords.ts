export async function getOSMSuburbFromCoords(
  lat: number,
  lon: number
): Promise<string> {
  const response = await fetch(
    `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lon}&zoom=18&addressdetails=1`
  );
  const data = await response.json();

  if (data.address.suburb) {
    return data.address.suburb;
  } else {
    // The API may not always return a suburb name, so you could return a different location detail instead, such as the city or town name.
    return data.address.city || data.address.town;
  }
}
