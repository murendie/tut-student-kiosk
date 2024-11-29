import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String _merchantId = '12137786';  // Production merchant ID
  static const String _merchantKey = 'mmg8vj8hcxoma';  // Production merchant key
  static const String _passPhrase = 'TrABYwaYdicIC1EiNeldN';
  static const bool _isSandbox = false; // Production mode

  static String get baseUrl => _isSandbox
      ? 'https://sandbox.payfast.co.za/eng/process'
      : 'https://www.payfast.co.za/eng/process';

  static String _generateSignature(Map<String, String> data) {
    // Sort the data alphabetically
    var orderedData = Map.fromEntries(
      data.entries.toList()..sort((a, b) => a.key.compareTo(b.key))
    );

    // Create the get string
    var getString = '';
    orderedData.forEach((key, value) {
      if (key != 'signature') {
        // Encode exactly like Node.js encodeURIComponent and replace %20 with +
        var encodedValue = Uri.encodeComponent(value).replaceAll('%20', '+');
        getString += '$key=$encodedValue&';
      }
    });

    // Remove the last '&'
    getString = getString.substring(0, getString.length - 1);

    // Add passphrase
    var finalString = getString + '&passphrase=${Uri.encodeComponent(_passPhrase.trim()).replaceAll('%20', '+')}';

    // Debug logging
    print('Data before signature:');
    orderedData.forEach((key, value) {
      print('$key: $value');
    });
    print('Final string for signature: $finalString');

    // Generate MD5 hash
    var signature = md5.convert(utf8.encode(finalString)).toString();
    print('Generated signature: $signature');
    
    return signature;
  }

  static Map<String, String> generatePaymentData({
    required String itemName,
    required double amount,
    required String returnUrl,
    required String cancelUrl,
    required String notifyUrl,
    required String email,
  }) {
    final data = {
      'merchant_id': _merchantId,
      'merchant_key': _merchantKey,
      'return_url': returnUrl,
      'cancel_url': cancelUrl,
      'notify_url': notifyUrl,
      'email_address': email,
      'm_payment_id': DateTime.now().millisecondsSinceEpoch.toString(),
      'amount': amount.toStringAsFixed(2),
      'item_name': itemName,
    };

    print('\nGenerating payment data:');
    print('Amount: ${amount.toStringAsFixed(2)}');
    print('Item name: $itemName');

    // Generate signature
    final signature = _generateSignature(data);
    data['signature'] = signature;

    print('Final payment data:');
    data.forEach((key, value) {
      print('$key: $value');
    });

    return data;
  }

  static Future<bool> verifyPayment(String paymentId) async {
    try {
      final response = await http.post(
        Uri.parse('${_isSandbox ? 'https://sandbox.payfast.co.za' : 'https://www.payfast.co.za'}/eng/query/validate'),
        body: {'m_payment_id': paymentId},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'COMPLETE';
      }
      return false;
    } catch (e) {
      print('Error verifying payment: $e');
      return false;
    }
  }
}
