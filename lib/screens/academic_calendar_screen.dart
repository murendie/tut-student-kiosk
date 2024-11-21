import 'package:flutter/material.dart';

class AcademicCalendarScreen extends StatefulWidget {
  const AcademicCalendarScreen({super.key});

  @override
  State<AcademicCalendarScreen> createState() => _AcademicCalendarScreenState();
}

class _AcademicCalendarScreenState extends State<AcademicCalendarScreen> {
  final List<String> _filters = ['All', 'Academic', 'Holidays', 'Registration', 'Examinations'];
  String _selectedFilter = 'All';

  final Map<String, List<CalendarEvent>> _calendarData = {
    'January': [
      CalendarEvent('New Year\'s Day (Non-academic staff reports for duty)', '1', 'Holidays'),
      CalendarEvent('Preparation for late application process begins', '6', 'Registration'),
      CalendarEvent('Processing of final NSC results', '11-16', 'Academic'),
      CalendarEvent('Deadline for exit examination applications', '15', 'Examinations'),
      CalendarEvent('Exit/special examinations take place', '27-31', 'Examinations'),
      CalendarEvent('Deadline for registration for research-based M and D programmes', '31', 'Registration'),
    ],
    'February': [
      CalendarEvent('Commencement of classes', '3', 'Academic'),
      CalendarEvent('Publication of exit/special examination results', '11', 'Examinations'),
      CalendarEvent('Final date for registration of students who wrote exit exams (without penalty)', '18', 'Registration'),
      CalendarEvent('Orientation for newcomer students', '20-24', 'Academic'),
    ],
    'March': [
      CalendarEvent('Cancellation period for first-semester modules with a 60% fee liability', '1-20', 'Academic'),
      CalendarEvent('Human Rights Day', '21', 'Holidays'),
      CalendarEvent('End of the first term', '28', 'Academic'),
      CalendarEvent('TUT Recess', '31', 'Academic'),
    ],
    'April': [
      CalendarEvent('Academic staff reports for duty', '1', 'Academic'),
      CalendarEvent('Start of the second term', '7', 'Academic'),
      CalendarEvent('Commencement of classes for the second term', '14', 'Academic'),
      CalendarEvent('Freedom Day', '27', 'Holidays'),
      CalendarEvent('Deadline for examination paper submissions for May/June exams', '30', 'Examinations'),
    ],
    'May': [
      CalendarEvent('Workers\' Day', '1', 'Holidays'),
      CalendarEvent('Closing date for application submissions for specific programmes in 2026', '15', 'Registration'),
      CalendarEvent('Exam and moderator list compilations', '19-23', 'Examinations'),
      CalendarEvent('Main examination period begins', '26', 'Examinations'),
    ],
    'June': [
      CalendarEvent('Youth Day', '16', 'Holidays'),
      CalendarEvent('Supplementary examinations', '17-30', 'Examinations'),
    ],
    'July': [
      CalendarEvent('Start of the second semester (registration continues until 1 Aug)', '14', 'Academic'),
      CalendarEvent('Deadline for submission of hardbound copies for spring graduations', '31', 'Academic'),
    ],
    'August': [
      CalendarEvent('National Women\'s Day', '9', 'Holidays'),
      CalendarEvent('Final date for applications for spring graduation', '31', 'Academic'),
    ],
    'September': [
      CalendarEvent('TUT recess', '22-26', 'Academic'),
      CalendarEvent('Heritage Day', '24', 'Holidays'),
    ],
    'October': [
      CalendarEvent('Start of the second term for the second semester', '1', 'Academic'),
      CalendarEvent('Deadline for submission of softbound copies for autumn graduation', '31', 'Academic'),
    ],
    'November': [
      CalendarEvent('Final examination period', '3-21', 'Examinations'),
      CalendarEvent('Closing day for academic activities', '21', 'Academic'),
    ],
    'December': [
      CalendarEvent('Publication of final examination results', '12', 'Examinations'),
      CalendarEvent('TUT Holiday', '15', 'Holidays'),
      CalendarEvent('Day of Reconciliation', '16', 'Holidays'),
      CalendarEvent('Christmas Day', '25', 'Holidays'),
      CalendarEvent('Day of Goodwill', '26', 'Holidays'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF005496),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Image.asset(
              'images/logo_top.png',
              height: 40,
            ),
            const SizedBox(width: 16),
            const Text(
              'Academic Calendar 2025',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter by Category:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF005496),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          selectedColor: const Color(0xFF005496),
                          labelStyle: TextStyle(
                            color: _selectedFilter == filter ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _calendarData.length,
              itemBuilder: (context, index) {
                String month = _calendarData.keys.elementAt(index);
                List<CalendarEvent> events = _calendarData[month]!;
                
                // Filter events based on selected category
                if (_selectedFilter != 'All') {
                  events = events.where((event) => event.category == _selectedFilter).toList();
                }
                
                if (events.isEmpty) return const SizedBox.shrink();

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExpansionTile(
                    title: Text(
                      month,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005496),
                      ),
                    ),
                    children: events.map((event) {
                      return ListTile(
                        leading: _getCategoryIcon(event.category),
                        title: Text(event.description),
                        subtitle: Text(
                          '${event.date} ${month}',
                          style: const TextStyle(
                            color: Color(0xFF005496),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCategoryIcon(String category) {
    switch (category) {
      case 'Academic':
        return const Icon(Icons.school, color: Colors.blue);
      case 'Holidays':
        return const Icon(Icons.celebration, color: Colors.green);
      case 'Registration':
        return const Icon(Icons.how_to_reg, color: Colors.orange);
      case 'Examinations':
        return const Icon(Icons.edit_note, color: Colors.red);
      default:
        return const Icon(Icons.event, color: Colors.grey);
    }
  }
}

class CalendarEvent {
  final String description;
  final String date;
  final String category;

  CalendarEvent(this.description, this.date, this.category);
}
