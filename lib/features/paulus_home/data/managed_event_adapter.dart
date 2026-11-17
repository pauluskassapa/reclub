import '../../defrigo_manage_event/models/managed_event.dart';
import '../models/activity.dart';
import 'nearby_locations.dart';

List<Activity> managedEventsToActivities(List<ManagedEvent> events) {
  return events.map(_toActivity).toList(growable: false);
}

Activity _toActivity(ManagedEvent event) {
  final normalizedLocation = event.location.toLowerCase();
  NearbyLocation? knownLocation;
  for (final location in nearbyLocations) {
    if (normalizedLocation.contains(location.name.toLowerCase())) {
      knownLocation = location;
      break;
    }
  }

  final date = event.dateTime;
  const weekdays = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');

  return Activity(
    title: event.name,
    category: event.category,
    location: event.location,
    schedule: '${weekdays[date.weekday - 1]}, $hour.$minute',
    imagePath: _imageForCategory(event.category),
    timeGroup: date.weekday >= DateTime.saturday
        ? ActivityTimeGroup.weekend
        : ActivityTimeGroup.weekday,
    participants: 0,
    capacity: 0,
    latitude: knownLocation?.latitude,
    longitude: knownLocation?.longitude,
  );
}

String _imageForCategory(String category) {
  return switch (category.toLowerCase()) {
    'sepak bola' || 'futsal' => 'assets/images/futsal.jpg',
    'basket' => 'assets/images/basket.jpg',
    'badminton' => 'assets/images/badminton.jpg',
    'lari' => 'assets/images/running.jpg',
    'voli' => 'assets/images/volleyball.jpg',
    'tenis' => 'assets/images/tennis.jpg',
    'sepeda' => 'assets/images/cycling.jpg',
    'renang' => 'assets/images/swimming.jpg',
    'yoga' => 'assets/images/yoga.jpg',
    'pingpong' => 'assets/images/pingpong.jpg',
    _ => 'assets/images/home_hero.jpg',
  };
}
