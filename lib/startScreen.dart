import 'package:flutter/material.dart'; // Import Flutter's material design package for UI components
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import screen adaptation package for responsive design
import 'main.dart'; // Import the main file to allow navigation to MyHomePage

// Stateless widget representing the start screen of the game
class StartScreen extends StatelessWidget {
  const StartScreen({super.key}); // Constructor with a key for widget identification

  @override
  Widget build(BuildContext context) {
    return SafeArea( // Ensures UI elements are within the safe area (e.g., avoids notches on phones)
      child: Scaffold( // Provides a basic page structure with app bar, body, etc.
        body: Stack( // Stack allows elements to be layered on top of each other
          children: [
            Positioned.fill( // Fills the entire screen with the background image
              child: Image.asset(
                'assets/images/backroom.jpg', // Path to the background image
                fit: BoxFit.cover, // Ensures the image covers the entire screen
              ),
            ),
            Center( // Centers the content in the middle of the screen
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Aligns children to the center of the column
                children: [
                  Text(
                    "COOKIE CLICKER", // Title of the game
                    style: const TextStyle(
                      fontSize: 40, // Sets text size
                      fontWeight: FontWeight.bold, // Makes text bold
                      fontFamily: 'Bloodsoul', // Custom font for a unique look
                      color: Colors.red, // Sets text color to red
                      shadows: [ // Adds a shadow effect to the text
                        Shadow(
                          blurRadius: 10, // Blur intensity of the shadow
                          color: Colors.black, // Shadow color
                          offset: Offset(4, 4), // X and Y offset to create a shadow effect
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20), // Adds spacing between the title and button
                  ElevatedButton(
                    onPressed: () { // Functionality triggered when the button is pressed
                      Navigator.push( // Pushes a new screen onto the navigation stack
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(title: 'Cookie Clicker Game'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Sets button background color to black
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15), // Adjusts button padding
                      textStyle: const TextStyle(
                        fontSize: 20, // Sets button text size
                        fontFamily: 'Bloodsoul', // Custom font for button text
                        color: Colors.white, // Button text color
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounds the corners of the button
                        side: const BorderSide(color: Colors.red, width: 2), // Adds a red border to the button
                      ),
                    ),
                    child: const Text("Press Start."), // Text displayed on the button
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
