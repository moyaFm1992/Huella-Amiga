import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener dimensiones y orientación del dispositivo
    final screenSize = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fondo degradado
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                // Para evitar overflow en landscape
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo (tamaño ajustado según orientación)
                      Image.asset(
                        "assets/icons/logo.png",
                        width: isPortrait
                            ? screenSize.width * 0.5
                            : screenSize.width * 0.3,
                      ),
                      SizedBox(height: isPortrait ? 30 : 20),

                      // Nombre de la app (tamaño de texto adaptable)
                      Text(
                        'Huella Amiga App',
                        style: TextStyle(
                          fontSize: isPortrait ? 26 : 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: const [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black45,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: isPortrait ? 20 : 15),

                      // Desarrollador
                      const Text(
                        'Desarrollado por: FAMCH',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color: Colors.black45,
                              offset: Offset(1.5, 1.5),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 10),

                      // Versión
                      const Text(
                        'Versión: 1.0.0',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Año
                      Text(
                        '© ${DateTime.now().year}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),

                      SizedBox(height: isPortrait ? 40 : 25),

                      // Derechos
                      const Text(
                        'Todos los derechos reservados.',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black45,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
