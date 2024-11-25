import 'package:get_it/get_it.dart';
import 'package:media_flow/features/Music/Data/repositories/songs_repository_impl.dart';
import 'package:media_flow/features/Music/Domain/repository/songs_repository.dart';
import 'package:media_flow/features/Music/Domain/usecases/get_device_songs.dart';
import 'package:media_flow/features/Music/Domain/usecases/save_songs.dart';
import 'package:media_flow/features/Music/Presentation/bloc/MusicBloc/remote/musicPlayer_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Repository
  sl.registerLazySingleton<SongsRepository>(() => SongsRepositoryImpl());

  // Use cases
  sl.registerLazySingleton(() => GetDeviceSongsUseCases(sl()));
  sl.registerLazySingleton(() => SaveSongsUseCases(sl()));

  // Blocs
  sl.registerFactory(() => MusicBloc(sl(), sl()));
}
