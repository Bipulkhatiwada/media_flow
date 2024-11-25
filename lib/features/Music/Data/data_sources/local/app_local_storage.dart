import 'package:hive/hive.dart';
import 'package:media_flow/features/Music/Data/models/songs_model.dart';

class AppLocalStorage {
  Future<List<SongsModel>> getPlayListData() async {
    final box = Hive.box<SongsModel>('songs');
    final songs = box.values.cast<SongsModel>().toList(); 
    return songs;
  }

  Future<List<SongsModel>> deletePlaylistSongs() async {
    final box = Hive.box<SongsModel>('songs');
    box.clear();
    final songs = box.values.cast<SongsModel>().toList();
    return songs;
  }
}
