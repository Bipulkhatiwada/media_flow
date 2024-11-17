import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:media_flow/Models/video_model.dart';
import 'package:permission_handler/permission_handler.dart';

part 'video_player_event.dart';
part 'video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  VideoPlayerBloc() : super(VideoPlayerState()) {
    on<FetchVideoEvent>(_fetchVideo);
    on<SelectVideoEvent>(_selectVideo);
  }
   Future<void> _fetchVideo(FetchVideoEvent event, Emitter<VideoPlayerState> emit) async {
    bool permissionStatus = await requestPermissionsAndFetchFiles();
    var rootDirectory = Directory('/storage/emulated/0/MusicVideo');
    List<File> musicList = await getFiles(rootDirectory);

    if (permissionStatus) {
      var audioFiles = musicList.map((file) {
        return VideoModel(
          name: file.path.split('/').last,
          path: file.path,
          videoFile: file
        );
      }).toList();

      audioFiles.sort((a, b) =>
          (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase()));

      emit(state.copyWith(
        videoList: audioFiles.toList(),
      ));
    } else {
      debugPrint("Permission denied");
    }
  }

  void _selectVideo(SelectVideoEvent event, Emitter<VideoPlayerState> emit) {
    emit(state.copyWith(
        video: event.video));
  }
  Future<List<File>> getFiles(Directory rootDirectory) async {
    List<File> musicList = [];

    try {
      var files = rootDirectory.listSync(recursive: true);

      for (var file in files) {
        try {
          if (file is File && file.path.endsWith('.mp4')) {
            musicList.add(file);
          } else if (file is Directory) {
            musicList.addAll(await getFiles(file));
          }
        } catch (e) {
          debugPrint('Access denied: ${file.path}');
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return musicList;
  }
   Future<bool> requestPermissionsAndFetchFiles() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    } else {
      final permissionStatus = await Permission.manageExternalStorage.request();
      return permissionStatus.isGranted;
    }
  }
}


