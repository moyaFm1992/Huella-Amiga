import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_menu.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "title": "Bienvenido",
      "subtitle": "Rescata, cuida, ama, cambia una vida.",
      "image": "assets/icons/logo.png"
    },
    {
      "title": "Adopta",
      "subtitle": "Dale un hogar a un perrito sin familia.",
      "image": "assets/icons/adopt.png"
    },
    {
      "title": "Cuida",
      "subtitle": "Haz la diferencia cuidando y protegiendo.",
      "image": "assets/icons/care.png"
    },
  ];

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("seenOnboarding", true);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainMenu()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (_, index) {
              return Container(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(_pages[index]["image"]!, height: 200),
                    const SizedBox(height: 40),
                    Text(
                      _pages[index]["title"]!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _pages[index]["subtitle"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage < _pages.length - 1)
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: const Text(
                      "Saltar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color:
                            _currentPage == index ? Colors.white : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                if (_currentPage == _pages.length - 1)
                  ElevatedButton(
                    onPressed: _finishOnboarding,
                    child: const Text("Empezar"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
