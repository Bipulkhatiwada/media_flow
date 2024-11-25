import 'package:media_flow/core/useCases/useCase.dart';
import 'package:media_flow/features/Music/Data/models/songs_model.dart';
import 'package:media_flow/features/Music/Domain/repository/songs_repository.dart';
import 'package:media_flow/features/Music/Domain/usecases/get_device_songs.dart';

class DeleteDeviceSongsUseCases implements UseCase<List<SongsModel>, NoParams> {
  final SongsRepository _songsRepository;

  DeleteDeviceSongsUseCases(this._songsRepository);

  @override
  Future<List<SongsModel>> call({NoParams? params}) {
    return _songsRepository.deletePlaylistSongs();
  }
}