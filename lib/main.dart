import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'startScreen.dart'; // Import the StartScreen file
import 'counterWidget.dart'; // Import the widgets
import 'TrophyAnimation.dart'; // ✅ Import Trophy Animation

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => ScreenUtilInit(
        designSize: const Size(375, 812), // iPhone X dimensions
        minTextAdapt: true,
        splitScreenMode: true,
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
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Cookie Clicker Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StartScreen(), // Load StartScreen from separate file
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  double scale = 1.0;
  double clickMulti = 0.5;
  int upgradeCost = 15;
  int totalClicks = 0;
  Timer? timer;
  bool isAutoIncrementing = false;
  double autoIncrementSpeed = 1.0; // Starts at 1 second per tick
  bool showTrophy = false; // ✅ Controls trophy visibility
  bool hasTrophyShown = false; // ✅ Prevents multiple triggers at 1,000,000

  @override
  void dispose() {
    timer?.cancel(); // Stop timer when widget is removed
    super.dispose();
  }

  void startAutoIncrement() {
    if (!isAutoIncrementing) {
      isAutoIncrementing = true;
      timer = Timer.periodic(
        Duration(milliseconds: (autoIncrementSpeed * 1000).toInt()),
            (timer) {
          setState(() {
            counter += 1;
          });

          // ✅ Show trophy only when hitting 1,000,000 for the first time
          if (counter >= 1000000 && !hasTrophyShown) {
            triggerTrophy();
          }
        },
      );
    }
  }

  void updateAutoIncrementSpeed() {
    timer?.cancel(); // Stop the existing timer
    autoIncrementSpeed *= 0.9; // Reduce interval by 10% per upgrade

    // Restart timer with new speed
    timer = Timer.periodic(
      Duration(milliseconds: (autoIncrementSpeed * 1000).toInt()),
          (timer) {
        setState(() {
          counter += 1;
        });

        // ✅ Show trophy only when hitting 1,000,000 for the first time
        if (counter >= 1000000 && !hasTrophyShown) {
          triggerTrophy();
        }
      },
    );
  }

  void incrementCounter() {
    setState(() {
      totalClicks += 1;
      counter += max(1, clickMulti.ceil());
      scale = 0.9;

      // ✅ Show trophy only when hitting 1,000,000 for the first time
      if (counter >= 1000000 && !hasTrophyShown) {
        triggerTrophy();
      }
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        scale = 1.0;
      });
    });
  }

  void upgrade() {
    if (counter >= upgradeCost) {
      setState(() {
        counter -= upgradeCost;
        clickMulti *= 2;
        upgradeCost *= 2;
      });

      if (!isAutoIncrementing) {
        startAutoIncrement(); // Start auto-increment after first upgrade
      } else {
        updateAutoIncrementSpeed(); // Speed up auto-increment after each upgrade
      }
    }
  }

  // ✅ Function to show the trophy only once at 1,000,000
  void triggerTrophy() {
    setState(() {
      showTrophy = true;
      hasTrophyShown = true; // Prevent future triggers
    });

    // ✅ Hide trophy after 3 seconds
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
            // ✅ Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/cookieBowl.jpg',
                fit: BoxFit.cover,
              ),
            ),

            // ✅ Trophy Animation Positioned Above the Total Counter
            if (showTrophy)
              Positioned(
                top: 70, // Trophy appears **just above the counter**
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: TrophyAnimation(
                  onAnimationComplete: () {
                    setState(() {
                      showTrophy = false;
                    });
                  },
                ),
              ),

            // ✅ Total Clicks Counter (Keep this below the trophy)
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Total Clicks: $totalClicks",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "$counter",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Game Elements Below
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: incrementCounter,
                  child: AnimatedScale(
                    scale: scale,
                    duration: const Duration(milliseconds: 100),
                    child: Image.asset(
                      'assets/images/betterCursor.png',
                      width: 150.w,
                      height: 150.h,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (counter >= upgradeCost)
                  ElevatedButton(
                    onPressed: upgrade,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
