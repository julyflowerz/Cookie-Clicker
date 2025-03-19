import 'package:flutter/material.dart';

class TotalClicksText extends StatelessWidget {
  final int totalClicks;
  const TotalClicksText({super.key, required this.totalClicks});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Total Clicks: $totalClicks',
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
        shadows: [Shadow(blurRadius: 5, color: Colors.black)],
      ),
    );
  }
}

class CounterDisplay extends StatelessWidget {
  final int counter;
  const CounterDisplay({super.key, required this.counter});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$counter',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: Colors.white,
        shadows: [const Shadow(blurRadius: 5, color: Colors.black)],
      ),
    );
  }
}
