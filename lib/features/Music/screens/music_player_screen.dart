import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_bloc.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_event.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_state.dart';
import 'package:media_flow/core/Navigation/navigation_service.dart';
import 'package:media_flow/features/Music/screens/Nested%20TabBar/nested_tabBar.dart';
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
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    context.read<MusicBloc>().add(FetchSongEvent());
  }

  @override
  Widget build(BuildContext context) {
    log("######rebuild");
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
              NavigationService.navigateToSearchBar(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {

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
            const Expanded(
              child: SafeArea(
                  child:  NestedTabBar("")),
            ),
            // Player Controls
            BlocBuilder<MusicBloc, MusicPlayerState>(
                builder: (context, state) {
                  return Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          offset: Offset(0, -5),
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
                        child: const MiniMizedMusicPlayerControls(),
                      ),
                    ),
                  );
                },
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
