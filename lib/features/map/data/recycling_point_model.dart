class RecyclingPoint {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String description;
  final String? address;
  double? distanceMeters;

  RecyclingPoint({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
    this.address,
    this.distanceMeters,
  });

  factory RecyclingPoint.fromJson(Map<String, dynamic> json) {
    return RecyclingPoint(
      id: json['id'],
      name: json['name'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      description: json['description'] ?? '',
      address: json['address'],
    );
  }
}