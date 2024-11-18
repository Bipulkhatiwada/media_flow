import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_flow/Models/songs_model.dart';
import 'package:media_flow/Widgets/seek_bar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_bloc.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_state.dart';

class MusicPlayerControls extends StatefulWidget {
  const MusicPlayerControls({super.key});

  @override
  _MusicPlayerControlsState createState() => _MusicPlayerControlsState();
}

class _MusicPlayerControlsState extends State<MusicPlayerControls> {
  final _player = AudioPlayer();
  
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, buffered, duration) => 
            PositionData(position, buffered, duration ?? Duration.zero),
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<MusicBloc, MusicPlayerState>(
      listener: (context, state) async {
        if (state.song?.path != null) {
          try {
            await _player.setAudioSource(
              AudioSource.uri(Uri.parse(state.song?.path ?? ""))
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString()))
            );
          }
        }
      },
      child: Container(
        color: Colors.black,
        child: StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            return BlocBuilder<MusicBloc, MusicPlayerState>(
              builder: (context, state) => SeekBar(
                player: _player,
                title: state.song?.name,
                duration: snapshot.data?.duration ?? Duration.zero,
                position: snapshot.data?.position ?? Duration.zero,
                bufferedPosition: snapshot.data?.bufferedPosition ?? Duration.zero,
                onChangeEnd: _player.seek,
                song: state.song ?? SongsModel(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  PositionData(this.position, this.bufferedPosition, this.duration);
}