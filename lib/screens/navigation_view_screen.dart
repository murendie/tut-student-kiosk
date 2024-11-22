import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
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
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  String distance = '';
  String duration = '';
  bool isLoading = true;
  List<String> navigationSteps = [];
  bool _isMapCreated = false;
  bool _isMapReady = false;

  // Custom map style
  static const String _mapStyle = '''
[
  {
    "featureType": "all",
    "elementType": "geometry",
    "stylers": [{ "color": "#f5f5f5" }]
  },
  {
    "featureType": "poi",
    "elementType": "labels",
    "stylers": [{ "visibility": "off" }]
  },
  {
    "featureType": "poi.business",
    "stylers": [{ "visibility": "off" }]
  },
  {
    "featureType": "road",
    "elementType": "labels",
    "stylers": [{ "visibility": "off" }]
  },
  {
    "featureType": "transit",
    "stylers": [{ "visibility": "off" }]
  },
  {
    "featureType": "landscape",
    "elementType": "labels",
    "stylers": [{ "visibility": "off" }]
  },
  {
    "featureType": "administrative",
    "elementType": "labels",
    "stylers": [{ "visibility": "off" }]
  },
  {
    "featureType": "poi.school",
    "stylers": [
      { "visibility": "on" },
      { "color": "#e8f7ff" }
    ]
  },
  {
    "featureType": "poi.school",
    "elementType": "labels.text",
    "stylers": [
      { "visibility": "on" },
      { "color": "#005496" }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      { "color": "#ffffff" },
      { "weight": 1 }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",
    "stylers": [{ "color": "#005496" }]
  }
]
''';

  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

  void _addMarkers() {
    _markers.add(
      Marker(
        markerId: const MarkerId('start'),
        position: widget.startLocation,
        infoWindow: const InfoWindow(title: 'Kerr Hall W Gym'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: widget.destination,
        infoWindow: InfoWindow(title: widget.destinationName),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  Future<void> _getDirections() async {
    if (widget.startLocation.latitude == widget.destination.latitude &&
        widget.startLocation.longitude == widget.destination.longitude) {
      setState(() {
        isLoading = false;
        distance = '0 m';
        duration = '0 mins';
        navigationSteps = ['You are already at the destination.'];
      });
      return;
    }

    try {
      final String url = 'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${widget.startLocation.latitude},${widget.startLocation.longitude}'
          '&destination=${widget.destination.latitude},${widget.destination.longitude}'
          '&mode=walking'
          '&key=${MapsConfig.apiKey}';

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          // Get route points
          final points = _decodePolyline(data['routes'][0]['overview_polyline']['points']);
          
          // Get steps for navigation
          final steps = data['routes'][0]['legs'][0]['steps'] as List;
          final List<String> instructions = [];
          for (var step in steps) {
            String instruction = step['html_instructions'] as String;
            // Remove HTML tags and clean up the instruction
            instruction = instruction
                .replaceAll(RegExp(r'<div[^>]*>'), '\n')
                .replaceAll(RegExp(r'</div>'), '')
                .replaceAll(RegExp(r'<[^>]*>'), '')
                .replaceAll('&nbsp;', ' ')
                .trim();
            instructions.add(instruction);
          }
          
          // Get distance and duration
          final leg = data['routes'][0]['legs'][0];
          
          setState(() {
            polylineCoordinates = points;
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                color: const Color(0xFF005496),
                points: polylineCoordinates,
                width: 5,
              ),
            );
            
            distance = leg['distance']['text'];
            duration = leg['duration']['text'];
            navigationSteps = instructions;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            navigationSteps = ['Unable to find a route to the destination.'];
          });
        }
      } else {
        setState(() {
          isLoading = false;
          navigationSteps = ['Error: Unable to connect to navigation service.'];
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        navigationSteps = ['Error: ${e.toString()}'];
      });
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _onMapCreated(GoogleMapController controller) async {
    if (!_isMapCreated) {
      await controller.setMapStyle(_mapStyle);
      _controller.complete(controller);
      setState(() {
        _isMapCreated = true;
        _isMapReady = true;
      });
      // Only get directions after map is ready
      _getDirections();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.startLocation,
              zoom: MapsConfig.defaultZoom,
              tilt: MapsConfig.defaultTilt,
              bearing: MapsConfig.defaultBearing,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: _onMapCreated,
            cameraTargetBounds: CameraTargetBounds(
              LatLngBounds(
                southwest: const LatLng(MapsConfig.southBound, MapsConfig.westBound),
                northeast: const LatLng(MapsConfig.northBound, MapsConfig.eastBound),
              ),
            ),
          ),
          if (!isLoading)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'To: ${widget.destinationName}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.directions_walk),
                              Text(distance),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.access_time),
                              Text(duration),
                            ],
                          ),
                        ],
                      ),
                      if (navigationSteps.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text(
                          'Navigation Steps:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            itemCount: navigationSteps.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${index + 1}. '),
                                    Expanded(
                                      child: Text(
                                        navigationSteps[index],
                                        style: const TextStyle(height: 1.3),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
