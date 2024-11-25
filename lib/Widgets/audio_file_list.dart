import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_flow/features/Music/Data/models/songs_model.dart';
import 'package:media_flow/Widgets/empty_screen.dart';
import 'package:media_flow/Widgets/expandable_fab.dart';
import 'package:media_flow/features/Music/Presentation/bloc/MusicBloc/remote/musicPlayer_bloc.dart';
import 'package:media_flow/features/Music/Presentation/bloc/MusicBloc/remote/musicPlayer_event.dart';
import 'package:media_flow/features/Music/Presentation/bloc/MusicBloc/remote/musicPlayer_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AudioFileList extends StatefulWidget {
  const AudioFileList({super.key});

  @override
  _AudioFileListState createState() => _AudioFileListState();
}

class _AudioFileListState extends State<AudioFileList> {
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  
// Usage in your main widget:
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF1E1E1E),
    body: BlocBuilder<MusicBloc, MusicPlayerState>(
      builder: (context, state) {
        if (state.songList == null || state.songList!.isEmpty) {
          return const EmptyScreen(
            title: "Your Audio list is empty",
            displayIcon: Icons.music_note,
            descriptionText: "Click add Button to add the files",
          );
        } else {
          return _buildAudioList(context, state.songList!);
        }
      },
    ),
    floatingActionButton: ExpandableFab(
      onAddFiles: _fetchAudioFiles,
      onShuffle: _shuffleMusic,
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
            itemScrollController.scrollTo(
                index: songIndex ,
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOutCubic);
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
          child: ScrollablePositionedList.builder(
            padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            itemCount: audioFiles.length,
            itemBuilder: (context, index) => _buildAudioCard(audioFiles[index]),
            itemScrollController: itemScrollController,
          )
          ),
    );
  }

  Widget _buildAudioCard(SongsModel song) {
    return BlocBuilder<MusicBloc, MusicPlayerState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: song.selected
                  ? [const Color(0xFF1DB954), const Color(0xFF169142)]
                  : [const Color(0xFF282828), const Color(0xFF1E1E1E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
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
              borderRadius: BorderRadius.circular(12.r),
              onTap: () => _playAudio(song),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                  child: 
                  QueryArtworkWidget(
                    id: song.songModel?.id ?? 0, 
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: Icon(
                    Icons.music_note,
                    color:  song.selected  ? Colors.white : const Color(0xFF1DB954),
                    size: 24,
                  )),
                    ),
                     SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        song.name ?? 'Unknown',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: song.selected
                              ? Colors.white
                              : Colors.white.withOpacity(0.9),
                          fontSize: 16.sp,
                          fontWeight: song.selected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                     SizedBox(width: 12.w),
                    Container(
                      width: 42.w,
                      height: 42.h,
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
      },
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

  void _shuffleMusic() async {
    context.read<MusicBloc>().add(const ShuffleMusicEvent(toggleShuffle: true));
  }
}