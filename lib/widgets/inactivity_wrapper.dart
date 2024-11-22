import 'dart:async';
import 'package:flutter/material.dart';
import 'inactivity_dialog.dart';

class InactivityWrapper extends StatefulWidget {
  final Widget child;
  final Duration inactivityDuration;

  const InactivityWrapper({
    super.key,
    required this.child,
    this.inactivityDuration = const Duration(minutes: 2),
  });

  @override
  State<InactivityWrapper> createState() => _InactivityWrapperState();
}

class _InactivityWrapperState extends State<InactivityWrapper> {
  Timer? _inactivityTimer;
  bool _dialogVisible = false;

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(widget.inactivityDuration, _showInactivityDialog);
  }

  void _showInactivityDialog() {
    if (_dialogVisible || !mounted) return;
    setState(() => _dialogVisible = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => InactivityDialog(
        onTimeout: () {
          setState(() => _dialogVisible = false);
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        },
        onContinue: () {
          setState(() => _dialogVisible = false);
          _resetInactivityTimer();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _resetInactivityTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _resetInactivityTimer(),
      onPointerMove: (_) => _resetInactivityTimer(),
      child: widget.child,
    );
  }
}
