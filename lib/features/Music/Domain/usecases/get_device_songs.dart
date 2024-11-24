import 'package:media_flow/features/Music/Data/models/songs_model.dart';
import 'package:media_flow/core/useCases/useCase.dart';
import 'package:media_flow/features/Music/Domain/repository/songs_repository.dart';

class NoParams {}

class GetDeviceSongsUseCases implements UseCase<List<SongsModel>, NoParams> {
  final SongsRepository _songsRepository;

  GetDeviceSongsUseCases(this._songsRepository);

  @override
  Future<List<SongsModel>> call({NoParams? params}) {
    return _songsRepository.getDeviceSongs();
  }
}