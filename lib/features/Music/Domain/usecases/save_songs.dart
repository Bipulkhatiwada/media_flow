import 'package:media_flow/core/useCases/useCase.dart';
import 'package:media_flow/features/Music/Data/models/songs_model.dart';
import 'package:media_flow/features/Music/Domain/repository/songs_repository.dart';

class SaveSongsUseCases implements UseCase<List<SongsModel>, List<SongsModel>> {
  final SongsRepository _songsRepository;

  SaveSongsUseCases(this._songsRepository);

  @override
  Future<List<SongsModel>> call({List<SongsModel>? params}) {
    return _songsRepository.saveSongs(params!);
  }
}
