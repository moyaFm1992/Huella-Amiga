import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:take_care_pets/services/api_service.dart';
import 'package:geolocator/geolocator.dart';

class AddDogScreen extends StatefulWidget {
  const AddDogScreen({super.key});

  @override
  _AddDogScreenState createState() => _AddDogScreenState();
}

class _AddDogScreenState extends State<AddDogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  File? _imageFile;
  double? _latitude;
  double? _longitude;
  bool _isLoading = false;

  Future<void> _getImage() async {
    final status = await Permission.camera.request();

    if (status.isDenied) {
      // El usuario denegó el permiso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Se necesitan permisos de cámara para tomar fotos')),
      );
      return;
    }

    if (status.isPermanentlyDenied) {
      // El usuario denegó el permiso permanentemente
      // Puedes guiarlos a la configuración de la app
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Por favor habilita los permisos de cámara en la configuración')),
      );
      await openAppSettings();
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera, // Cambiado de gallery a camera
      preferredCameraDevice: CameraDevice.rear, // Opcional: usar cámara trasera
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _getLocation() async {
    // En una app real, aquí usarías el paquete geolocator
    // Esto es solo para simulación
    setState(() {
      _latitude = 19.4326; // Ejemplo: Ciudad de México
      _longitude = -99.1332;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ubicación obtenida: CDMX (simulado)')),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor obtén tu ubicación primero')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService.createDog(
        _descriptionController.text,
        _latitude!,
        _longitude!,
        imageFile: _imageFile,
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar avistamiento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  height: 200,
                  fit: BoxFit.cover,
                )
              else
                const Icon(Icons.pets, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getImage,
                child: const Text('Tomar Foto'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_latitude != null && _longitude != null)
                Text(
                  'Ubicación: ${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}',
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _getLocation,
                child: const Text('Obtener Ubicación Actual'),
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Reportar Perro'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
