import 'package:flutter/material.dart';
import 'package:take_care_pets/models/dog.dart';
import 'package:take_care_pets/screens/dog_detail_screen.dart';

class DogCard extends StatelessWidget {
  final Dog dog;

  const DogCard({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DogDetailScreen(dog: dog),
            ),
          );
        },
        child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Alinea los elementos en la parte superior
              children: [
                // Imagen a la izquierda (ancho fijo)
                SizedBox(
                  width: 120, // Ancho deseado para la imagen
                  height: 120, // Alto deseado (cuadrado)
                  child: _buildDogImage(),
                ),
                // Texto a la derecha (ocupa el resto del espacio)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width:
                              double.infinity, // Ocupa todo el ancho disponible
                          child: Text(
                            dog.description,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold, // Texto en negritas
                            ),
                            textAlign: TextAlign.justify, // Texto justificado
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ubicación: ${dog.latitude.toStringAsFixed(4)}, ${dog.longitude.toStringAsFixed(4)}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Reportado el: ${dog.createdAt.day}/${dog.createdAt.month}/${dog.createdAt.year}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }

  Widget _buildDogImage() {
    if (dog.photoPath == null || dog.photoPath!.isEmpty) {
      return Image.asset(
        'assets/images/empty.png',
        fit:
            BoxFit.cover, // Cubre el espacio manteniendo la relación de aspecto
      );
    }

    return Image.network(
      'http://192.168.0.100:3000${dog.photoPath}',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/empty.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
