import 'package:flutter/material.dart';

import 'package:take_care_pets/services/api_service.dart';
import 'package:take_care_pets/models/dog.dart';
import 'package:take_care_pets/screens/add_dog_screen.dart';
import 'package:take_care_pets/widgets/dog_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Dog>> futureDogs;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureDogs = ApiService.getDogs();
  }

  void _refreshDogs() {
    setState(() {
      futureDogs = ApiService.getDogs();
    });
  }

  void _searchByDescription() {
    final desc = _searchController.text.trim();
    if (desc.isEmpty) {
      _refreshDogs();
    } else {
      setState(() {
        futureDogs = ApiService.getDogDesc(desc);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rescata, cuida, ama'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchByDescription,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _refreshDogs,
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Dog>>(
              future: futureDogs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No se encontraron registros'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Dog dog = snapshot.data![index];
                      return DogCard(
                        dog: dog,
                        onChangeStatus: () async {
                          await ApiService.updateDog(dog.id);

                          _refreshDogs(); // Refresca la lista
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDogScreen()),
          );
          _refreshDogs();
        },
        backgroundColor: Colors
            .transparent, // Fondo transparente para que solo se vea la imagen
        elevation: 4,
        child: Image.asset(
          'assets/images/add_button.png', // Ruta de tu imagen
          width: 32, // Ancho recomendado
          height: 32, // Alto recomendado
          fit: BoxFit.contain, // Ajuste de la imagen
        ), // Sombra del botón
      ),
    );
  }
}
