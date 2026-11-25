import 'package:geolocator/geolocator.dart';

import '../data/nearby_locations.dart';

class DeviceLocationService {
  const DeviceLocationService();

  Future<NearbyLocation> getCurrentLocation() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw const DeviceLocationException(
        'Aktifkan GPS atau layanan lokasi perangkat terlebih dahulu.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const DeviceLocationException('Izin lokasi belum diberikan.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw const DeviceLocationException(
        'Izin lokasi diblokir. Aktifkan kembali dari pengaturan perangkat.',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );
    return NearbyLocation(
      name: 'Lokasi saya',
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}

class DeviceLocationException implements Exception {
  const DeviceLocationException(this.message);

  final String message;
}
