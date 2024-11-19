import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_flow/Models/songs_model.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_bloc.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_event.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_state.dart';
import 'package:file_picker/file_picker.dart';

class AudioFileList extends StatefulWidget {
  const AudioFileList({super.key});

  @override
  _AudioFileListState createState() => _AudioFileListState();
}

class _AudioFileListState extends State<AudioFileList> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _itemKeys = {};

  @override
  void initState() {
    super.initState();
    context.read<MusicBloc>().add(FetchSongEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: BlocBuilder<MusicBloc, MusicPlayerState>(
        builder: (context, state) {
          if (state.songList == null || state.songList!.isEmpty) {
            return _buildEmptyState();
          } else {
            return _buildAudioList(context, state.songList!);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchAudioFiles,
        elevation: 8,
        backgroundColor: const Color(0xFF1DB954),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.withOpacity(0.2),
            Colors.black,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.music_note,
                color: Color(0xFF1DB954),
                size: 80,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Library is Empty',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Tap the + button to add your favorite audio files',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioList(BuildContext context, List<SongsModel> audioFiles) {
    return BlocListener<MusicBloc, MusicPlayerState>(
      listener: (context, state) {
        if (state.songList != null && state.song != null) {
          final song = state.songList!.singleWhere(
            (song) => song.name == state.song?.name,
            orElse: () => SongsModel(),
          );
          int songIndex = state.songList!.indexOf(song);
          if (songIndex != -1) {
            _scrollToIndex(context, songIndex);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.withOpacity(0.2),
              Colors.black,
            ],
          ),
        ),
        // child: 
        // SingleChildScrollView(
        //   controller: _scrollController,
        //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        //   child: Column(
        //     children: audioFiles.map((song) => _buildAudioCard(song)).toList(),
        //   ),
        // ),
        child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: audioFiles.length,
        itemBuilder: (context, index) {
          return _buildAudioCard(audioFiles[index]);
        },
      ),
      ),
    );
  }

  Widget _buildAudioCard(SongsModel song) {
    _itemKeys.putIfAbsent(song.name ?? '', () => GlobalKey());
    
    return Container(
      key: _itemKeys[song.name ?? ''],
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: song.selected
              ? [const Color(0xFF1DB954), const Color(0xFF169142)]
              : [const Color(0xFF282828), const Color(0xFF1E1E1E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _playAudio(song),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.music_note,
                    color: song.selected ? Colors.white : const Color(0xFF1DB954),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    song.name ?? 'Unknown',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: song.selected
                          ? Colors.white
                          : Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight:
                          song.selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: song.selected
                        ? Colors.white.withOpacity(0.2)
                        : const Color(0xFF1DB954).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      song.selected
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: song.selected
                          ? Colors.white
                          : const Color(0xFF1DB954),
                      size: 24,
                    ),
                    onPressed: () => _playAudio(song),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _playAudio(SongsModel song) {
    context.read<MusicBloc>().add(SelectSongEvent(song: song));
  }

  void _fetchAudioFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'aac', 'm4a'],
    );

    if (result != null) {
      context.read<MusicBloc>().add(SaveSongEvent(songs: result.files));
    }
  }

  void _scrollToIndex(BuildContext context, int index) {
    if (index >= 0) {
      final song = context.read<MusicBloc>().state.songList?[index];
      if (song != null) {
        final key = _itemKeys[song.name ?? ''];
        if (key?.currentContext != null) {
          Scrollable.ensureVisible(
            key!.currentContext!,
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            alignment: 0.5,
          );
        }
      }
    }
  }

}