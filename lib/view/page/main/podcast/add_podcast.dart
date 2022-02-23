import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddPodcast extends StatefulWidget {
  const AddPodcast({Key? key}) : super(key: key);

  @override
  State<AddPodcast> createState() => _AddPodcastState();
}

List<File> data = [];

class _AddPodcastState extends State<AddPodcast> {
  pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png', 'mp3', 'mp4', 'm4a'],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      setState(() {
        data.addAll(files);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            'No file selected',
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 20 * 3,
          ),
          SizedBox(
            height: 20 * 20,
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Image.file(
                    data[index],
                    height: 120,
                    width: 120,
                  );
                }),
          ),
          SizedBox(
            height: 30 * 2,
          ),
          ElevatedButton(
            child: Text('Pick Podcast'),
            onPressed: () => pickFiles(),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            child: Text('Upload Podcast'),
            onPressed: () {
              if (data.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Uploading...')));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Congrats, Successfully Uploaded.')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.white,
                    content: Text(
                      'No file selected',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
