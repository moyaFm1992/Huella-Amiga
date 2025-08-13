import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DogLocationScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const DogLocationScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final point = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Punto de localización'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: point,
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: point,
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_pin,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
