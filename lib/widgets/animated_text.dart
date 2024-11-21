import 'package:flutter/material.dart';

class AnimatedWelcomeText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const AnimatedWelcomeText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  State<AnimatedWelcomeText> createState() => _AnimatedWelcomeTextState();
}

class _AnimatedWelcomeTextState extends State<AnimatedWelcomeText>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  bool _isAnimating = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimation();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.text.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutBack,
        ),
      );
    }).toList();
  }

  void _startAnimation() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(Duration(milliseconds: 50 * i));
      if (mounted) {
        _controllers[i].forward();
      }
    }

    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      _fadeOutAndRepeat();
    }
  }

  void _fadeOutAndRepeat() async {
    for (var controller in _controllers.reversed) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (mounted) {
        controller.reverse();
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      _startAnimation();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.text.length,
        (index) => ScaleTransition(
          scale: _animations[index],
          child: Text(
            widget.text[index],
            style: widget.style,
          ),
        ),
      ),
    );
  }
}
