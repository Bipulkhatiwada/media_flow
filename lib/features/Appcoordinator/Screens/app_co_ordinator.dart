import 'package:flutter/material.dart';
import 'package:media_flow/Data/SecuredStorage/secure_storage.dart';
import 'package:media_flow/Models/enum/secure_torage_keys.dart';
import 'package:media_flow/features/Music/Presentation/pages/tabBar_screen.dart';
import 'package:media_flow/features/auth/screens/login_screen.dart';

class AppCoordinator extends StatelessWidget {
  const AppCoordinator({super.key});

  Future<bool> _checkIfRegistered() async {
    final passKey = await SecureStorage().readSecureData(SecureStorageKey.passKey);
    return passKey != null && passKey.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkIfRegistered(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ); 
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error ?? 'Unknown error'}')),
          ); 
        }

        final isRegistered = snapshot.data ?? false;

        if (isRegistered) {
          return const TabBarScreen(); 
        } else {
          return const LoginScreen(title: ""); 
        }
      },
    );
  }
}