import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String url;

  VideoPlayerScreen(this.url);

  void openVideo() async {
    final Uri videoUrl = Uri.parse(url);

    if (!await launchUrl(videoUrl)) {
      throw "Could not open video";
    }
  }

  @override
  Widget build(BuildContext context) {
    openVideo();

    return Scaffold(
      appBar: AppBar(title: Text("Opening Video...")),
      body: Center(
        child: Text("Opening in browser..."),
      ),
    );
  }
}