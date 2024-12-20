import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_flow/config/Router/route_paths.dart';

class NavigationService {
  static void navigateToHome(BuildContext context) {
    context.go(RoutePaths.home);
  }

  static void navigateToTabBar(BuildContext context) {
    context.go(RoutePaths.tab);
  }

  static void navigateToSearchBar(BuildContext context) {
    context.pushNamed('searchScreen');
  }

  static void navigateToLogin(BuildContext context) {
    context.go(RoutePaths.login);
  }

  static void expandMusicScreen(BuildContext context) {
    context.push(RoutePaths.musicControls);
  }
  static void navigateToSignUp(BuildContext context, {String? title}) {
    try {
      context.push(
        RoutePaths.signUpEmail,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigation error: $e')),
      );
    }
  }
 static void navigateToAppCoordinator(BuildContext context, {File? videoFile}) {
  try {
    context.push(
      RoutePaths.appcoordinator,
      extra: videoFile, 
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigation error: $e')),
    );
  }
}
  static void navigateToVideoPlayer(BuildContext context, {File? videoFile}) {
  try {
    context.push(
      RoutePaths.videoPlayer,
      extra: videoFile, 
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigation error: $e')),
    );
  }
}

  static void navigateToSetupPassword(BuildContext context) {
    try {
      context.push(
        RoutePaths.createPassword,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigation error: $e')),
      );
    }
  }

  static void pop(BuildContext context) {
    context.pop();
  }
}
