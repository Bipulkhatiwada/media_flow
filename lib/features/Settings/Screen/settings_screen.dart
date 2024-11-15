import 'package:flutter/material.dart';
import 'package:media_flow/Data/SecuredStorage/secure_storage.dart';
import 'package:media_flow/Models/enum/secure_torage_keys.dart';
import 'package:media_flow/Widgets/alert_dialog.dart';
import 'package:media_flow/core/Navigation/navigation_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SecureStorage _secureStorage = SecureStorage();

  void _logout() {
    showAlertDialog(
      title: "Alert",
      description: "Are you sure you want to logout?",
      onConfirm: () {
        _secureStorage.deleteData(SecureStorageKey.passKey);
        _secureStorage.deleteData(SecureStorageKey.email);
        NavigationService.navigateToLogin(context);
      }, context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: TextButton(
          onPressed: _logout,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16.0),
          ),
          child: const Text("Log Out"),
        ),
      ),
    );
  }
}
