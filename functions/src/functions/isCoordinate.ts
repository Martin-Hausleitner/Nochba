interface Coordinates {
  longitude: number;
  latitude: number;
}

interface CoordinatesError {
  success: boolean;
  error: string;
}

export function isCoordinates(
  coordinates: Coordinates | CoordinatesError
): coordinates is Coordinates {
  return (coordinates as Coordinates).latitude !== undefined;
}
