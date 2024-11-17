import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:media_flow/Models/songs_model.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_bloc.dart';
import 'package:media_flow/bloc/VideoPlayerBloc/video_player_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'config/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  Hive.registerAdapter(SongsModelAdapter());

  await Hive.openBox<SongsModel>('songs');
  runApp(const MyApp());
}

extension on Future<Directory> {
  String? get path => null;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MusicBloc()),
        BlocProvider(create: (context) => VideoPlayerBloc())
      ],
      child: MaterialApp.router(
        title: 'Media Flow',
        theme: ThemeData(
          primarySwatch: Colors.green,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
          ),
        ),
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
