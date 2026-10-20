import 'dart:math' as math;

class NearbyLocation {
  const NearbyLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final double latitude;
  final double longitude;
}

const nearbyLocations = [
  NearbyLocation(name: 'Jakarta Pusat', latitude: -6.1865, longitude: 106.8342),
  NearbyLocation(
    name: 'Jakarta Selatan',
    latitude: -6.2615,
    longitude: 106.8106,
  ),
  NearbyLocation(name: 'Jakarta Barat', latitude: -6.168, longitude: 106.758),
  NearbyLocation(name: 'Jakarta Timur', latitude: -6.219, longitude: 106.900),
  NearbyLocation(name: 'Jakarta Utara', latitude: -6.128, longitude: 106.856),
  NearbyLocation(name: 'GBK', latitude: -6.218, longitude: 106.802),
];

double distanceInKm({
  required double fromLatitude,
  required double fromLongitude,
  required double toLatitude,
  required double toLongitude,
}) {
  const earthRadiusKm = 6371.0;
  final latDifference = _toRadians(toLatitude - fromLatitude);
  final lonDifference = _toRadians(toLongitude - fromLongitude);
  final haversine =
      _square(math.sin(latDifference / 2)) +
      math.cos(_toRadians(fromLatitude)) *
          math.cos(_toRadians(toLatitude)) *
          _square(math.sin(lonDifference / 2));

  return earthRadiusKm * 2 * math.asin(math.sqrt(haversine));
}

double _toRadians(double degrees) => degrees * 3.141592653589793 / 180;
double _square(double value) => value * value;
