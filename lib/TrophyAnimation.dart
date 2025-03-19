import 'dart:async';
import 'package:flutter/material.dart';

class TrophyAnimation extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const TrophyAnimation({Key? key, required this.onAnimationComplete})
      : super(key: key);

  @override
  _TrophyAnimationState createState() => _TrophyAnimationState();
}

class _TrophyAnimationState extends State<TrophyAnimation> {
  double topPosition = -100; // Start off-screen

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    setState(() {
      topPosition = 120; // Moves trophy **right above the counter**
    });

    // Hide after 3 seconds
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          topPosition = -100; // Move back up
        });
        widget.onAnimationComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(seconds: 1),
          curve: Curves.easeOut,
          top: topPosition, // Moves trophy above the counter
          left: MediaQuery.of(context).size.width / 2 - 50,
          child: Image.asset(
            'assets/trophy/million.png',
            width: 100,
            height: 100,
          ),
        ),
      ],
    );
  }
}