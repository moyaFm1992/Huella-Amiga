import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../models/dog.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.100:3000/api';

  static Future<List<Dog>> getDogs() async {
    final response = await http.get(Uri.parse('$baseUrl/dogs'));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((i) => Dog.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to load dogs');
    }
  }

  static Future<List<Dog>> getNearbyDogs(double latitude, double longitude,
      [double radius = 5]) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/dogs/nearby?latitude=$latitude&longitude=$longitude&radius=$radius'));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((i) => Dog.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to load nearby dogs');
    }
  }

  static Future<Dog> createDog(
    String description,
    double latitude,
    double longitude, {
    File? imageFile,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/dogs'),
    );

    request.fields['description'] = description;
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();

    if (imageFile != null) {
      final fileStream = http.ByteStream(imageFile.openRead());
      final length = await imageFile.length();
      final multipartFile = http.MultipartFile(
        'photo',
        fileStream,
        length,
        filename: 'dog_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      request.files.add(multipartFile);
    }

    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return Dog.fromJson(jsonDecode(responseString));
    } else {
      throw Exception('Failed to create dog');
    }
  }

  static Future<Dog> getDog(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/dogs/$id'));
    if (response.statusCode == 200) {
      return Dog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load dog');
    }
  }

  static Future<Dog> getDogDesc(String desc) async {
    final response = await http.get(Uri.parse('$baseUrl/dogs/desc/$desc'));
    if (response.statusCode == 200) {
      return Dog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load dog description');
    }
  }

  static Future<void> deleteDog(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/dogs/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete dog');
    }
  }
}
