import 'package:flutter/material.dart';
import 'videos.dart';
import 'package:url_launcher/url_launcher.dart';


class RangeScreen extends StatelessWidget {
  final List<Video> allVideos; // Pass your full list here

  RangeScreen({required this.allVideos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Basic Grey Background
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text("CCNA Study Ranges"),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two boxes per row
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: (allVideos.length / 10).ceil(), // Creates a box for every 10 videos
        itemBuilder: (context, index) {
          int start = index * 10;
          int end = (index + 1) * 10;
          if (end > allVideos.length) end = allVideos.length;

          return InkWell(
            onTap: () {
              // Filters the list and sends only those 10 videos to the next page
              List<Video> subList = allVideos.sublist(start, end);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoListPage(
                    title: "Episodes ${start + 1} - $end",
                    displayVideos: subList,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "Day ${start + 1} to $end",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
class VideoListPage extends StatefulWidget {
  final String title;
  final List<Video> displayVideos;

  VideoListPage({required this.title, required this.displayVideos});

  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  @override
  Future<void> _openVideo(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Every build method MUST start with a return statement
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.grey[850],
      ),
      body: ListView.builder(
        itemCount: widget.displayVideos.length,
        itemBuilder: (context, index) {
          final video = widget.displayVideos[index];

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              // 1. THIS MAKES THE ENTIRE ROW CLICKABLE
              onTap: () {
                _openVideo(video.url); // This calls the function from Step 3
              },

              // 2. THE TEXT PART
              title: Text(
                  video.title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)
              ),
              subtitle: const Text(
                  "Tap to watch on YouTube",
                  style: TextStyle(fontSize: 11, color: Colors.blueGrey)
              ),

              // 3. THE CHECKBOX PART (Stays on the right side)
              trailing: Checkbox(
                activeColor: Colors.grey[800],
                value: video.done,
                onChanged: (bool? val) {
                  setState(() {
                    video.done = val!;
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
