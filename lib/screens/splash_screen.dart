import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.2, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const HomePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        },
        child: SafeArea(
          child: Column(
            children: [
              // Logo at the top
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Image.asset(
                  'images/logo_top.png',
                  width: 400,
                ),
              ),
              
              // Spinning Globe in the middle
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer glow effect
                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF005496).withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          // Spinning globe
                          const SpinKitDoubleBounce(
                            color: Color(0xFF005496),
                            size: 200.0,
                          ),
                          const SpinKitPulsingGrid(
                            color: Colors.white,
                            size: 180.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Touch to Start at the bottom
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: FadeTransition(
                  opacity: _animation,
                  child: const Text(
                    'Touch to Start',
                    style: TextStyle(
                      fontSize: 42,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ruda',
                      shadows: [
                        Shadow(
                          color: Color(0xFF005496),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
