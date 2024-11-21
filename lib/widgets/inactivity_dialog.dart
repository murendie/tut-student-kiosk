import 'dart:async';
import 'package:flutter/material.dart';

class InactivityDialog extends StatefulWidget {
  final VoidCallback onTimeout;
  final VoidCallback onContinue;

  const InactivityDialog({
    super.key,
    required this.onTimeout,
    required this.onContinue,
  });

  @override
  State<InactivityDialog> createState() => _InactivityDialogState();
}

class _InactivityDialogState extends State<InactivityDialog> {
  int _secondsRemaining = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          Navigator.of(context).pop();
          widget.onTimeout();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you still there?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('No activity detected. Returning to splash screen in:'),
          const SizedBox(height: 20),
          Text(
            '$_secondsRemaining seconds',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _timer.cancel();
            Navigator.of(context).pop();
            widget.onContinue();
          },
          child: const Text('Yes, I\'m here'),
        ),
      ],
    );
  }
}
