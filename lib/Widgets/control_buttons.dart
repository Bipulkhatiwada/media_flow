import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_flow/Models/songs_model.dart';
import 'package:media_flow/bloc/musicPlayer_bloc.dart';
import 'package:media_flow/bloc/musicPlayer_event.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({Key? key, required this.player, required this.song}) : super(key: key);
  final AudioPlayer player;
  final SongsModel song;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.volume_up, color: Colors.green),
            onPressed: () => _showSlider(
              context,
              title: "Volume",
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            ),
          ),
           IconButton(
            icon: const Icon(Icons.skip_previous, color: Colors.green),
            onPressed: () => context.read<MusicBloc>().add(PrevSongEvent(song: song))
          ),
          StreamBuilder<PlayerState>(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              final isPlaying = snapshot.data?.playing ?? false;
              return FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: isPlaying ? player.pause : player.play,
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.black, 
                ),
              );
            },
          ),

           IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.green),
            onPressed: () => context.read<MusicBloc>().add(NextSongEvent(song: song))
          ),
          IconButton(
            icon: const Icon(Icons.speed, color: Colors.green),
            onPressed: () => _showSlider(
              context,
              title: "Speed",
              value: player.speed,
              stream: player.speedStream,
              onChanged: player.setSpeed,
            ),
          ),
        ],
      ),
    );
  }

  void _showSlider(
    BuildContext context, {
    required String title,
    required double value,
    required Stream<double> stream,
    required ValueChanged<double> onChanged,
  }) {
    showDialog(
  context: context,
  builder: (_) => AlertDialog(
    backgroundColor: const Color.fromARGB(255, 217, 245, 212), 
    title: Text(
      title,
      style: const TextStyle(color: Colors.green), 
    ),
    content: ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 16, // or any height you prefer
      ),
      child: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) {
          return SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.green,  
              inactiveTrackColor: Colors.green.withOpacity(0.5),
              thumbColor: Colors.green, 
              overlayColor: Colors.green.withOpacity(0.2), 
            ),
            child: Slider(
              value: snapshot.data ?? value,
              min: 0.0,
              max: 1.0,
              onChanged: onChanged,
            ),
          );
        },
      ),
    ),
  ),
);

  }
}
