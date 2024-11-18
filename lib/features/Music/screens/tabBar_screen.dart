import 'package:flutter/material.dart';
import 'package:media_flow/features/DocumentViewer/Screen/document_viewer.dart';
import 'package:media_flow/features/Settings/Screen/settings_screen.dart';
import 'package:media_flow/features/Music/screens/music_player_screen.dart';
import 'package:media_flow/features/Videos/Screens/videos_list_screen.dart';

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
      backgroundColor: Colors.black, 
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          MusicPlayerScreen(title: "My Music"),
          DocumentViewerScreen(),
          VideoListScreen(),
          SettingsPage(title: 'Settings'),
        ],
      ),
       bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF1B1B1B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 30),
              activeIcon: Icon(Icons.home, size: 30, color: Colors.green),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.file_present_outlined, size: 30),
              activeIcon: Icon(Icons.file_present, size: 30, color: Colors.green),
              label: 'Documents',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library_outlined, size: 30),
              activeIcon: Icon(Icons.video_library, size: 30, color: Colors.green),
              label: 'Videos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined, size: 30),
              activeIcon: Icon(Icons.settings, size: 30, color: Colors.green),
              label: 'Settings',
            ),
          ],
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
