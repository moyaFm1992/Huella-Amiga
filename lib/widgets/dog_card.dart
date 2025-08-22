import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:take_care_pets/models/dog.dart';
import 'package:take_care_pets/screens/dog_detail_screen.dart';
import 'package:intl/intl.dart';

class DogCard extends StatelessWidget {
  final Dog dog;
  final VoidCallback onChangeStatus; // callback para cambiar estado

  const DogCard({
    super.key,
    required this.dog,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(dog.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) => onChangeStatus(),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: Icons.sync,
          ),
        ],
      ),
      child: GestureDetector(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: _buildDogImage(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          dog.description,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ubicación: ${dog.latitude.toStringAsFixed(4)}, ${dog.longitude.toStringAsFixed(4)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Reportado el ${DateFormat('dd/MM/yyyy hh:mm a').format(dog.createdAt.toLocal())}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDogImage() {
    if (dog.photoPath == null || dog.photoPath!.isEmpty) {
      return Image.asset(
        'assets/images/empty.png',
        fit: BoxFit.cover,
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
