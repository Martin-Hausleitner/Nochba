bool checkAddress(String address, List<double> coordinates) {
  // Convert the address to coordinates using the geocoder package
  final coords = await Geocoder.local.findAddressesFromQuery(address);
  final latitude = coords.first.coordinates.latitude;
  final longitude = coords.first.coordinates.longitude;

  // Check if the address coordinates are within the given coordinates
  return (latitude > coordinates[0] && latitude < coordinates[2]) &&
         (longitude > coordinates[1] && longitude < coordinates[3]);
}