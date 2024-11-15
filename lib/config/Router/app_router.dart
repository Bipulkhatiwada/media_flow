import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_flow/config/Router/guard/auth_guard.dart';
import 'package:media_flow/features/Settings/Route/settings_route.dart';
import 'package:media_flow/features/home/route/home_route.dart';
import 'route_paths.dart';
import '../../features/auth/routes/auth_routes.dart';

class AppRouter {
  static final navigationKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigationKey,
    initialLocation: RoutePaths.login,
    debugLogDiagnostics: true,
    redirect: AuthGuard.guard,
    routes: [
          ...AuthRoutes.routes,
          ...HomeRoutes.routes,
          ...SettingsRoute.routes
    ],
    errorBuilder: (context, state) {
      return ErrorScreen(error: state.error);
    },
  );
}

class ErrorScreen extends StatelessWidget {
  final Exception? error;
  
  const ErrorScreen({Key? key, this.error}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Error: ${error?.toString() ?? 'Page not found'}'),
      ),
    );
  }
}

