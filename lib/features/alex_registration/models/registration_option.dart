class RegistrationSchedule {
  const RegistrationSchedule({
    required this.title,
    required this.date,
    required this.time,
  });

  final String title;
  final String date;
  final String time;

  String get label => '$date · $time';
}

class RegistrationLocation {
  const RegistrationLocation({
    required this.name,
    required this.address,
  });

  final String name;
  final String address;
}
