import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_flow/Widgets/audio_file_display_card.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_bloc.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_event.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_state.dart';
import 'dart:async';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.title});

  final String title;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    context.read<MusicBloc>().add(ClearFilterSongs());
    super.dispose();
  }

  void _onSearchChanged(String text) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      context.read<MusicBloc>().add(SearchFileEvent(searchText: text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent keyboard from pushing content
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
        actions: [
          Expanded(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 64.w),
              child: TextField(
                controller: _controller,
                autofocus: true,
                autocorrect: false,
                decoration:  InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.cancel_outlined, color: Colors.black),
            onPressed: () {
              _controller.clear();
              context.read<MusicBloc>().add(const SearchFileEvent(searchText: ''));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<MusicBloc, MusicPlayerState>(
          buildWhen: (previous, current) =>
              previous.filteredFileList != current.filteredFileList,
          builder: (context, state) {
            final filteredFiles = state.filteredFileList ?? [];
            return DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.black54],
                ),
              ),
              child: filteredFiles.isEmpty
                  ? _buildEmptyState()
                  : _buildSearchResults(filteredFiles),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: EmptyScreen(
        title: "Search results Not Found",
        displayIcon: Icons.not_accessible,
      ),
    );
  }

  Widget _buildSearchResults(List<dynamic> filteredFiles) {
    return ListView.builder(
      padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      itemCount: filteredFiles.length,
      cacheExtent: 100,
      physics: const AlwaysScrollableScrollPhysics(),
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
    );
  }
}

// Modify your EmptyScreen widget to be centered properly
class EmptyScreen extends StatelessWidget {
  final String title;
  final IconData displayIcon;

  const EmptyScreen({
    Key? key,
    required this.title,
    required this.displayIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         SizedBox(height: 64.h),
        Icon(
          displayIcon,
          size: 80,
          color: Colors.grey,
        ),
         SizedBox(height: 16.h),
        Text(
          title,
          style:  TextStyle(
            fontSize: 18.sp,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer()
      ],
    );
  }
}