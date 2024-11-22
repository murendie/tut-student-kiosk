import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExamTimetableScreen extends StatelessWidget {
  const ExamTimetableScreen({super.key});

  final String _examUrl = 'https://os.tut.ac.za/ExamsLegacy/TimeTable';

  Future<void> _launchExamTimetable() async {
    final Uri url = Uri.parse(_examUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_examUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Timetable'),
        backgroundColor: const Color(0xFF005496),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () {
              _launchExamTimetable();
            },
            tooltip: 'Open in new tab',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_month,
              size: 80,
              color: Color(0xFF005496),
            ),
            const SizedBox(height: 24),
            const Text(
              'TUT Exam Timetable',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005496),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'View your exam schedule and venue details',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                _launchExamTimetable();
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open Exam Timetable'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005496),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
