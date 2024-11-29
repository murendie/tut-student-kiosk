import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

class PdfGenerator {
  static const String tutAddress = 'Lock K, 2 Aubrey Matlakala St, Soshanguve - K, Soshanguve, 0152';

  static pw.Widget _buildHeader(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  tutAddress,
                  style: const pw.TextStyle(
                    color: PdfColors.grey700,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.PageTheme _buildTheme() {
    return pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(
        base: pw.Font.helvetica(),
        bold: pw.Font.helveticaBold(),
      ),
      buildBackground: (pw.Context context) {
        return pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(
                width: 8,
                color: PdfColors.blue900,
              ),
            ),
          ),
        );
      },
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(
            color: PdfColors.grey300,
            width: 1,
          ),
        ),
      ),
      padding: const pw.EdgeInsets.only(top: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated on ${DateTime.now().toString().split(' ')[0]}',
            style: const pw.TextStyle(
              color: PdfColors.grey600,
              fontSize: 10,
            ),
          ),
          pw.Text(
            'Tshwane University of Technology',
            style: const pw.TextStyle(
              color: PdfColors.grey600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildContentCard(String title, List<pw.Widget> children) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
        boxShadow: [
          pw.BoxShadow(
            color: PdfColors.grey300,
            offset: const PdfPoint(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 10),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(
                  color: PdfColors.grey300,
                  width: 1,
                ),
              ),
            ),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
          ),
          pw.SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  static Future<Uint8List?> _getTutLogo() async {
    try {
      if (kIsWeb) {
        final response = await http.get(Uri.parse('images/logo.png'));
        if (response.statusCode == 200) {
          return response.bodyBytes;
        }
      } else {
        final file = File('images/logo.png');
        if (await file.exists()) {
          return file.readAsBytesSync();
        }
      }
    } catch (e) {
      print('Error loading logo: $e');
    }
    return null;
  }

  static Future<void> generateTimetablePdf(List<Map<String, dynamic>> timetable) async {
    final pdf = pw.Document();
    final logo = await _getTutLogo();

    pdf.addPage(
      pw.Page(
        pageTheme: _buildTheme(),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader('Class Timetable'),
              _buildContentCard(
                'Weekly Schedule',
                [
                  pw.Table(
                    border: pw.TableBorder.all(
                      color: PdfColors.grey300,
                      width: 0.5,
                    ),
                    children: [
                      // Header row
                      pw.TableRow(
                        decoration: pw.BoxDecoration(
                          color: PdfColors.blue900,
                        ),
                        children: [
                          'Module',
                          'Day',
                          'Time',
                          'Venue',
                        ].map((text) => pw.Padding(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Text(
                            text,
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        )).toList(),
                      ),
                      // Data rows
                      ...timetable.map(
                        (lecture) => pw.TableRow(
                          children: [
                            lecture['module'],
                            lecture['day'],
                            lecture['time'],
                            lecture['venue'],
                          ].map((text) => pw.Padding(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Text(text),
                          )).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.Spacer(),
              _buildFooter(),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();

    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, '_blank');
      html.Url.revokeObjectUrl(url);
    } else {
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/timetable.pdf');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    }
  }

  static Future<void> generateResultsPdf(List<Map<String, dynamic>> results) async {
    final pdf = pw.Document();
    final logo = await _getTutLogo();

    pdf.addPage(
      pw.Page(
        pageTheme: _buildTheme(),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader('Postgraduate Academic Results'),
              ...results.map((result) {
                final marks = result['marks'] as Map<String, dynamic>;
                return _buildContentCard(
                  result['module'],
                  [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Final Mark: ${result['final']}%',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue900,
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: pw.BoxDecoration(
                            color: result['status'] == 'Pass'
                                ? PdfColors.green100
                                : PdfColors.red100,
                            borderRadius:
                                const pw.BorderRadius.all(pw.Radius.circular(15)),
                          ),
                          child: pw.Text(
                            result['status'],
                            style: pw.TextStyle(
                              color: result['status'] == 'Pass'
                                  ? PdfColors.green900
                                  : PdfColors.red900,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    ...marks.entries.map(
                      (entry) => pw.Container(
                        padding: const pw.EdgeInsets.symmetric(vertical: 5),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(entry.key),
                            pw.Text(
                              '${entry.value}%',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
              _buildContentCard(
                'Academic Achievements',
                [
                  pw.Text(
                    'Course: Postgraduate Diploma in Computer Science',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Current Average:'),
                      pw.Text(
                        '75%',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue900,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Academic Standing:'),
                      pw.Text(
                        'Good Standing',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.Spacer(),
              _buildFooter(),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();

    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, '_blank');
      html.Url.revokeObjectUrl(url);
    } else {
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/results.pdf');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    }
  }

  static Future<void> generateRegistrationStatementPdf(
    List<Map<String, dynamic>> modules,
    Map<String, String> studentInfo,
  ) async {
    final pdf = pw.Document();
    final logo = await _getTutLogo();

    pdf.addPage(
      pw.Page(
        pageTheme: _buildTheme(),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader('Postgraduate Registration Statement'),
              _buildContentCard(
                'Student Information',
                [
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        width: 140,
                        child: pw.Text(
                          'Course:',
                          style: const pw.TextStyle(
                            color: PdfColors.grey700,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          'Postgraduate Diploma in Computer Science',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...studentInfo.entries
                    .map(
                      (entry) => pw.Container(
                        padding: const pw.EdgeInsets.symmetric(vertical: 5),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(
                              width: 140,
                              child: pw.Text(
                                entry.key,
                                style: const pw.TextStyle(
                                  color: PdfColors.grey700,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                entry.value,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                ],
              ),
              _buildContentCard(
                'Registered Modules',
                [
                  pw.Table(
                    border: pw.TableBorder.all(
                      color: PdfColors.grey300,
                      width: 0.5,
                    ),
                    children: [
                      // Header
                      pw.TableRow(
                        decoration: pw.BoxDecoration(
                          color: PdfColors.blue900,
                        ),
                        children: [
                          'Module Code',
                          'Module Name',
                          'Credits',
                          'Status',
                        ].map((text) => pw.Padding(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Text(
                            text,
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        )).toList(),
                      ),
                      // Data rows
                      ...modules.map(
                        (module) => pw.TableRow(
                          children: [
                            module['code'],
                            module['name'],
                            module['credits'].toString(),
                            module['status'],
                          ].map((text) => pw.Padding(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Text(text),
                          )).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _buildContentCard(
                'Registration Summary',
                [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Credits:'),
                      pw.Text(
                        '60',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue900,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Number of Modules:'),
                      pw.Text(
                        '5',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.Spacer(),
              _buildFooter(),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();

    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, '_blank');
      html.Url.revokeObjectUrl(url);
    } else {
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/registration_statement.pdf');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    }
  }
}
