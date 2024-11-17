import 'package:go_router/go_router.dart';
import 'package:media_flow/config/Router/route_paths.dart';
import 'package:media_flow/features/Appcoordinator/Screens/app_co_ordinator.dart';
import 'package:media_flow/features/auth/screens/create_password_screen.dart';
import 'package:media_flow/features/auth/screens/signUp_email_screen.dart';
import '../../../config/router/route_names.dart';
import '../screens/login_screen.dart';

class AuthRoutes {
  static List<RouteBase> routes = [
    GoRoute(
      path: RoutePaths.login,
      name: RouteNames.login,
      builder: (context, state) => const LoginScreen(title: 'Login'),
    ),
    GoRoute(
      path: RoutePaths.signUpEmail,
      name: RouteNames.signUpEmail,
      builder: (context, state) {
        return const SignUpEmailScreen(title: 'Sign Up');
      },
    ),
    GoRoute(
      path: RoutePaths.createPassword,
      name: RouteNames.createPassword,
      builder: (context, state) => const CreatePasswordScreen(title: "Create Password"),
    ),
    GoRoute(
      path: RoutePaths.appcoordinator,
      builder: (context, state) => const AppCoordinator(),
    ),
  ];
}