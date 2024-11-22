import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/tmu_building.dart';
import 'navigation_view_screen.dart';

class WayfinderScreen extends StatefulWidget {
  const WayfinderScreen({super.key});

  @override
  State<WayfinderScreen> createState() => _WayfinderScreenState();
}

class _WayfinderScreenState extends State<WayfinderScreen> {
  final TextEditingController _destinationController = TextEditingController();
  TMUBuilding? selectedDestination;
  List<TMUBuilding> filteredBuildings = [];

  // Fixed starting point: Kerr Hall W Gym
  final LatLng currentLocation = const LatLng(43.658463, -79.380569);

  @override
  void initState() {
    super.initState();
    _destinationController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _destinationController.text.toLowerCase();
    setState(() {
      filteredBuildings = tmuBuildings
          .where((building) =>
              building.name.toLowerCase().contains(query) ||
              building.code.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Wayfinder'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Location Display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Current Location',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kerr Hall W Gym',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Destination Search
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                hintText: 'Search for a building...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            // Search Results
            Expanded(
              child: ListView.builder(
                itemCount: filteredBuildings.length,
                itemBuilder: (context, index) {
                  final building = filteredBuildings[index];
                  return ListTile(
                    leading: const Icon(Icons.business),
                    title: Text(building.name),
                    subtitle: Text(building.code),
                    onTap: () {
                      setState(() {
                        selectedDestination = building;
                        _destinationController.text = building.name;
                      });
                      // Clear the filtered list after selection
                      filteredBuildings.clear();
                    },
                  );
                },
              ),
            ),
            
            // Navigation Button
            if (selectedDestination != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigationViewScreen(
                            startLocation: currentLocation,
                            destination: LatLng(
                              selectedDestination!.latitude,
                              selectedDestination!.longitude,
                            ),
                            destinationName: selectedDestination!.name,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Start Navigation',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }
}
