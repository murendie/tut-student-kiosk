import 'package:flutter/material.dart';
import '../utils/pdf_generator.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> timetable = [
      {
        'module': 'DSO34BT - Distributed Systems',
        'day': 'Monday',
        'time': '08:00 - 10:00',
        'venue': 'Building 11-G01'
      },
      {
        'module': 'ISY34BT - Information Systems',
        'day': 'Monday',
        'time': '12:00 - 14:00',
        'venue': 'Building 11-G02'
      },
      {
        'module': 'TPG201T - Technical Programming',
        'day': 'Tuesday',
        'time': '10:00 - 12:00',
        'venue': 'Building 11-G03'
      },
      {
        'module': 'SSF24BT - System Security',
        'day': 'Wednesday',
        'time': '14:00 - 16:00',
        'venue': 'Building 11-G04'
      },
      {
        'module': 'IDC30AT - Industrial Computing',
        'day': 'Thursday',
        'time': '08:00 - 10:00',
        'venue': 'Building 11-G05'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Timetable'),
        backgroundColor: const Color(0xFF005496),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => PdfGenerator.generateTimetablePdf(timetable),
            tooltip: 'Download PDF',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Semester Timetable',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF005496),
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: timetable.length,
                itemBuilder: (context, index) {
                  final lecture = timetable[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        lecture['module'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16),
                              const SizedBox(width: 8),
                              Text(lecture['day']),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16),
                              const SizedBox(width: 8),
                              Text(lecture['time']),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16),
                              const SizedBox(width: 8),
                              Text(lecture['venue']),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
