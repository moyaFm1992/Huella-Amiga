import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io'; // Para File y path
import 'package:path/path.dart' as path_lib;
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
    final uri = Uri.parse('${ApiService.baseUrl}/dogs');
    var request = http.MultipartRequest('POST', uri);

    request.fields['description'] = description;
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return Dog.fromJson(json.decode(responseBody));
    } else {
      throw Exception(
          'Error al crear perro: ${json.decode(responseBody)['error']}');
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

  static Future<List<Dog>> getDogDesc(String desc) async {
    final encodedDesc = Uri.encodeComponent(desc); // Codifica el texto
    final response =
        await http.get(Uri.parse('$baseUrl/dogs/desc/$encodedDesc'));

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((json) => Dog.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      return []; // Retorna lista vacía si no encuentra resultados
    } else {
      throw Exception('Failed to load dogs by description');
    }
  }

  static Future<void> deleteDog(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/dogs/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete dog');
    }
  }

  static Future<Dog> updateDog(int id) async {
    print(id);
    final response = await http.put(Uri.parse('$baseUrl/dogs/status/$id'));

    if (response.statusCode == 200) {
      return Dog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to change status');
    }
  }
}
