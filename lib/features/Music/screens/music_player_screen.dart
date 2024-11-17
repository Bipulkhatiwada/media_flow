import 'package:flutter/material.dart';
import 'package:media_flow/Widgets/audio_file_list.dart';
import 'music_player_bar.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({
    super.key,
    required this.title,
    this.filePath,
    this.fileSelected,
  });

  final String title;
  final String? filePath;
  final VoidCallbackAction? fileSelected;

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 16,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ],
            ),
          ),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Implement more options
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 161, 238, 133).withOpacity(0.4),
              const Color(0xFF1A1A1A),
              const Color(0xFF1A1A1A),
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SafeArea(
                  child: Scrollbar(
                      thickness: 10,
                      controller: _scrollController, // Here
                      child: const AudioFileList())
                  // RawScrollbar(
                  //   controller: _scrollController,
                  //   thumbColor: Colors.white.withOpacity(0.3),
                  //   radius: const Radius.circular(20),
                  //   thickness: 6,
                  //   thumbVisibility: true,
                  //   child: ,
                  // ),
                  ),
            ),

            // Divider with gradient
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color.fromARGB(255, 118, 241, 120).withOpacity(0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            // Player Controls
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: BackdropFilter(
                  filter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.darken,
                  ),
                  child: const MusicPlayerControls(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
