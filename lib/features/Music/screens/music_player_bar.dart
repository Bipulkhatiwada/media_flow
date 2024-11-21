import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_flow/Models/songs_model.dart';
import 'package:media_flow/Widgets/control_buttons.dart';
import 'package:media_flow/Widgets/seek_bar.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_event.dart';
import 'package:media_flow/core/Navigation/navigation_service.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_bloc.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_state.dart';

class MusicPlayerControls extends StatefulWidget {
  const MusicPlayerControls({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MusicPlayerControlsState createState() => _MusicPlayerControlsState();
}

class _MusicPlayerControlsState extends State<MusicPlayerControls> {
  @override
  void dispose() {
    context.read<MusicBloc>().state.audioPlayer.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream {
    var player = context.read<MusicBloc>().state.audioPlayer;
    return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      player.positionStream,
      player.bufferedPositionStream,
      player.durationStream,
      (position, buffered, duration) =>
          PositionData(position, buffered, duration ?? Duration.zero),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(66, 87, 86, 86),
        body: BlocBuilder<MusicBloc, MusicPlayerState>(
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.white),
                        onPressed: () {
                          NavigationService.pop(context);
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1DB954).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.music_note,
                            color: Color(0xFF1DB954),
                            size: 64,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          state.song?.name ?? "Music not Found",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "unknown Artist",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    color: Colors.black,
                    child: StreamBuilder<PositionData>(
                      stream: _positionDataStream,
                      builder: (context, snapshot) {
                        return BlocBuilder<MusicBloc, MusicPlayerState>(
                          buildWhen: (previous, current) =>
                              previous.song != current.song,
                          builder: (context, state) {
                            return SeekBar(
                              player: state.audioPlayer,
                              title: state.song?.name,
                              duration: snapshot.data?.duration ?? Duration.zero,
                              position: snapshot.data?.position ?? Duration.zero,
                              bufferedPosition: snapshot.data?.bufferedPosition ??
                                  Duration.zero,
                              onChangeEnd: state.audioPlayer.seek,
                              song: state.song ?? SongsModel(),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  PositionData(this.position, this.bufferedPosition, this.duration);
}

class MiniMizedMusicPlayerControls extends StatefulWidget {
  const MiniMizedMusicPlayerControls({super.key});

  @override
  _MiniMizedMusicPlayerControlsState createState() =>
      _MiniMizedMusicPlayerControlsState();
}

class _MiniMizedMusicPlayerControlsState
    extends State<MiniMizedMusicPlayerControls> {
  @override
  void dispose() {
    context.read<MusicBloc>().state.audioPlayer.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream {
    var player = context.read<MusicBloc>().state.audioPlayer;
    return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      player.positionStream,
      player.bufferedPositionStream,
      player.durationStream,
      (position, buffered, duration) =>
          PositionData(position, buffered, duration ?? Duration.zero),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MusicBloc, MusicPlayerState>(
      listener: (c, s) {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            return BlocBuilder<MusicBloc, MusicPlayerState>(
              buildWhen: (previous, current) => previous.song != current.song,
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 50,
                        width: 50,
                        color: Colors.grey.shade800,
                        child:
                            const Icon(Icons.music_note, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.song?.name ?? "No Song Selected",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    MiniMizedControlButton(
                      player: state.audioPlayer,
                      song: state.song ?? SongsModel(),
                    ),
                    BlocBuilder<MusicBloc, MusicPlayerState>(
                      builder: (context, state) {
                        return IconButton(
                          icon: const Icon(Icons.arrow_drop_up,
                                  color: Colors.white),
                          onPressed: () {
                            context.read<MusicBloc>().add(ExpandEvent());
                            NavigationService.expandMusicScreen(context);
                          },
                        );
                      },
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
