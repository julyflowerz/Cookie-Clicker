import 'package:flutter/material.dart'; // Import Flutter's material design package for UI components

// Stateless widget that displays the total number of clicks
class TotalClicksText extends StatelessWidget {
  final int totalClicks; // Stores the total number of clicks

  // Constructor that requires totalClicks to be passed
  const TotalClicksText({super.key, required this.totalClicks});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Total Clicks: $totalClicks', // Display text showing total clicks
      style: const TextStyle(
        fontSize: 20, // Set text size to 20
        color: Colors.white, // Set text color to white
        shadows: [Shadow(blurRadius: 5, color: Colors.black)], // Add a black shadow effect
      ),
    );
  }
}

// Stateless widget that displays the current counter value
class CounterDisplay extends StatelessWidget {
  final int counter; // Stores the current counter value

  // Constructor that requires the counter value to be passed
  const CounterDisplay({super.key, required this.counter});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$counter', // Display the counter value as text
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: Colors.white, // Set text color to white
        shadows: [const Shadow(blurRadius: 5, color: Colors.black)], // Add a black shadow effect
      ),
    );
  }
}
