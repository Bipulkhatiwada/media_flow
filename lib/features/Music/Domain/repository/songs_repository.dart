
import 'package:media_flow/features/Music/Data/models/songs_model.dart';

abstract class SongsRepository {
  // API Methods
  Future<List<SongsModel>> getDeviceSongs();
}
