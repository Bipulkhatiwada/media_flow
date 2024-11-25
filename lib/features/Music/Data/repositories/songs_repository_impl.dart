import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:media_flow/Boxes/boxes.dart';
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
  
  @override
  Future<List<SongsModel>> saveSongs(List<SongsModel> songs) async {
  var audioFiles = songs.map((file) {
    return SongsModel(
      name: file.name,
      path: file.path ?? '',
    );
  }).toList();

  final box = Hive.box<SongsModel>('songs');
  final existingSongs = box.values.toList().cast<SongsModel>();

  // Filter out songs that are already in the box
  var duplicateFiles = <SongsModel>[];
  var newFiles = <SongsModel>[];

  for (var file in audioFiles) {
    bool isDuplicate = existingSongs
        .any((song) => song.name == file.name && song.path == file.path);
    if (isDuplicate) {
      duplicateFiles.add(file);
    } else {
      newFiles.add(file);
    }
  }

  try {
    if (newFiles.isNotEmpty) {
      await box.addAll(newFiles); // Await the async Hive operation
    }
    final songs = box.values.toList().cast<SongsModel>();
    return songs;
  } catch (e) {
    debugPrint('Error saving songs: $e');
    return [];
  }
}

}
