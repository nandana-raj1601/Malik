// lib/models/college.dart
class College {
  final String name;
  final String course;
  final String country;
  bool isInterested; // Not final if you want to toggle it easily

  College({
    required this.name,
    required this.course,
    required this.country,
    this.isInterested = false,
  });
}
