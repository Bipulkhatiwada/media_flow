import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_flow/Widgets/audio_file_display_card.dart';
import 'package:media_flow/Widgets/empty_screen.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_bloc.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_event.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.title});

  final String title;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    context.read<MusicBloc>().add(ClearFilterSongs());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
        actions: [
          SizedBox(
            width: 280,
            child: TextField(
              controller: _controller,
              autofocus: true,
              autocorrect: false,
              onChanged: (text) {
                context
                    .read<MusicBloc>()
                    .add(SearchFileEvent(searchText: text));
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.cancel_outlined, color: Colors.black),
            onPressed: () {
              _controller.text = "";
            },
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicPlayerState>(
      builder: (context, state) {
        final filteredFiles = state.filteredFileList ?? [];
        if (filteredFiles.isEmpty) {
          return const EmptyScreen(
            title: "Search results Not Found",
            displayIcon: Icons.not_accessible,
          );
        }
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.black54],
            ),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: filteredFiles.length,
            itemBuilder: (context, index) {
              final song = filteredFiles[index];
              return AudioFileDisplayCard(
                song: song,
                onPlayAudio: (selectedSong) {
                  final bloc = context.read<MusicBloc>();
                  bloc.add(SelectSongEvent(song: selectedSong));
                  bloc.add(ClearFilterSongs());
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }
}
