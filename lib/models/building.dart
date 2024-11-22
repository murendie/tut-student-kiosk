import 'package:google_maps_flutter/google_maps_flutter.dart';

class TUTBuilding {
  final String id;
  final String name;
  final String description;
  final LatLng location;
  final String buildingCode;

  const TUTBuilding({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.buildingCode,
  });
}

// TUT Soshanguve Campus Buildings
final List<TUTBuilding> tutBuildings = [
  // Main Academic Buildings
  TUTBuilding(
    id: '1',
    name: 'Building 1 - Main Administration',
    description: 'Main Administration Building, Student Affairs, and Finance Offices',
    location: const LatLng(-25.5424, 28.0967),
    buildingCode: 'B1',
  ),
  TUTBuilding(
    id: '2',
    name: 'Building 2 - Library',
    description: 'Main Campus Library and Study Areas',
    location: const LatLng(-25.5422, 28.0970),
    buildingCode: 'B2',
  ),
  TUTBuilding(
    id: '3',
    name: 'Building 3 - ICT Faculty',
    description: 'Information and Communication Technology Faculty',
    location: const LatLng(-25.5428, 28.0965),
    buildingCode: 'B3',
  ),
  TUTBuilding(
    id: '4',
    name: 'Building 4 - Engineering Faculty',
    description: 'Engineering and Built Environment Faculty',
    location: const LatLng(-25.5430, 28.0968),
    buildingCode: 'B4',
  ),
  TUTBuilding(
    id: '5',
    name: 'Building 5 - Science Faculty',
    description: 'Natural Sciences Faculty',
    location: const LatLng(-25.5427, 28.0972),
    buildingCode: 'B5',
  ),
  
  // Student Services
  TUTBuilding(
    id: '6',
    name: 'Student Centre',
    description: 'Student Services, SRC Offices, and Campus Health Services',
    location: const LatLng(-25.5425, 28.0974),
    buildingCode: 'SC',
  ),
  TUTBuilding(
    id: '7',
    name: 'Gencor Community Hall',
    description: 'Main Community Hall and Events Center',
    location: const LatLng(-25.5431, 28.0972),
    buildingCode: 'GCH',
  ),
  
  // Sports and Recreation
  TUTBuilding(
    id: '8',
    name: 'Sports Complex',
    description: 'Sports Facilities, Fields, and Gymnasium',
    location: const LatLng(-25.5433, 28.0975),
    buildingCode: 'SP',
  ),
  
  // Residences
  TUTBuilding(
    id: '9',
    name: 'Building 10 - Male Residence',
    description: 'Male Student Accommodation',
    location: const LatLng(-25.5435, 28.0970),
    buildingCode: 'B10',
  ),
  TUTBuilding(
    id: '10',
    name: 'Building 11 - Female Residence',
    description: 'Female Student Accommodation',
    location: const LatLng(-25.5436, 28.0973),
    buildingCode: 'B11',
  ),
  
  // Support Facilities
  TUTBuilding(
    id: '11',
    name: 'Campus Clinic',
    description: 'Healthcare Services for Students and Staff',
    location: const LatLng(-25.5426, 28.0976),
    buildingCode: 'CC',
  ),
  TUTBuilding(
    id: '12',
    name: 'Student Cafeteria',
    description: 'Main Campus Food Court and Dining Area',
    location: const LatLng(-25.5428, 28.0977),
    buildingCode: 'CAF',
  ),
  TUTBuilding(
    id: '13',
    name: 'Building 13 - Lecture Halls',
    description: 'Large Lecture Venues and Auditoriums',
    location: const LatLng(-25.5429, 28.0971),
    buildingCode: 'B13',
  ),
  TUTBuilding(
    id: '14',
    name: 'Building 14 - Computer Labs',
    description: 'General Access Computer Laboratories',
    location: const LatLng(-25.5427, 28.0969),
    buildingCode: 'B14',
  ),
  
  // Security and Parking
  TUTBuilding(
    id: '15',
    name: 'Main Gate',
    description: 'Campus Main Entrance and Security',
    location: const LatLng(-25.5420, 28.0965),
    buildingCode: 'MG',
  ),
  TUTBuilding(
    id: '16',
    name: 'Parking Area A',
    description: 'Main Student and Staff Parking',
    location: const LatLng(-25.5423, 28.0963),
    buildingCode: 'PA',
  ),
  
  // Additional Facilities
  TUTBuilding(
    id: '17',
    name: 'EMC Building',
    description: 'Equipment and Maintenance Center',
    location: const LatLng(-25.5432, 28.0966),
    buildingCode: 'EMC',
  ),
  TUTBuilding(
    id: '18',
    name: 'Research Center',
    description: 'Postgraduate and Research Facilities',
    location: const LatLng(-25.5425, 28.0968),
    buildingCode: 'RC',
  ),
  TUTBuilding(
    id: '19',
    name: 'Student Support Center',
    description: 'Academic Support and Counseling Services',
    location: const LatLng(-25.5426, 28.0973),
    buildingCode: 'SSC',
  ),
  TUTBuilding(
    id: '20',
    name: 'Innovation Hub',
    description: 'Technology and Innovation Center',
    location: const LatLng(-25.5428, 28.0974),
    buildingCode: 'IH',
  ),
];
