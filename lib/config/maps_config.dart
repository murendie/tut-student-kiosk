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
  static const double navigationZoom = 18.0;
  static const double defaultTilt = 0.0;
  static const double defaultBearing = 0.0;

  // TUT Soshanguve Campus bounds
  static const double northBound = -25.542000; // North limit
  static const double southBound = -25.544000; // South limit
  static const double eastBound = 28.098000;   // East limit
  static const double westBound = 28.096000;   // West limit

  // Gencor Community Hall location (fixed starting point)
  static const double startLatitude = -25.543100;
  static const double startLongitude = 28.097200;
}
