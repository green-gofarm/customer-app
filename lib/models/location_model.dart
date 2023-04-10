class LocationModel {
  final double latitude;
  final double longitude;

  LocationModel({required this.latitude, required this.longitude});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['lat'] ?? 0.0,
      longitude: json['lon'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'lat': latitude,
    'lon': longitude,
  };
}