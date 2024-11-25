
import 'package:media_flow/features/Music/Data/models/songs_model.dart';

abstract class SongsRepository {
  // API Methods
  Future<List<SongsModel>> getDeviceSongs();
  Future<List<SongsModel>> getPlaylistSongs();
  Future<List<SongsModel>> deletePlaylistSongs();
  Future<List<SongsModel>> saveSongs(List<SongsModel> songs);
}
