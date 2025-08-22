import 'package:flutter/material.dart';
import 'package:take_care_pets/models/dog.dart';
import 'package:take_care_pets/screens/dog_location_screen.dart';
import 'package:intl/intl.dart';

class DogDetailScreen extends StatelessWidget {
  final Dog dog;

  const DogDetailScreen({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen grande del perro
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: _buildDetailImage(),
            ),
            // Información detallada
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Descripción
                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dog.description,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  // Ubicación
                  Text(
                    'Ubicación',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DogLocationScreen(
                            latitude: dog.latitude,
                            longitude: dog.longitude,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.map),
                    label: const Text('Ver en mapa'),
                  ),

                  const SizedBox(height: 24),
                  // Fecha
                  Text(
                    'Fecha de reporte',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Reportado el ${DateFormat('dd/MM/yyyy').format(dog.createdAt)} a las ${DateFormat('hh:mm a').format(dog.createdAt)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailImage() {
    if (dog.photoPath == null || dog.photoPath!.isEmpty) {
      return Image.asset(
        'assets/images/empty.png',
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      'http://192.168.0.100:3000${dog.photoPath}',
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/empty.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
