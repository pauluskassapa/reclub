class ManagedEvent {
  const ManagedEvent({
    required this.name,
    required this.description,
    required this.dateTime,
    required this.location,
    required this.category,
  });

  final String name;
  final String description;
  final DateTime dateTime;
  final String location;
  final String category;
}