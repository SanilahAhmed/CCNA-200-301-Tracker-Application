import 'package:flutter/material.dart';
import 'dart:io';
import 'home_screen.dart';
import 'videos.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'video_player_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'trash_page.dart';

ValueNotifier<ThemeMode> themeNotifier =
ValueNotifier(ThemeMode.system);

Future<void> loadTheme() async {
  final prefs = await SharedPreferences.getInstance();

  String? theme = prefs.getString("theme");

  switch (theme) {
    case "light":
      themeNotifier.value = ThemeMode.light;
      break;

    case "dark":
      themeNotifier.value = ThemeMode.dark;
      break;

    default:
      themeNotifier.value = ThemeMode.system;
  }
}

Future<void> saveTheme(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();

  switch (mode) {
    case ThemeMode.light:
      await prefs.setString("theme", "light");
      break;

    case ThemeMode.dark:
      await prefs.setString("theme", "dark");
      break;

    case ThemeMode.system:
      await prefs.setString("theme", "system");
      break;
  }

  themeNotifier.value = mode;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadTheme();

  if (Platform.isAndroid) {
    WebViewPlatform.instance = AndroidWebViewPlatform();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,

      builder: (context, currentTheme, child) {

        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            useMaterial3: true,

            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.light,
            ),

            scaffoldBackgroundColor: Colors.grey.shade100,

            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              centerTitle: true,
              elevation: 3,
            ),

            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),

            cardTheme: CardTheme(
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),

            checkboxTheme: CheckboxThemeData(
              fillColor: MaterialStateProperty.all(Colors.teal),
            ),
          ),

          darkTheme: ThemeData(
            useMaterial3: true,

            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.dark,
            ),

            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
              centerTitle: true,
            ),

            scaffoldBackgroundColor: Color(0xFF121212),

            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),

            cardTheme: CardTheme(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),

            checkboxTheme: CheckboxThemeData(
              fillColor: MaterialStateProperty.all(Colors.teal),
            ),
          ),

          themeMode: currentTheme,

          home: HomeScreen(),
        );
      },
    );
  }
}

// ---------------- HOME PAGE ----------------
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {


  Future<void> _openVideo(String url) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(url),
      ),
    );
  }
  DateTime startDate = DateTime.now();

  int get completed => videos.where((v) => v.done).length;
  int get remaining => videos.length - completed;


  @override
  void initState() {
    super.initState();
    loadVideos();
  }

  Future<void> saveVideos() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data =
    videos.map((v) => jsonEncode(v.toJson())).toList();
    prefs.setStringList('videos', data);
  }

  Future<void> loadVideos() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList('videos');

    if (data != null) {
      setState(() {

        videos.clear();
        videos.addAll(
          data.map((v) => Video.fromJson(jsonDecode(v))).toList(),
        );

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeVideos =
    videos.where((v) => !v.isDeleted).toList();

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
           itemCount: activeVideos.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(

                    title: Text(
                       activeVideos[index].title,
                      style: TextStyle(
                        decoration: activeVideos[index].done
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    leading: Checkbox(
                      value: activeVideos[index].done,
                      onChanged: (val) {
                        setState(() {
                          activeVideos[index].done = val!;
                        });
                        saveVideos();
                      },
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.teal),
                          onPressed: () {
                            setState(() {
                              activeVideos[index].isDeleted = true;
                              activeVideos[index].deletedAt = DateTime.now();
                            });

                            saveVideos();
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      _openVideo(activeVideos[index].url);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
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

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.school,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "CCNA Tracker",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text("Trash"),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrashPage(),
                  ),
                );

                await loadVideos();

                setState(() {});
              },

            ),

            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text("Statistics"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StatsPage(videos, startDate),
                  ),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.settings),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Statistics")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 30),

            Text(
              "CCNA Progress Chart",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 40),

            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,

                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text("Done");
                            case 1:
                              return Text("Left");
                          }
                          return Text("");
                        },
                      ),
                    ),
                  ),

                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: completed.toDouble(),
                          color: Colors.cyan,
                          width: 40,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: remaining.toDouble(),
                          color: Colors.blueGrey,
                          width: 40,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            Text("Total Videos: ${videos.length}"),
            Text("Completed: $completed"),
            Text("Remaining: $remaining"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
    children: [

    RadioListTile<ThemeMode>(
        title: Text("System Default"),
    value: ThemeMode.system,
    groupValue: themeNotifier.value,
    onChanged: (value) {
    saveTheme(value!);
    },
    ),

    RadioListTile<ThemeMode>(
    title: Text("Light"),
    value: ThemeMode.light,
    groupValue: themeNotifier.value,
    onChanged: (value) {
    saveTheme(value!);
    },
    ),

    RadioListTile<ThemeMode>(
    title: Text("Dark"),
    value: ThemeMode.dark,
    groupValue: themeNotifier.value,
    onChanged: (value) {
    saveTheme(value!);
    },
    ),

    ],
    ),
    );
  }
}