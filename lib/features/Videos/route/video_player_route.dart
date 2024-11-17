import 'dart:io';

import 'package:go_router/go_router.dart';
import 'package:media_flow/config/Router/route_paths.dart';
import 'package:media_flow/features/Videos/Screens/video_player_Screen.dart';

class VideoPlayerRoute {
  static List<RouteBase> routes = [
   GoRoute(
  path: RoutePaths.videoPlayer,
  builder: (context, state) {
    final videoFile = state.extra as File?; // Retrieve the passed file
    return VideoPlayerScreen(title: "Video Player", videoFile: videoFile!);
  },
),
  ];
}