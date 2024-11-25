import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:media_flow/features/Music/Data/models/songs_model.dart';
import 'package:media_flow/features/Music/Domain/usecases/get_device_songs.dart';
import 'package:media_flow/features/Music/Presentation/bloc/MusicBloc/remote/musicPlayer_bloc.dart';
import 'package:media_flow/bloc/VideoPlayerBloc/video_player_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'config/router/app_router.dart';
import 'core/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await initializeDependencies();  

  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  Hive.registerAdapter(SongsModelAdapter());

  await Hive.openBox<SongsModel>('songs');
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}
extension on Future<Directory> {
  String? get path => null;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize:  Size(MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => MusicBloc(sl(), sl())),
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
        ));
  }
}
