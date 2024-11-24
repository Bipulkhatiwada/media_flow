import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_flow/Models/songs_model.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';

class AudioFileDisplayCard extends StatelessWidget {
  final SongsModel song;
  final void Function(SongsModel) onPlayAudio;

  const AudioFileDisplayCard({super.key, 
    required this.song,
    required this.onPlayAudio,
  });

  @override
  Widget build(BuildContext context) {
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
          onTap: () => onPlayAudio(song),
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
                  // child: Icon(
                  //   Icons.music_note,
                  //   color: song.selected ? Colors.white : const Color(0xFF1DB954),
                  //   size: 24,
                  // ),
                  child: QueryArtworkWidget(
                      id: song.songModel?.id ?? 0,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: Icon(
                        Icons.music_note,
                        color: song.selected
                            ? Colors.white
                            : const Color(0xFF1DB954),
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
                      fontSize: 16,
                      fontWeight:
                          song.selected ? FontWeight.w600 : FontWeight.normal,
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
                    onPressed: () => onPlayAudio(song),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
