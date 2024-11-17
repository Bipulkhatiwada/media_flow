import 'package:go_router/go_router.dart';
import 'package:media_flow/config/Router/route_paths.dart';
import 'package:media_flow/features/Music/screens/music_player_screen.dart';
import 'package:media_flow/features/Music/screens/tabBar_screen.dart';
import '../../../config/router/route_names.dart';

class MusicScreenRoute {
  static List<RouteBase> routes = [
    GoRoute(
      path: RoutePaths.home,
      name: RouteNames.home,
      builder: (context, state) => const MusicPlayerScreen(title: "Music"),
    ),
    GoRoute(
      path: "/tabBar",
      name: "/tab",
      builder: (context, state) => const TabBarScreen(),
    ),
  ];
}