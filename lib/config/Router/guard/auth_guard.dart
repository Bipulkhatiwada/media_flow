import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_flow/Data/SecuredStorage/secure_storage.dart';
import 'package:media_flow/Models/enum/secure_torage_keys.dart';
import '../route_paths.dart';

class AuthGuard {
  static Future<String?> guard(
      BuildContext context, GoRouterState state) async {
    // Read passKey from secure storage
    final passKey =
        await SecureStorage().readSecureData(SecureStorageKey.passKey);

    // Determine if the user is registered
    final bool isRegistered = passKey != null && passKey.isNotEmpty;

    // Check if the current route is an authentication route
    final bool isAuthRoute = state.uri.toString().startsWith(RoutePaths.signUpEmail) ||  state.uri.toString().startsWith(RoutePaths.createPassword);

    // Redirect to login if not registered and not on an auth route
    if (!isRegistered) {
      if (!isAuthRoute) {
      return RoutePaths.login;
      }
    } else if (!isAuthRoute){
       return RoutePaths.tab;
    }

    // If registered, do not redirect to login
    return null;
  }
}

