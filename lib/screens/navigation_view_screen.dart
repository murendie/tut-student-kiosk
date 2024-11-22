import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import '../config/maps_config.dart';

class NavigationViewScreen extends StatefulWidget {
  final LatLng startLocation;
  final LatLng destination;
  final String destinationName;

  const NavigationViewScreen({
    super.key,
    required this.startLocation,
    required this.destination,
    required this.destinationName,
  });

  @override
  State<NavigationViewScreen> createState() => _NavigationViewScreenState();
}

class _NavigationViewScreenState extends State<NavigationViewScreen> {
  Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<Map<String, dynamic>> _navigationSteps = [];
  bool _isLoading = true;
  String? _errorMessage;
  final Location _locationService = Location();
  List<LatLng> polylineCoordinates = [];
  String distance = '';
  String duration = '';
  bool isLoading = true;
  List<Map<String, dynamic>> navigationSteps = [];
  bool _isMapCreated = false;
  bool _isFollowingUser = true;
  int _currentStepIndex = 0;
  LocationData? _currentLocation;
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _initializeNavigation();
    _initializeLocation();
  }

  Future<void> _initializeNavigation() async {
    try {
      await _addMarkers();
      await _getDirections();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load navigation. Please try again.';
      });
    }
  }

  Future<void> _addMarkers() async {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('start'),
          position: widget.startLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(
            title: 'Start Location',
            snippet: 'Gencor Community Hall',
          ),
        ),
        Marker(
          markerId: const MarkerId('destination'),
          position: widget.destination,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: widget.destinationName,
          ),
        ),
      };
    });
  }

  Future<void> _getDirections() async {
    try {
      debugPrint('Requesting route between (${widget.startLocation.latitude}, ${widget.startLocation.longitude}) and (${widget.destination.latitude}, ${widget.destination.longitude})');
      
      final url = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
        'origin': '${widget.startLocation.latitude},${widget.startLocation.longitude}',
        'destination': '${widget.destination.latitude},${widget.destination.longitude}',
        'mode': 'walking',
        'key': MapsConfig.apiKey,
      });

      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          final points = PolylinePoints().decodePolyline(
            data['routes'][0]['overview_polyline']['points']
          );

          final polylineCoordinatesList = points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          setState(() {
            polylineCoordinates = polylineCoordinatesList;
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                color: const Color(0xFF005496),
                points: polylineCoordinates,
                width: 5,
              ),
            );

            // Extract navigation steps
            final legs = data['routes'][0]['legs'][0];
            navigationSteps = List<Map<String, dynamic>>.from(
              legs['steps'].map((step) => {
                'instruction': step['html_instructions'],
                'distance': step['distance']['text'],
                'duration': step['duration']['text'],
              }),
            );
            
            distance = legs['distance']['text'];
            duration = legs['duration']['text'];
            _isLoading = false;
          });

          _fitMapToRoute(polylineCoordinatesList);
        } else {
          throw Exception('Directions API error: ${data['status']} - ${data['error_message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to fetch directions: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in _getDirections: $e');
      setState(() {
        _errorMessage = 'Error getting directions: $e';
        _isLoading = false;
      });
    }
  }

  void _fitMapToRoute(List<LatLng> coordinates) {
    if (coordinates.isEmpty || _mapController == null) return;

    double minLat = coordinates[0].latitude;
    double maxLat = coordinates[0].latitude;
    double minLng = coordinates[0].longitude;
    double maxLng = coordinates[0].longitude;

    for (var point in coordinates) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    _mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          100, // padding
        ),
      );
    });
  }

  Future<void> _initializeLocation() async {
    try {
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await _locationService.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _locationService.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      _locationSubscription = _locationService.onLocationChanged.listen(
        (LocationData currentLocation) {
          if (mounted) {
            setState(() {
              _currentLocation = currentLocation;
            });
            _updateNavigation(currentLocation);
          }
        },
      );
    } catch (e) {
      debugPrint('Error initializing location: $e');
    }
  }

  Future<void> _updateNavigation(LocationData currentLocation) async {
    if (!mounted || navigationSteps.isEmpty) return;

    // Update user location marker
    final userMarker = Marker(
      markerId: const MarkerId('user'),
      position: LatLng(currentLocation.latitude!, currentLocation.longitude!),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      rotation: currentLocation.heading ?? 0,
      flat: true,
    );

    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == 'user');
      _markers.add(userMarker);
    });

    // Update camera if following user
    if (_isFollowingUser) {
      final controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
            zoom: 18,
            tilt: 45,
            bearing: currentLocation.heading ?? 0,
          ),
        ),
      );
    }

    // Check if we've reached the next navigation step
    if (_currentStepIndex < navigationSteps.length) {
      final nextStep = navigationSteps[_currentStepIndex];
      final nextStepLocation = nextStep['location'] as LatLng;
      
      final distance = _calculateDistance(
        currentLocation.latitude!,
        currentLocation.longitude!,
        nextStepLocation.latitude,
        nextStepLocation.longitude,
      );

      // If within 10 meters of the next step
      if (distance <= 10) {
        setState(() {
          _currentStepIndex++;
        });
      }
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // meters
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation to ${widget.destinationName}'),
        backgroundColor: const Color(0xFF005496),
        actions: [
          IconButton(
            icon: Icon(_isFollowingUser ? Icons.gps_fixed : Icons.gps_not_fixed),
            onPressed: () {
              setState(() {
                _isFollowingUser = !_isFollowingUser;
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _initializeNavigation,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: GoogleMap(
                        onMapCreated: _mapController.complete,
                        initialCameraPosition: CameraPosition(
                          target: widget.startLocation,
                          zoom: 15,
                        ),
                        markers: _markers,
                        polylines: _polylines,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        mapType: MapType.normal,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.white,
                        child: ListView.builder(
                          itemCount: navigationSteps.length,
                          itemBuilder: (context, index) {
                            final step = navigationSteps[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF005496),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                step['instruction'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${step['distance']} • ${step['duration']}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  @override
  void dispose() {
    _mapController.future.then((controller) => controller.dispose());
    _locationSubscription?.cancel();
    super.dispose();
  }
}
