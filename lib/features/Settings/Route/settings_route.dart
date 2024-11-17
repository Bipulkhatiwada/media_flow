import 'package:go_router/go_router.dart';
import 'package:media_flow/config/Router/route_paths.dart';
import 'package:media_flow/features/Music/screens/music_player_screen.dart';
import '../../../config/router/route_names.dart';

class SettingsRoute {
  static List<RouteBase> routes = [
    GoRoute(
      path: RoutePaths.profile,
      name: RouteNames.settings,
      builder: (context, state) => const MusicPlayerScreen(title: "Home"),
    ),
  ];
}