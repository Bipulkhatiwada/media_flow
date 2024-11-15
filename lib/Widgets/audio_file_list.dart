import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_flow/Models/songs_model.dart';
import 'package:media_flow/bloc/musicPlayer_bloc.dart';
import 'package:media_flow/bloc/musicPlayer_event.dart';
import 'package:media_flow/bloc/musicPlayer_state.dart';
import 'package:file_picker/file_picker.dart';

class AudioFileList extends StatefulWidget {

  const AudioFileList({super.key});

  @override
  _AudioFileListState createState() => _AudioFileListState();
}

class _AudioFileListState extends State<AudioFileList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<MusicBloc>().add(FetchSongEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<MusicBloc, MusicPlayerState>(
        builder: (context, state) {
          if (state.songList == null || state.songList!.isEmpty) {
            return _buildEmptyState();
          } else {
            return _buildAudioList(state.songList!);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchAudioFiles,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_note,
            color: Colors.green,
            size: 80,
          ),
          SizedBox(height: 20),
          Text(
            'No audio files found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Tap the + button to add your favorite audio files.',
            style: TextStyle(fontSize: 14, color: Colors.black45),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

Widget _buildAudioList(List<SongsModel> audioFiles) {
  return BlocListener<MusicBloc, MusicPlayerState>(
    listener: (context, state) {
      if (state.songList != null && state.song != null) {
        final song = state.songList!.singleWhere(
          (song) => song.name == state.song?.name,
          orElse: () => SongsModel(), 
        );
        int songIndex = state.songList!.indexOf(song);
        if (songIndex != -1) {
          _scrollToIndex(songIndex);
        }
            }
    },
    child: ListView.builder(
      controller: _scrollController, 
      itemCount: audioFiles.length,
      itemBuilder: (context, index) {
        return _buildAudioCard(audioFiles[index]);
      },
    ),
  );
}


  Widget _buildAudioCard(SongsModel song) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(
            color: song.selected ? Colors.greenAccent : Colors.white30,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: const Icon(Icons.music_note, color: Colors.green),
          title: Text(
            song.name ?? 'Unknown',
            maxLines: 2,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.play_circle_filled, color: Colors.green),
            onPressed: () => _playAudio(song),
          ),
          onTap: () => _playAudio(song),
        ),
      ),
    );
  }

  void _playAudio(SongsModel song) {
    context.read<MusicBloc>().add(SelectSongEvent(song: song));
    // widget.onFileSelected(song.path);
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

  void _scrollToIndex(int index) {
    if (index >= 0) {
      double position = index * 80; 
      _scrollController.animateTo(
        position,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}
