import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.title, required this.videoFile});

  final String title;
  final File videoFile;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..addListener(() {
        debugPrint("Controller state updated: ${_controller.value.isPlaying}");
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((_) {
        debugPrint("Controller initialized successfully");
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: _controller.value.isInitialized
          ? Column(
              children: [
                _buildVideoPlayer(),
                _buildVideoControls(),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
    );
  }

  Widget _buildVideoPlayer() {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          VideoPlayer(_controller),
          _ControlsOverlay(controller: _controller),
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              backgroundColor: Colors.grey,
              playedColor: Colors.green,
              bufferedColor: Colors.lightGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.green,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                _controller.value.isPlaying ? _controller.pause() : _controller.play();
              });
            },
          ),
          PopupMenuButton<double>(
            initialValue: _controller.value.playbackSpeed,
            tooltip: 'Playback Speed',
            onSelected: (speed) {
              _controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return _ControlsOverlay.playbackRates.map((speed) {
                return PopupMenuItem<double>(
                  value: speed,
                  child: Text('${speed}x'),
                );
              }).toList();
            },
            child: const Icon(
              Icons.speed,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  final VideoPlayerController controller;

  static const List<double> playbackRates = <double>[
    0.5,
    1.0,
    1.5,
    2.0,
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        if (!controller.value.isPlaying)
          const Center(
            child: Icon(
              Icons.play_arrow,
              size: 80,
              color: Colors.white,
            ),
          ),
      ],
    );
  }
}