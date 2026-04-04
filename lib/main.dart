// CCNA TRACKER APP (MULTI-SCREEN VERSION - SIMPLE)
// Paste in main.d
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'videos.dart';// main.dart
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.grey),
    home: HomeScreen(), // Change this from RangeScreen to HomeScreen
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// MODEL



// ---------------- HOME PAGE ----------------
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  DateTime startDate = DateTime.now();

  int get completed => videos.where((v) => v.done).length;
  int get remaining => videos.length - completed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CCNA Tracker")),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text("Completed: $completed"),
                Text("Remaining: $remaining"),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(videos[index].title),
                  value: videos[index].done,
                  onChanged: (val) {
                    setState(() {
                      videos[index].done = val!;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController controller = TextEditingController();
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController titleController = TextEditingController();
              TextEditingController urlController = TextEditingController();

              return AlertDialog(
                title: Text("Add Video"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: "Title"),
                    ),
                    TextField(
                      controller: urlController,
                      decoration: InputDecoration(labelText: "URL"),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        videos.add(
                          Video(
                            titleController.text,
                            urlController.text,
                          ),
                        );
                      });
                      Navigator.pop(context);
                    },
                    child: Text("Add"),
                  )
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),

      // NAVIGATION BUTTON
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text("Menu")),

            ListTile(
              title: Text("Statistics"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatsPage(videos, startDate),
                  ),
                );
              },
            ),

            ListTile(
              title: Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- STATS PAGE ----------------
class StatsPage extends StatelessWidget {
  final List<Video> videos;
  final DateTime startDate;

  StatsPage(this.videos, this.startDate);

  int get completed => videos.where((v) => v.done).length;
  int get remaining => videos.length - completed;

  DateTime get expectedFinish {
    int days = videos.length;
    return startDate.add(Duration(days: days));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Statistics")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Start Date: ${startDate.toLocal().toString().split(' ')[0]}"),
            Text("Total Videos: ${videos.length}"),
            Text("Completed: $completed"),
            Text("Remaining: $remaining"),
            Text("Expected Finish: ${expectedFinish.toLocal().toString().split(' ')[0]}"),

            SizedBox(height: 20),

            LinearProgressIndicator(
              value: videos.isEmpty ? 0 : completed / videos.length,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- SETTINGS PAGE ----------------
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int videosPerDay = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Videos per day:"),

            Slider(
              value: videosPerDay.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: videosPerDay.toString(),
              onChanged: (value) {
                setState(() {
                  videosPerDay = value.toInt();
                });
              },
            ),

            Text("$videosPerDay videos/day"),
          ],
        ),
      ),
    );
  }
}
