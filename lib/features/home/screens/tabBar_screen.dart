import 'package:flutter/material.dart';
import 'package:media_flow/features/DocumentViewer/Screen/document_viewer.dart';
import 'package:media_flow/features/Settings/Screen/settings_screen.dart';
import 'package:media_flow/features/home/screens/home_screen.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key, this.title});
  final String? title;

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomeScreen(title: "Home"),
          DocumentViewerScreen(),
          const SettingsPage(title: 'Settings'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: 'Documents',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
