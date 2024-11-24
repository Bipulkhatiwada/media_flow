import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_flow/Models/songs_model.dart';
import 'package:media_flow/Widgets/control_buttons.dart';
import 'package:media_flow/Widgets/seek_bar.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_event.dart';
import 'package:media_flow/core/Navigation/navigation_service.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
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

class _MusicPlayerControlsState extends State<MusicPlayerControls>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
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
            if (state.audioPlayer.playerState.playing) {
              _controller.repeat();
            } else {
              _controller.stop();
            }
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
                        // AnimatedBuilder(
                        //   animation: _animation,
                        //   builder: (context, child) {
                        //     return Transform.rotate(
                        //       angle: _animation.value,
                        //       child: Container(
                        //         width: 120.w,
                        //         height: 120.h,
                        //         decoration: BoxDecoration(
                        //           color:
                        //               const Color(0xFF1DB954).withOpacity(0.1),
                        //           shape: BoxShape.circle,
                        //         ),
                        //         // child: const Icon(
                        //         //   Icons.music_note,
                        //         //   color: Color(0xFF1DB954),
                        //         //   size: 64,
                        //         // ),

                        //          child: QueryArtworkWidget(
                        //           id: state.song?.songModel?.id ?? 0,
                        //          type: ArtworkType.AUDIO,
                        //          nullArtworkWidget: const Icon(
                        //           Icons.music_note,
                        //           color: Color(0xFF1DB954),
                        //           size: 64,
                        //         ),
                        //          ),
                        //       ),
                        //     );
                        //   },
                        // ),
                        QueryArtworkWidget(
                          id: state.song?.songModel?.id ?? 0,
                          type: ArtworkType.AUDIO,
                          artworkHeight: 200.h,
                          artworkWidth: 200.w,
                          artworkFit: BoxFit.cover,
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            color: Color(0xFF1DB954),
                            size: 64,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          state.song?.name ?? "Music not Found",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "unknown Artist",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16.sp,
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
                              duration:
                                  snapshot.data?.duration ?? Duration.zero,
                              position:
                                  snapshot.data?.position ?? Duration.zero,
                              bufferedPosition:
                                  snapshot.data?.bufferedPosition ??
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
    extends State<MiniMizedMusicPlayerControls> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 2 * pi, // Use pi from dart:math
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose(); // Important: dispose of the animation controller
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
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
              // Check player state and control animation accordingly
              debugPrint("##### rebuild music control #####");

              final audioPlayer = state.audioPlayer;
              final playerState = audioPlayer.playerState;
              final isPlaying = playerState.playing;

              if (isPlaying) {
                debugPrint('Player State: Playing minimized controller');
                debugPrint(
                    'Audio Player minimized State Details: ${playerState.toString()}');
                _controller.repeat();
              } else {
                debugPrint('Player State: Not Playing main controller');
                debugPrint(
                    'Audio Player minimized State Details: ${playerState.toString()}');
                _controller.stop();
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // QueryArtworkWidget(
                  //     id: state.song?.songModel?.id ?? 0,
                  //     type: ArtworkType.AUDIO,
                  //     nullArtworkWidget: Icon(
                  //       Icons.music_note,
                  //       color: state.song?.selected ?? false
                  //           ? Colors.white
                  //           : const Color(0xFF1DB954),
                  //       size: 16,
                  //     ))
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animation.value,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.r),
                          child: Container(
                              height: 50.h,
                              width: 50.w,
                              color: Colors.grey.shade800,
                              child:  Icon(
                                    Icons.music_note,
                                    color: state.song?.selected ?? false
                                        ? Colors.white
                                        : const Color(0xFF1DB954),
                                    size: 16,
                                  )
                                  ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.song?.name ?? "No Song Selected",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
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
    );
  }
}
