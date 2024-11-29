import 'dart:html' as html;
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final List<Map<String, dynamic>> _paymentItems = [
    {
      'name': 'Registration Fee',
      'description': 'Annual registration fee for 2024',
      'amount': 2500.00,
    },
    {
      'name': 'Student Card',
      'description': 'New student card for 2024',
      'amount': 100.00,
    },
    // Add more payment items as needed
  ];

  double _calculateTotal() {
    return _paymentItems.fold(0, (sum, item) => sum + item['amount']);
  }

  void _initiatePayment(String itemName, double amount) {
    // Create the form
    final form = html.FormElement();
    form.method = 'POST';
    form.action = 'https://www.payfast.co.za/eng/process';

    // Add the required hidden fields
    _addHiddenInput(form, 'merchant_id', '12137786');
    _addHiddenInput(form, 'merchant_key', 'mmg8vj8hcxoma');
    _addHiddenInput(form, 'amount', amount.toStringAsFixed(2));
    _addHiddenInput(form, 'item_name', itemName);

    // Add return and cancel URLs
    _addHiddenInput(form, 'return_url', 'https://tut-kiosk.co.za/payment/success');
    _addHiddenInput(form, 'cancel_url', 'https://tut-kiosk.co.za/payment/cancel');
    _addHiddenInput(form, 'notify_url', 'https://tut-kiosk.co.za/payment/notify');

    // Add the form to the document body and submit it
    html.document.body?.append(form);
    form.submit();
    form.remove();
  }

  void _addHiddenInput(html.FormElement form, String name, String value) {
    final input = html.InputElement()
      ..type = 'hidden'
      ..name = name
      ..value = value;
    form.append(input);
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: const Color(0xFF005496),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fee Statement',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005496),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Student Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005496),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow('Student Number:', '219123456'),
                    _buildInfoRow('Name:', 'Thabo Mokoena'),
                    _buildInfoRow(
                      'Course:',
                      'Postgraduate Diploma in Computer Science',
                    ),
                    _buildInfoRow('Academic Year:', '2024'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _paymentItems.length,
              itemBuilder: (context, index) {
                final item = _paymentItems[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(
                      item['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item['description']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'R ${item['amount'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _initiatePayment(
                            item['name'],
                            item['amount'],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005496),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Pay'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              color: const Color(0xFF005496),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'R ${_calculateTotal().toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _initiatePayment(
                  'Total Fees',
                  _calculateTotal(),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005496),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Pay Total Amount'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
