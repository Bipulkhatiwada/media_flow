import 'package:get_it/get_it.dart';
import 'package:media_flow/features/Music/Data/data_sources/local/app_local_storage.dart';
import 'package:media_flow/features/Music/Data/repositories/songs_repository_impl.dart';
import 'package:media_flow/features/Music/Domain/repository/songs_repository.dart';
import 'package:media_flow/features/Music/Domain/usecases/delete_playlist_songs.dart';
import 'package:media_flow/features/Music/Domain/usecases/get_device_songs.dart';
import 'package:media_flow/features/Music/Domain/usecases/get_playlist_songs.dart';
import 'package:media_flow/features/Music/Domain/usecases/save_songs.dart';
import 'package:media_flow/features/Music/Presentation/bloc/MusicBloc/remote/musicPlayer_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Repository
  sl.registerSingleton<AppLocalStorage>(AppLocalStorage());
  sl.registerLazySingleton<SongsRepository>(() => SongsRepositoryImpl(sl()));


  // Use cases
  sl.registerLazySingleton(() => GetDeviceSongsUseCases(sl()));
  sl.registerLazySingleton(() => GetPlaylistSongsUseCases(sl()));
  sl.registerLazySingleton(() => SaveSongsUseCases(sl()));
  sl.registerLazySingleton(() => DeleteDeviceSongsUseCases(sl()));

  // Blocs
  sl.registerFactory(() => MusicBloc(sl(), sl(), sl(), sl()));
}
