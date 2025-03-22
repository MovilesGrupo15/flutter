class RecyclingPoint {
  final String name;
  final double latitude;
  final double longitude;
  final String description;

  RecyclingPoint({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
  });

  factory RecyclingPoint.fromJson(Map<String, dynamic> json) {
    return RecyclingPoint(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      description: json['description'],
    );
  }
}
