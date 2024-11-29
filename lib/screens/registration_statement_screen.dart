import 'package:flutter/material.dart';
import '../utils/pdf_generator.dart';

class RegistrationStatementScreen extends StatelessWidget {
  const RegistrationStatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> registeredModules = [
      {
        'code': 'DSO34BT',
        'name': 'Distributed Systems',
        'credits': 12,
        'semester': 1,
        'status': 'Registered',
      },
      {
        'code': 'ISY34BT',
        'name': 'Information Systems',
        'credits': 12,
        'semester': 1,
        'status': 'Registered',
      },
      {
        'code': 'TPG201T',
        'name': 'Technical Programming',
        'credits': 12,
        'semester': 1,
        'status': 'Registered',
      },
      {
        'code': 'SSF24BT',
        'name': 'System Security',
        'credits': 12,
        'semester': 1,
        'status': 'Registered',
      },
      {
        'code': 'IDC30AT',
        'name': 'Industrial Computing',
        'credits': 12,
        'semester': 1,
        'status': 'Registered',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Statement'),
        backgroundColor: const Color(0xFF005496),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              final studentInfo = {
                'Student Number': '219123456',
                'Name': 'Thabo Mokoena',
                'Course': 'Postgraduate Diploma in Computer Science',
                'Academic Year': '2023',
                'Registration Status': 'Registered',
              };
              PdfGenerator.generateRegistrationStatementPdf(registeredModules, studentInfo);
            },
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
              // Student Information Card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Student Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005496),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('Student Number:', '219123456'),
                      _buildInfoRow('Name:', 'Thabo Mokoena'),
                      _buildInfoRow(
                        'Course:',
                        'Postgraduate Diploma in Computer Science',
                      ),
                      _buildInfoRow('Academic Year:', '2023'),
                      _buildInfoRow('Registration Status:', 'Registered'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Registered Modules Section
              const Text(
                'Registered Modules',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF005496),
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: registeredModules.length,
                itemBuilder: (context, index) {
                  final module = registeredModules[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        '${module['code']} - ${module['name']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Credits: ${module['credits']}'),
                          Text('Semester: ${module['semester']}'),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF005496).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          module['status'],
                          style: const TextStyle(
                            color: Color(0xFF005496),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Summary Section
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Registration Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005496),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('Total Credits:', '60'),
                      _buildInfoRow('Number of Modules:', '5'),
                      _buildInfoRow('Registration Date:', '15 January 2023'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
