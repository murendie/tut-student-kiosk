import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/student_card_order.dart';

class StudentCardScreen extends StatefulWidget {
  final String studentNumber;
  final String fullName;
  final String course;

  const StudentCardScreen({
    super.key,
    required this.studentNumber,
    required this.fullName,
    required this.course,
  });

  @override
  State<StudentCardScreen> createState() => _StudentCardScreenState();
}

class _StudentCardScreenState extends State<StudentCardScreen> {
  dynamic _photo;
  bool _isLoading = false;
  final double _cardFee = 100.00;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );
      
      if (photo != null) {
        if (kIsWeb) {
          setState(() {
            _photo = photo;
          });
        } else {
          final Directory appDir = await getApplicationDocumentsDirectory();
          final String photoName = path.basename(photo.path);
          final String photoPath = path.join(appDir.path, photoName);
          
          final File photoFile = File(photoPath);
          await photoFile.writeAsBytes(await photo.readAsBytes());
          
          setState(() {
            _photo = photoFile;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error taking photo. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Card Order'),
        backgroundColor: const Color(0xFF005496),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Student Card Application',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005496),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Student Number: ${widget.studentNumber}'),
                    const SizedBox(height: 8),
                    Text('Full Name: ${widget.fullName}'),
                    const SizedBox(height: 8),
                    Text('Course: ${widget.course}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Photo Requirements:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Face should be clearly visible\n'
                      '• Plain background\n'
                      '• Good lighting\n'
                      '• No sunglasses or hats',
                    ),
                    const SizedBox(height: 16),
                    if (_photo != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: kIsWeb
                            ? Image.memory(
                                _photo,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                _photo as File,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    ElevatedButton.icon(
                      onPressed: _takePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: Text(_photo == null ? 'Take Photo' : 'Retake Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005496),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Payment Details:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Student Card Fee: R${_cardFee.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005496),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit Order'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitOrder() async {
    if (_photo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please take a photo first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final order = StudentCardOrder(
        studentNumber: widget.studentNumber,
        fullName: widget.fullName,
        course: widget.course,
        photoPath: kIsWeb ? 'web_photo' : (_photo as File).path,
        orderDate: DateTime.now(),
      );

      // TODO: Implement payment processing
      // TODO: Send email to admin with order details and photo

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Order Successful'),
            content: const Text(
              'Your student card order has been submitted successfully. '
              'You will be notified when it is ready for collection.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Return to previous screen
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
