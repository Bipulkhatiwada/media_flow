import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_flow/features/Music/Data/models/songs_model.dart';
import 'package:media_flow/Widgets/control_buttons.dart';
import 'package:media_flow/features/Music/Presentation/bloc/MusicBloc/remote/musicPlayer_bloc.dart';
import 'package:media_flow/features/Music/Presentation/bloc/MusicBloc/remote/musicPlayer_event.dart';
import 'package:media_flow/features/Music/Presentation/bloc/MusicBloc/remote/musicPlayer_state.dart';

class SeekBar extends StatefulWidget {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  final ValueChanged<Duration> onChangeEnd;
  final String? title;
  final AudioPlayer player;
  final SongsModel song;

  const SeekBar({
    required this.position,
    required this.bufferedPosition,
    required this.duration,
    required this.onChangeEnd,
    required this.title,
    required this.player,
    required this.song,
    super.key,
  });

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  @override
  void initState() {
    super.initState();
    widget.player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        context.read<MusicBloc>().add(NextSongEvent(song: widget.song));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicPlayerState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Container(
          color: const Color.fromARGB(66, 56, 55, 55),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Container(
                  padding:  EdgeInsets.only(right: 13.0.h),
                ),
              ),
             SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(widget.position),
                    style: const TextStyle(color: Colors.green),
                  ),
                  Text(
                    _formatDuration(widget.duration),
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.green.withOpacity(0.5),
                  thumbColor: Colors.green,
                  overlayColor: Colors.green.withOpacity(0.2),
                  trackHeight: 4.0.h,
                ),
                child: Slider(
                  value: widget.position.inMilliseconds.toDouble(),
                  min: 0.0,
                  max: widget.duration.inMilliseconds.toDouble() + 10,
                  onChanged: (value) {
                    widget.onChangeEnd(Duration(milliseconds: value.toInt()));
                  },
                  onChangeEnd: (value) {
                    widget.onChangeEnd(Duration(milliseconds: value.toInt()));
                    if (value ==
                        widget.duration.inMilliseconds.toDouble() + 10) {}
                  },
                ),
              ),
              ControlButtons(player: widget.player, song: widget.song),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
