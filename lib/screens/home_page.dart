import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tut_student_kiosk/screens/dashboard_screen.dart';
import 'package:tut_student_kiosk/screens/payment_screen.dart';
import 'package:tut_student_kiosk/screens/wayfinder_screen.dart';
import '../widgets/grid_item.dart';
import '../widgets/animated_text.dart';
import '../widgets/inactivity_dialog.dart';
import 'chat_screen.dart';
import 'splash_screen.dart';

class HomePage extends StatefulWidget {
  final String studentNumber;
  const HomePage({super.key, this.studentNumber = "219123456"}); // Default value for demo

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _inactivityTimer;
  bool _dialogVisible = false;

  @override
  void initState() {
    super.initState();
    _resetInactivityTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(minutes: 2), _showInactivityDialog);
  }

  void _showInactivityDialog() {
    if (_dialogVisible) return;
    _dialogVisible = true;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => InactivityDialog(
        onTimeout: () {
          _dialogVisible = false;
          Navigator.of(context).pushReplacementNamed('/');
        },
        onContinue: () {
          _dialogVisible = false;
          _resetInactivityTimer();
        },
      ),
    );
  }

  void _handleUserInteraction([_]) {
    if (!_dialogVisible) {
      _resetInactivityTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF005496),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'images/logo_top.png',
              height: 40,
            ),
            const Spacer(),
            // Profile Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF005496),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.studentNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Logout Button
            IconButton(
              icon: const Icon(Icons.logout),
              color: Colors.white,
              tooltip: 'Logout',
              onPressed: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: _handleUserInteraction,
        onTapUp: _handleUserInteraction,
        onPanDown: _handleUserInteraction,
        onPanUpdate: _handleUserInteraction,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        const SizedBox(height: 80), // Added more vertical space
                        const Column(
                          children: [
                            AnimatedWelcomeText(
                              text: 'Welcome to TUT Kiosk',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF005496),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'What would you like to do?',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF666666),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 900, // Maximum width for the grid
                                maxHeight: constraints.maxHeight * 0.7, // Use 70% of available height
                              ),
                              child: GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                padding: const EdgeInsets.all(16),
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                children: [
                                  GridItem(
                                    icon: Icons.dashboard,
                                    color: const Color(0xFFE41936),
                                    label: 'Dashboard',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const DashboardScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  GridItem(
                                    icon: Icons.payment,
                                    color: const Color(0xFF005496),
                                    label: 'Pay',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const PaymentScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  GridItem(
                                    icon: Icons.smart_toy,
                                    color: const Color(0xFFF9BC0A),
                                    label: 'EduBot',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const ChatScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  GridItem(
                                    icon: Icons.map_rounded,
                                    color: const Color(0xFF2E8B57),
                                    label: 'Wayfinder',
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const WayfinderScreen(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSelection(BuildContext context, String label) {
    switch (label) {
      case 'Dashboard':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
        break;
      case 'EduBot':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatScreen(),
          ),
        );
        break;
      case 'Pay':
        // TODO: Implement Pay screen navigation
        break;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.logout,
                color: Color(0xFF005496),
              ),
              SizedBox(width: 10),
              Text('Logout'),
            ],
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                // Navigate to splash screen and remove all previous routes
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SplashScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFF005496),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildMenuCard(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
            color: const Color(0xFF005496),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF005496),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    ),
  );
}
