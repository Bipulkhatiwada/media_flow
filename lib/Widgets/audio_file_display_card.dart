import 'package:flutter/material.dart';
import 'package:media_flow/Models/songs_model.dart';
class AudioFileDisplayCard extends StatelessWidget {
  final SongsModel song;
  final void Function(SongsModel) onPlayAudio;

  const AudioFileDisplayCard({
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
          onTap: () => onPlayAudio(song),
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