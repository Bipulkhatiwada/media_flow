import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_flow/features/Music/Data/models/songs_model.dart';
import 'package:media_flow/features/Music/Presentation/bloc/MusicBloc/remote/musicPlayer_bloc.dart';
import 'package:media_flow/features/Music/Presentation/bloc/MusicBloc/remote/musicPlayer_event.dart';
import 'package:media_flow/features/Music/Presentation/bloc/MusicBloc/remote/musicPlayer_state.dart';

class ControlButtons extends StatefulWidget {
  const ControlButtons({super.key, required this.player, required this.song});
  final AudioPlayer player;
  final SongsModel song;

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MusicBloc, MusicPlayerState>(
      listener: (context, state) {
        if (state.song?.name != null && state.song?.name != "") {
          widget.player.play();
        }else {
           widget.player.stop();
        }
      },
      child: Container(
        padding:  EdgeInsets.fromLTRB(16.w,16.h,16.w,0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.volume_up, color: Colors.green),
              onPressed: () => _showSlider(
                context,
                title: "Volume",
                value: widget.player.volume,
                stream: widget.player.volumeStream,
                onChanged: widget.player.setVolume,
              ),
            ),
            IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.green),
                onPressed: () => context
                    .read<MusicBloc>()
                    .add(PrevSongEvent(song: widget.song))),
            StreamBuilder<PlayerState>(
              stream: widget.player.playerStateStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data?.playing ?? false;
                return FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed:
                      isPlaying ? widget.player.pause : widget.player.play,
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                  ),
                );
              },
            ),
            IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.green),
                onPressed: () => context
                    .read<MusicBloc>()
                    .add(NextSongEvent(song: widget.song))),
            IconButton(
              icon: const Icon(Icons.speed, color: Colors.green),
              onPressed: () => _showSlider(
                context,
                title: "Speed",
                value: widget.player.speed,
                stream: widget.player.speedStream,
                onChanged: widget.player.setSpeed,
              ),
            ),
          ],
        ),
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
          constraints:  BoxConstraints(
            maxHeight: 16.h, // or any height you prefer
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

class MiniMizedControlButton extends StatefulWidget {
  const MiniMizedControlButton({super.key, required this.player, required this.song});
  final AudioPlayer player;
  final SongsModel song;

  @override
  State<MiniMizedControlButton> createState() => _MiniMizedControlButtonState();
}

class _MiniMizedControlButtonState extends State<MiniMizedControlButton> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MusicBloc, MusicPlayerState>(
      listener: (context, state) {
        if (state.song?.name != null && state.song?.name != "") {
          widget.player.play();
        } else {
          widget.player.stop();
        }
      },
      child: Container(
        color: Colors.black,
        padding:  EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0.h),
        child: Center(
          child: StreamBuilder<PlayerState>(
            stream: widget.player.playerStateStream,
            builder: (context, snapshot) {
              final isPlaying = snapshot.data?.playing ?? false;
              return FloatingActionButton(
                backgroundColor: Colors.transparent,
                onPressed: isPlaying ? widget.player.pause : widget.player.play,
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
