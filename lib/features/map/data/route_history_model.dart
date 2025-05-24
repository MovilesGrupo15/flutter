class RouteHistory {
  final String pointId;
  final String pointName;
  final DateTime timestamp;

  RouteHistory({
    required this.pointId,
    required this.pointName,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'pointId': pointId,
        'pointName': pointName,
        'timestamp': timestamp.toIso8601String(),
      };

  factory RouteHistory.fromJson(Map<String, dynamic> json) => RouteHistory(
        pointId: json['pointId'],
        pointName: json['pointName'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
