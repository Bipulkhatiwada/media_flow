import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_flow/Models/songs_model.dart';
import 'package:media_flow/Widgets/seek_bar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:media_flow/bloc/musicPlayer_bloc.dart';
import 'package:media_flow/bloc/musicPlayer_state.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initializePlayer("");
  }

  Future<void> _initializePlayer(String filePath) async {
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(filePath)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

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
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  @override
  Widget build(BuildContext context) {
    SongsModel? song;

    return BlocListener<MusicBloc, MusicPlayerState>(
      listener: (context, state) {
        song = state.song ?? SongsModel();
        if (state.song?.path != null) _initializePlayer(state.song?.path ?? "");
      },
      child: Scaffold(
        backgroundColor: Colors.black, 
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: BlocBuilder<MusicBloc, MusicPlayerState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: StreamBuilder<PositionData>(
                          stream: _positionDataStream,
                          builder: (context, snapshot) {
                            final positionData = snapshot.data;
                            return SeekBar(
                              player: _player,
                              title: state.song?.name,
                              duration: positionData?.duration ?? Duration.zero,
                              position: positionData?.position ?? Duration.zero,
                              bufferedPosition:
                                  positionData?.bufferedPosition ?? Duration.zero,
                              onChangeEnd: _player.seek,
                              song: song ?? SongsModel(),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
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
