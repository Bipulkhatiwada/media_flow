import 'package:flutter/material.dart';
import 'package:media_flow/Widgets/audio_file_list.dart';
import 'music_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title, this.filePath, this.fileSelected});

  final String title;
  final String? filePath;
  final VoidCallbackAction? fileSelected;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: const Column(
        children: [
          Expanded(
            child: Center(
              child: AudioFileList(),
            ),
          ),
          Divider(),
          SizedBox(
            height: 250,
            child: MusicPlayer(),
          ),
        ],
      ),
    );
  }
}
