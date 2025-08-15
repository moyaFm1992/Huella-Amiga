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
      id: json['id'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      photoPath: json['photo_path'] as String?,
      latitude: json['latitude'] != null
          ? double.parse(json['latitude'].toString())
          : 0.0,
      longitude: json['longitude'] != null
          ? double.parse(json['longitude'].toString())
          : 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
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
