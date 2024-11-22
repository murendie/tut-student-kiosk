class MapsConfig {
  static const String apiKey = 'AIzaSyBImx4N6wV-qe0R8IRLV1Yb2bvyo2M14fo';
  
  // Add allowed domains for web
  static const List<String> allowedDomains = [
    'localhost',
    '127.0.0.1',
  ];
  
  // Initialize Google Maps
  static String get mapsUrl {
    return 'https://maps.googleapis.com/maps/api/js'
           '?key=$apiKey'
           '&libraries=places'
           '&callback=initMap';
  }

  // Default map settings
  static const double defaultZoom = 16.0;
  static const double defaultTilt = 0.0;
  static const double defaultBearing = 0.0;

  // TMU Campus bounds
  static const double northBound = 43.661500; // North limit
  static const double southBound = 43.655500; // South limit
  static const double eastBound = -79.377000; // East limit
  static const double westBound = -79.383000; // West limit

  // Kerr Hall W Gym location (fixed starting point)
  static const double startLatitude = 43.658463;
  static const double startLongitude = -79.380569;
}
