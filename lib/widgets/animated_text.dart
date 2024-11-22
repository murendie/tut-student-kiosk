import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_item.dart';

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

class AnimatedNewsText extends StatelessWidget {
  const AnimatedNewsText({super.key});

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create a single string with all news items
    final String newsText = tutNews.map((item) {
      return '${item.title} • ';
    }).join('');

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF005496).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF005496),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
            ),
            child: const Center(
              child: Text(
                'NEWS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTapDown: (TapDownDetails details) {
                // Calculate which news item was tapped based on position
                final RenderBox box = context.findRenderObject() as RenderBox;
                final double position = details.localPosition.dx;
                final double totalWidth = box.size.width;
                
                // Calculate approximate index based on position
                int index = (position / totalWidth * tutNews.length).floor();
                index = index.clamp(0, tutNews.length - 1);
                
                _launchUrl(tutNews[index].url);
              },
              child: Marquee(
                text: newsText,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF005496),
                ),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                blankSpace: 60.0,
                velocity: 50.0,
                pauseAfterRound: const Duration(seconds: 1),
                startPadding: 10.0,
                accelerationDuration: const Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: const Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
