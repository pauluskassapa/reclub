enum ActivityTimeGroup { weekday, weekend }

class Activity {
  const Activity({
    required this.title,
    required this.category,
    required this.location,
    required this.schedule,
    required this.imagePath,
    required this.timeGroup,
    required this.participants,
    required this.capacity,
  });

  final String title;
  final String category;
  final String location;
  final String schedule;
  final String imagePath;
  final ActivityTimeGroup timeGroup;
  final int participants;
  final int capacity;
}
