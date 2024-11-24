import 'package:flutter/material.dart';
import 'package:media_flow/features/Music/Data/models/songs_model.dart';
import 'package:media_flow/features/Music/Domain/repository/songs_repository.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';

class SongsRepositoryImpl implements SongsRepository {   
  @override
  Future<List<SongsModel>> getDeviceSongs() async {
    final OnAudioQuery audioQuery = OnAudioQuery();
    bool permissionStatus = await audioQuery.checkAndRequest();

    if (permissionStatus) {
      try {
        List<SongModel> musicList = await audioQuery.querySongs(
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        );

        var audioFiles = musicList.map((file) {
          return SongsModel(
            name: file.displayName,
            path: file.uri ?? '',
            songModel: file,
          );
        }).toList();

        // Sorting
        audioFiles.sort((a, b) => (a.name ?? '')
            .toLowerCase()
            .compareTo((b.name ?? '').toLowerCase()));

        return audioFiles;
      } catch (e) {
        debugPrint("Error fetching songs: $e");
        return []; // Return an empty list on error
      }
    } else {
      debugPrint("Permission denied");
      return []; // Return an empty list if permission is denied
    }
  }
}
