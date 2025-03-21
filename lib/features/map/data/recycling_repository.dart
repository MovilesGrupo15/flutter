import 'recycling_point_model.dart';

class RecyclingRepository {
  Future<List<RecyclingPoint>> getRecyclingPoints() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate API delay

    return [
      RecyclingPoint(
          name: "Recycling Point 1",
          latitude: 4.7110,
          longitude: -74.0721,
          description: "Plastics and glass accepted."),
      RecyclingPoint(
          name: "Recycling Point 2",
          latitude: 4.7150,
          longitude: -74.0780,
          description: "Metal and electronics recycling."),
    ];
  }
}
