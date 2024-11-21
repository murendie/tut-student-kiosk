import 'package:flutter/material.dart';
import '../widgets/grid_item.dart';
import '../widgets/top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: Column(
        children: [
          const TopBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      const Column(
                        children: [
                          Text(
                            'Welcome to TUT Kiosk',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF005496),
                              shadows: [
                                Shadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'What would you like to do?',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF666666),
                              shadows: [
                                Shadow(
                                  color: Colors.black12,
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                ),
                              ],
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
                              crossAxisCount: 2,
                              crossAxisSpacing: 24.0,
                              mainAxisSpacing: 24.0,
                              childAspectRatio: 1.3, // Adjust aspect ratio for better fit
                              physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                              shrinkWrap: true,
                              children: [
                                GridItem(
                                  icon: Icons.smart_toy,
                                  color: const Color(0xFFF9BC0A),
                                  label: 'EduBot',
                                  onTap: () => _showSelection(context, 'EduBot'),
                                ),
                                GridItem(
                                  icon: Icons.person_add,
                                  color: const Color(0xFFE41936),
                                  label: 'Study@TUT',
                                  onTap: () => _showSelection(context, 'Study@TUT'),
                                ),
                                GridItem(
                                  icon: Icons.payment,
                                  color: const Color(0xFF005496),
                                  label: 'Pay',
                                  onTap: () => _showSelection(context, 'Pay'),
                                ),
                                GridItem(
                                  icon: Icons.map_rounded,
                                  color: const Color(0xFF2E8B57),
                                  label: 'Wayfinder',
                                  onTap: () => _showSelection(context, 'Wayfinder'),
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
    );
  }

  void _showSelection(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You selected $label'),
        backgroundColor: const Color(0xFF005496),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
