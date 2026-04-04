import 'package:flutter/material.dart';
import 'range_screen.dart';
import 'videos.dart';

class HomeScreen extends StatelessWidget {
  // home_screen.dart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      // Dark grey background for a clean look
      appBar: AppBar(
        title: const Text("CCNA Study Home"),
        backgroundColor: Colors.grey[850],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your Computer Icon
              const Icon(Icons.computer, size: 80, color: Colors.white),
              const SizedBox(height: 30), // Adds space between icon and button

              // Your Navigation Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Make sure 'videos' matches the name in your videos.dart file
                      builder: (context) => RangeScreen(allVideos: videos),
                    ),
                  );
                },
                child: const Text(
                  "View Video Ranges",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}