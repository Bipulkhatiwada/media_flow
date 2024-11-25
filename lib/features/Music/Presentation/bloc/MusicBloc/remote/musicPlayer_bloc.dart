import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:media_flow/features/Music/Data/models/songs_model.dart';
import 'package:media_flow/features/Music/Domain/usecases/get_device_songs.dart';
import 'package:media_flow/features/Music/Domain/usecases/save_songs.dart';
import 'package:media_flow/features/Music/Presentation/bloc/MusicBloc/remote/musicPlayer_event.dart';
import 'package:media_flow/features/Music/Presentation/bloc/MusicBloc/remote/musicPlayer_state.dart';
import 'package:permission_handler/permission_handler.dart';

class MusicBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  final GetDeviceSongsUseCases _getDeviceSongsUseCases;
  final SaveSongsUseCases _saveSongsUseCases;

  MusicBloc(this._getDeviceSongsUseCases, this._saveSongsUseCases)
      : super(MusicPlayerState()) {
    on<SelectSongEvent>(_selectSong);
    on<SaveSongEvent>(_saveSongs);
    on<FetchSongEvent>(_fetchSongs);
    on<NextSongEvent>(_nextSongEvent);
    on<PrevSongEvent>(_previousSongEvent);
    on<StopSongEvent>(_stopSong);
    on<SearchFileEvent>(_filterSong);
    on<ClearFilterSongs>(_clearfilterSong);
    on<ShuffleMusicEvent>(_shuffleMusic);
    on<ExpandEvent>(_expandMusicControls);
  }

// Fetching all songs
  void _fetchSongs(FetchSongEvent event, Emitter<MusicPlayerState> emit) async {
    final audioList = await _getDeviceSongsUseCases();
    if (audioList.isNotEmpty) {
      emit(state.copyWith(songList: audioList));
    }
  }

  void _saveSongs(SaveSongEvent event, Emitter<MusicPlayerState> emit) async {
    final audioList = await _saveSongsUseCases();
    if (audioList.isNotEmpty) {
      emit(state.copyWith(songList: audioList));
    }
  }

  // Method to select a song
  void _selectSong(
      SelectSongEvent event, Emitter<MusicPlayerState> emit) async {
    final updatedList = state.songList?.map((newSong) {
      return SongsModel(
          name: newSong.name,
          path: newSong.path,
          selected: newSong.name == event.song.name,
          songModel: newSong.songModel);
    }).toList();
    emit(state.copyWith(
        songList: updatedList?.toList(),
        song: updatedList?.firstWhere(
          (song) => song.name == event.song.name,
        )));

    await state.audioPlayer.setAudioSource(AudioSource.uri(
      Uri.parse(state.song?.path ?? ""),
      tag: MediaItem(
        id: '${state.songList.hashCode}',
        album: "<unknown>>",
        title: state.song?.name ?? "",
        artUri: Uri.parse('https://example.com/albumart.jpg'),
      ),
    ));
    state.audioPlayer.setAllowsExternalPlayback(true);
  }

  void _filterSong(SearchFileEvent event, Emitter<MusicPlayerState> emit) {
    final songList = state.songList ?? [];

    final filteredList = songList
        .where((song) =>
            song.name?.toLowerCase().contains(event.searchText.toLowerCase()) ??
            false)
        .toList();

    emit(state.copyWith(
        songList: state.songList,
        song: state.song,
        filteredFileList: filteredList,
        isSearching: true));
  }

  void _shuffleMusic(ShuffleMusicEvent event, Emitter<MusicPlayerState> emit) {
    final songList = state.songList;
    final songListLength = songList?.length ?? 0;

    if (songList == null || songList.isEmpty) {
      return;
    }
    if (event.toggleShuffle == false) {
      emit(state.copyWith(isShuffledOn: event.toggleShuffle));
    } else {
      final randomIndex = getRandomInt(0, songListLength - 1);
      final song = songList[randomIndex];
      emit(state.copyWith(song: song, isShuffledOn: event.toggleShuffle));
      add(SelectSongEvent(song: song));
    }
  }

  int getRandomInt(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  void _clearfilterSong(
      ClearFilterSongs event, Emitter<MusicPlayerState> emit) {
    emit(state.copyWith(filteredFileList: []));
  }

  // Method for selecting the next song
  void _nextSongEvent(NextSongEvent event, Emitter<MusicPlayerState> emit) {
    final songs = state.songList;
    final currentSong = state.song;

    if (currentSong == null) return;
    if (songs == null || songs.isEmpty) return;

    if (state.isShuffledOn ?? false) {
      add(const ShuffleMusicEvent(toggleShuffle: false));
    } else {
      final songIndex = songs.indexOf(currentSong);
      final previousSongIndex = (songIndex + 1 + songs.length) % songs.length;

      final song = songs[previousSongIndex];

      add(SelectSongEvent(song: song));
    }
  }

  // Method for selecting the previous song
  void _previousSongEvent(PrevSongEvent event, Emitter<MusicPlayerState> emit) {
    final songs = state.songList;
    final currentSong = state.song;

    if (currentSong == null) return;
    if (songs == null || songs.isEmpty) return;

    final songIndex = songs.indexOf(currentSong);
    final previousSongIndex = (songIndex - 1 + songs.length) % songs.length;

    final song = songs[previousSongIndex];

    add(SelectSongEvent(song: song));
  }

  void _stopSong(StopSongEvent event, Emitter<MusicPlayerState> emit) async {
    emit(state.copyWith(song: SongsModel()));
  }

  void _expandMusicControls(ExpandEvent event, Emitter<MusicPlayerState> emit) {
    emit(state.copyWith(isExpanded: !(state.isExpanded ?? false)));
  }

  Future<bool> requestPermissionsAndFetchFiles() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    } else {
      final permissionStatus = await Permission.manageExternalStorage.request();
      return permissionStatus.isGranted;
    }
  }

  Future<List<File>> getFiles(Directory rootDirectory) async {
    List<File> musicList = [];

    try {
      var files = rootDirectory.listSync(recursive: true);

      for (var file in files) {
        try {
          if (file is File && file.path.endsWith('.m4a')) {
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
}
