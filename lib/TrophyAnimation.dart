import 'dart:async'; // Import the Timer class to handle delayed animations
import 'package:flutter/material.dart'; // Import Flutter's material design package for UI components

// Stateful widget that handles the trophy animation
class TrophyAnimation extends StatefulWidget {
  final VoidCallback onAnimationComplete; // Callback function to notify when animation is complete

  // Constructor with required callback parameter
  const TrophyAnimation({Key? key, required this.onAnimationComplete})
      : super(key: key);

  @override
  _TrophyAnimationState createState() => _TrophyAnimationState(); // Creates the state for this widget
}

// State class that controls the trophy animation behavior
class _TrophyAnimationState extends State<TrophyAnimation> {
  double topPosition = -100; // Initial position of the trophy (off-screen above the view)

  @override
  void initState() {
    super.initState();
    _startAnimation(); // Start the animation when the widget is initialized
  }

  // Function to animate the trophy dropping down and disappearing after a delay
  void _startAnimation() {
    setState(() {
      topPosition = 120; // Moves the trophy down to a visible position above the counter
    });

    // Hide the trophy after 3 seconds
    Timer(Duration(seconds: 3), () {
      if (mounted) { // Ensure the widget is still in the tree before updating state
        setState(() {
          topPosition = -100; // Move the trophy back up off-screen
        });
        widget.onAnimationComplete(); // Call the callback function to notify that animation is done
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack( // Stack allows positioning of elements on top of each other
      children: [
        AnimatedPositioned( // Widget that animates movement between positions
          duration: Duration(seconds: 1), // Duration of the drop-down animation
          curve: Curves.easeOut, // Easing function to make animation smooth
          top: topPosition, // Vertical position of the trophy
          left: MediaQuery.of(context).size.width / 2 - 50, // Centers the trophy horizontally
          child: Image.asset( // Load the trophy image from assets
            'assets/trophy/million.png', // Path to the trophy image
            width: 100, // Set width of the trophy image
            height: 100, // Set height of the trophy image
          ),
        ),
      ],
    );
  }
}
