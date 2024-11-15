import 'package:go_router/go_router.dart';
import 'package:media_flow/config/Router/route_paths.dart';
import 'package:media_flow/features/home/screens/home_screen.dart';
import 'package:media_flow/features/home/screens/tabBar_screen.dart';
import '../../../config/router/route_names.dart';

class HomeRoutes {
  static List<RouteBase> routes = [
    GoRoute(
      path: RoutePaths.home,
      name: RouteNames.home,
      builder: (context, state) => const HomeScreen(title: "Home"),
    ),
    GoRoute(
      path: "/tabBar",
      name: "/tab",
      builder: (context, state) => const TabBarScreen(),
    ),
  ];
}