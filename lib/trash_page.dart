import 'package:flutter/material.dart';
import 'videos.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveVideos() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> data =
  videos.map((v) => jsonEncode(v.toJson())).toList();
  prefs.setStringList('videos', data);
}

class TrashPage extends StatefulWidget {
  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  @override
  Widget build(BuildContext context) {

    final trash =
    videos.where((v) => v.isDeleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Trash"),
      ),

      body: ListView.builder(
        itemCount: trash.length,
        itemBuilder: (context, index) {

          return ListTile(
            title: Text(trash[index].title),

            leading: IconButton(
              icon: Icon(Icons.restore),

                onPressed: () async {
                  setState(() {
                    trash[index].isDeleted = false;
                    trash[index].deletedAt = null;
                  });

                  await saveVideos();

                  Navigator.pop(context);

                  print(videos[index].isDeleted);
                }

            ),

            trailing: TextButton.icon(
              onPressed: () {
                setState(() {
                  videos.remove(trash[index]);
                });
                saveVideos();
              },
              icon: Icon(
                Icons.delete_forever,
                color: Colors.blueGrey,
              ),
              label: Text(
                "Delete Permenantly",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          );
        },
      ),
    );
  }
}