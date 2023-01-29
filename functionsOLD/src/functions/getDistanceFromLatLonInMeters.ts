// Source: https://www.movable-type.co.uk/scripts/latlong.html
export function getDistanceFromLatLonInMeters(
  lat1: number,
  lon1: number,
  lat2: number,
  lon2: number
) {
  if (lat1 < -90 || lat1 > 90 || lon1 < -180 || lon1 > 180) {
    throw new Error(
      "Invalid coordinate: lat1 must be between -90 and 90, lon1 must be between -180 and 180"
    );
  }
  if (lat2 < -90 || lat2 > 90 || lon2 < -180 || lon2 > 180) {
    throw new Error(
      "Invalid coordinate: lat2 must be between -90 and 90, lon2 must be between -180 and 180"
    );
  }
  const R = 6371; // Radius der Erde in km
  const dLat = deg2rad(lat2 - lat1); // deg2rad unten
  const dLon = deg2rad(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(deg2rad(lat1)) *
      Math.cos(deg2rad(lat2)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const d = R * c * 1000; // Distanz in Metern

  if (lat1 === lat2 && lon1 === lon2) return 0;
  return d;
}

function deg2rad(deg: number) {
  return deg * (Math.PI / 180);
}
