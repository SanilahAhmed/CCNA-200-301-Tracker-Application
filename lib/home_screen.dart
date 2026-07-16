import 'package:ccna_tracker/main.dart';
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

              // Your Navigation
              const Text(
                "CCNA Tracker App",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Based on Jeremy's IT Lab",
                style: TextStyle(color: Colors.grey[400]),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: const Text(
                  "Start",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}//VideoListPage(title: "Day 1 to 10", displayVideos: videos),