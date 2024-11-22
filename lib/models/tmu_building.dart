class TMUBuilding {
  final String name;
  final String code;
  final double latitude;
  final double longitude;
  final List<String> levels;
  final Map<String, String> entrances;

  TMUBuilding({
    required this.name,
    required this.code,
    required this.latitude,
    required this.longitude,
    required this.levels,
    required this.entrances,
  });
}

// Sample TMU buildings data
final List<TMUBuilding> tmuBuildings = [
  TMUBuilding(
    name: 'Kerr Hall West',
    code: 'KHW',
    latitude: 43.658463,
    longitude: -79.380569,
    levels: ['Ground Floor', 'Level 1', 'Level 2', 'Level 3'],
    entrances: {
      'main': 'Victoria Street entrance',
      'gym': 'Gym entrance on Church Street',
    },
  ),
  TMUBuilding(
    name: 'Student Learning Centre',
    code: 'SLC',
    latitude: 43.657847,
    longitude: -79.380688,
    levels: ['Lower Ground', 'Ground Floor', 'Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5', 'Level 6', 'Level 7', 'Level 8'],
    entrances: {
      'main': 'Yonge Street entrance',
      'bridge': 'Library Building bridge entrance',
    },
  ),
  TMUBuilding(
    name: 'Library Building',
    code: 'LIB',
    latitude: 43.657556,
    longitude: -79.381394,
    levels: ['Lower Level', 'Ground Floor', 'Level 2', 'Level 3', 'Level 4', 'Level 5', 'Level 6', 'Level 7', 'Level 8', 'Level 9', 'Level 10'],
    entrances: {
      'main': 'Victoria Street entrance',
      'slc': 'SLC bridge entrance',
    },
  ),
  // Add more TMU buildings as needed
];
