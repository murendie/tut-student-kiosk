import 'package:flutter/material.dart';
import '../utils/pdf_generator.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> results = [
      {
        'module': 'DSO34BT - Distributed Systems',
        'code': 'DSO34BT',
        'marks': {
          'Assignment 1': 85,
          'Assignment 2': 78,
          'Test 1': 72,
          'Test 2': 88,
          'Exam': 76
        },
        'final': 80,
        'status': 'Pass'
      },
      {
        'module': 'ISY34BT - Information Systems',
        'code': 'ISY34BT',
        'marks': {
          'Assignment 1': 92,
          'Assignment 2': 85,
          'Test 1': 78,
          'Test 2': 82,
          'Exam': 88
        },
        'final': 85,
        'status': 'Pass'
      },
      {
        'module': 'TPG201T - Technical Programming',
        'code': 'TPG201T',
        'marks': {
          'Assignment 1': 75,
          'Assignment 2': 82,
          'Test 1': 68,
          'Test 2': 78,
          'Exam': 72
        },
        'final': 75,
        'status': 'Pass'
      },
      {
        'module': 'SSF24BT - System Security',
        'code': 'SSF24BT',
        'marks': {
          'Assignment 1': 88,
          'Assignment 2': 90,
          'Test 1': 85,
          'Test 2': 92,
          'Exam': 86
        },
        'final': 88,
        'status': 'Pass'
      },
      {
        'module': 'IDC30AT - Industrial Computing',
        'code': 'IDC30AT',
        'marks': {
          'Assignment 1': 82,
          'Assignment 2': 78,
          'Test 1': 75,
          'Test 2': 80,
          'Exam': 78
        },
        'final': 79,
        'status': 'Pass'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Results'),
        backgroundColor: const Color(0xFF005496),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => PdfGenerator.generateResultsPdf(results),
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
                'Current Semester Results',
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
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  final marks = result['marks'] as Map<String, dynamic>;
                  
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ExpansionTile(
                      title: Text(
                        result['module'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            'Final Mark: ${result['final']}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: result['status'] == 'Pass'
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              result['status'],
                              style: TextStyle(
                                color: result['status'] == 'Pass'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: marks.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(entry.key),
                                    Text(
                                      '${entry.value}%',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
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
