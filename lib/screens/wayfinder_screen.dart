import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;
import '../models/building.dart';
import 'navigation_view_screen.dart';

class WayfinderScreen extends StatefulWidget {
  const WayfinderScreen({super.key});

  @override
  State<WayfinderScreen> createState() => _WayfinderScreenState();
}

class _WayfinderScreenState extends State<WayfinderScreen> {
  final TextEditingController _destinationController = TextEditingController();
  TUTBuilding? selectedDestination;
  List<TUTBuilding> filteredBuildings = [];
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  // TUT Soshanguve Campus coordinates
  static const LatLng _tutCenter = LatLng(-25.5426, 28.0969);
  // Gencor Community Hall coordinates
  final LatLng currentLocation = const LatLng(-25.5431, 28.0972);

  @override
  void initState() {
    super.initState();
    _destinationController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _destinationController.text.toLowerCase();
    setState(() {
      filteredBuildings = tutBuildings
          .where((building) =>
              building.name.toLowerCase().contains(query) ||
              building.buildingCode.toLowerCase().contains(query))
          .toList();
    });
  }

  void _onBuildingSelected(TUTBuilding building) {
    setState(() {
      selectedDestination = building;
      _destinationController.text = building.name;
      filteredBuildings = [];

      // Add marker for selected destination
      _markers.add(
        Marker(
          markerId: MarkerId(building.id),
          position: building.location,
          infoWindow: InfoWindow(
            title: building.name,
            snippet: building.description,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      // Move camera to show both markers
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(
              math.min(currentLocation.latitude, building.location.latitude),
              math.min(currentLocation.longitude, building.location.longitude),
            ),
            northeast: LatLng(
              math.max(currentLocation.latitude, building.location.latitude),
              math.max(currentLocation.longitude, building.location.longitude),
            ),
          ),
          100, // padding
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Wayfinder'),
        backgroundColor: const Color(0xFF005496),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Starting From:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Gencor Community Hall',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _destinationController,
                  decoration: const InputDecoration(
                    labelText: 'Search for a destination',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                if (filteredBuildings.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredBuildings.length,
                      itemBuilder: (context, index) {
                        final building = filteredBuildings[index];
                        return ListTile(
                          title: Text(building.name),
                          subtitle: Text(building.description),
                          onTap: () => _onBuildingSelected(building),
                        );
                      },
                    ),
                  ),
                if (selectedDestination != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavigationViewScreen(
                              startLocation: currentLocation,
                              destination: selectedDestination!.location,
                              destinationName: selectedDestination!.name,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.navigation),
                      label: const Text('Start Navigation'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005496),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
                // Center the map on TUT Soshanguve campus
                _mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    const CameraPosition(
                      target: _tutCenter,
                      zoom: 16.0,
                    ),
                  ),
                );
              },
              initialCameraPosition: const CameraPosition(
                target: _tutCenter,
                zoom: 16.0,
              ),
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              mapType: MapType.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }
}
