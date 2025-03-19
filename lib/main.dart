import 'dart:async'; // For handling timers
import 'dart:math'; // For mathematical calculations
import 'package:flutter/material.dart'; // Flutter UI toolkit
import 'package:device_preview/device_preview.dart'; // For previewing app on different devices
import 'package:flutter_screenutil/flutter_screenutil.dart'; // For screen size adaptation
import 'startScreen.dart'; // Import the StartScreen file
import 'counterWidget.dart'; // Import the widgets
import 'TrophyAnimation.dart'; // Import Trophy Animation

void main() {
  runApp(
    DevicePreview(
      enabled: true, // Enable device preview
      builder: (context) => ScreenUtilInit(
        designSize: const Size(375, 812), // Set base screen size (iPhone X dimensions)
        minTextAdapt: true, // Allow text adaptation
        splitScreenMode: true, // Allow split screen
        builder: (context, child) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true, // Use system media settings
      locale: DevicePreview.locale(context), // Set locale from device preview
      builder: DevicePreview.appBuilder, // Wrap app for preview functionality
      title: 'Cookie Clicker Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Set theme colors
        useMaterial3: true, // Use Material 3 UI components
      ),
      home: const StartScreen(), // Load StartScreen (first screen of the app)
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title; // Title of the page

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0; // Tracks the number of cookies
  double scale = 1.0; // Animation scale for button press effect
  double clickMulti = 0.5; // Multiplier for click power
  int upgradeCost = 15; // Cost to upgrade click power
  int totalClicks = 0; // Total number of clicks made by the user
  Timer? timer; // Timer for auto-incrementing cookies
  bool isAutoIncrementing = false; // Tracks if auto-increment is active
  double autoIncrementSpeed = 1.0; // Initial auto-increment speed (1 second per tick)
  bool showTrophy = false; // Controls trophy visibility
  bool hasTrophyShown = false; // Prevents multiple triggers at 1,000,000 cookies

  @override
  void dispose() {
    timer?.cancel(); // Stop the timer when the widget is removed
    super.dispose();
  }

  void startAutoIncrement() {
    if (!isAutoIncrementing) {
      isAutoIncrementing = true; // Mark auto-increment as active
      timer = Timer.periodic(
        Duration(milliseconds: (autoIncrementSpeed * 1000).toInt()),
            (timer) {
          setState(() {
            counter += 1; // Increment counter automatically
          });

          // Show trophy when hitting 1,000,000 cookies for the first time
          if (counter >= 1000000 && !hasTrophyShown) {
            triggerTrophy();
          }
        },
      );
    }
  }

  void updateAutoIncrementSpeed() {
    timer?.cancel(); // Stop the existing timer
    autoIncrementSpeed *= 0.9; // Reduce interval by 10% per upgrade (faster auto clicks)

    // Restart timer with new speed
    timer = Timer.periodic(
      Duration(milliseconds: (autoIncrementSpeed * 1000).toInt()),
          (timer) {
        setState(() {
          counter += 1; // Increment counter automatically
        });

        // Show trophy when hitting 1,000,000 cookies for the first time
        if (counter >= 1000000 && !hasTrophyShown) {
          triggerTrophy();
        }
      },
    );
  }

  void incrementCounter() {
    setState(() {
      totalClicks += 1; // Increase total clicks count
      counter += max(1, clickMulti.ceil()); // Increase counter based on click multiplier
      scale = 0.9; // Reduce scale for click animation

      // Show trophy when hitting 1,000,000 cookies for the first time
      if (counter >= 1000000 && !hasTrophyShown) {
        triggerTrophy();
      }
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        scale = 1.0; // Reset scale after animation delay
      });
    });
  }

  void upgrade() {
    if (counter >= upgradeCost) {
      setState(() {
        counter -= upgradeCost; // Deduct upgrade cost
        clickMulti *= 2; // Double the click power
        upgradeCost *= 2; // Increase upgrade cost
      });

      if (!isAutoIncrementing) {
        startAutoIncrement(); // Start auto-increment after first upgrade
      } else {
        updateAutoIncrementSpeed(); // Speed up auto-increment after each upgrade
      }
    }
  }

  // Function to show the trophy only once at 1,000,000 cookies
  void triggerTrophy() {
    setState(() {
      showTrophy = true;
      hasTrophyShown = true; // Prevent future triggers
    });

    // Hide trophy after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showTrophy = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/cookieBowl.jpg', // Background image
                fit: BoxFit.cover,
              ),
            ),
            if (showTrophy)
              Positioned(
                top: 70,
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: TrophyAnimation(
                  onAnimationComplete: () {
                    setState(() {
                      showTrophy = false;
                    });
                  },
                ),
              ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Text("Total Clicks: $totalClicks", style: TextStyle(fontSize: 22, color: Colors.white)),
                  Text("$counter", style: TextStyle(fontSize: 40, color: Colors.white)),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: incrementCounter,
                  child: Image.asset('assets/images/betterCursor.png', width: 150.w, height: 150.h),
                ),
                if (counter >= upgradeCost)
                  ElevatedButton(
                    onPressed: upgrade,
                    child: Text("Boost Click Power (x2) - Cost: $upgradeCost"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
