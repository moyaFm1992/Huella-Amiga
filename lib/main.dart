import 'package:flutter/material.dart';
import 'package:take_care_pets/screens/main_menu.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perro callejeros',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
        ).copyWith(
          primary: const Color(0xFF2C5364), // Rojo oscuro
          secondary: const Color(0xFFD32F2F), // Rojo de acento
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF2C5364),
          unselectedItemColor: Colors.grey,
        ),
      ),
      initialRoute: "splash",
      routes: {
        "splash": (context) => const SplashScreen(),
        "menu": (context) => MainMenu(),
      },
    );
  }
}
