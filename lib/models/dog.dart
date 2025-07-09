class Dog {
  final int id;
  final String description;
  final String? photoPath;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  Dog({
    required this.id,
    required this.description,
    this.photoPath,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['id'],
      description: json['description'],
      photoPath: json['photo_path'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'photo_path': photoPath,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
