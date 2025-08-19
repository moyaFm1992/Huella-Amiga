import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Añade esta dependencia
import 'package:take_care_pets/screens/main_menu.dart';
import 'package:take_care_pets/screens/onboarding_screen.dart'; // Importa el onboarding
import 'no_connection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkInternetAndNavigate();
  }

  Future<void> _checkInternetAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3)); // Tiempo de splash

    final connectivityResult = await Connectivity().checkConnectivity();
    final hasInternet = await InternetConnectionChecker().hasConnection;

    if (connectivityResult != ConnectivityResult.none && hasInternet) {
      final prefs = await SharedPreferences.getInstance();
      final seenOnboarding = prefs.getBool("seenOnboarding") ?? false;

      if (seenOnboarding) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainMenu()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          (route) => false,
        );
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NoConnectionScreen()),
        (route) => false,
      );
    }
  }

  // El resto del código permanece igual...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/logo.png",
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Rescata, cuida, ama, cambia una vida.',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black45,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
