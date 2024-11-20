import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_flow/Boxes/boxes.dart';
import 'package:media_flow/Models/songs_model.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_event.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_state.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class MusicBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  MusicBloc() : super(MusicPlayerState()) {
    on<SelectSongEvent>(_selectSong);
    on<SaveSongEvent>(_saveSongs);
    on<FetchSongEvent>(_fetchSongs);
    on<NextSongEvent>(_nextSongEvent);
    on<PrevSongEvent>(_previousSongEvent);
    on<StopSongEvent>(_stopSong);
    on<SearchFileEvent>(_filterSong);
    on<ClearFilterSongs>(_clearfilterSong);
    on<ShuffleMusicEvent>(_shuffleMusic);
  }

  // Method to select a song
  void _selectSong(
      SelectSongEvent event, Emitter<MusicPlayerState> emit) async {
    final updatedList = state.songList?.map((newSong) {
      return SongsModel(
        name: newSong.name,
        path: newSong.path,
        selected: newSong.name == event.song.name,
      );
    }).toList();
    emit(state.copyWith(
        songList: updatedList?.toList(),
        song: updatedList?.firstWhere(
          (song) => song.name == event.song.name,
        )));

    await state.audioPlayer
        .setAudioSource(AudioSource.uri(Uri.parse(state.song?.path ?? "")));
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

    final randomIndex = getRandomInt(0, songListLength - 1);
    final song = songList[randomIndex];
    emit(state.copyWith(
        song: song,
        isShuffledOn: event.toggleShuffle
            ? !(state.isShuffledOn ?? true)
            : (state.isShuffledOn ?? true)));
    add(SelectSongEvent(song: song));
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

  // Fetching all songs
  void _fetchSongs(FetchSongEvent event, Emitter<MusicPlayerState> emit) async {

    // bool permissionStatus = await requestPermissionsAndFetchFiles();
    // var rootDirectory = Directory('/storage/emulated/0/music');
    // List<File> musicList = await getFiles(rootDirectory);

    
  final OnAudioQuery audioQuery = OnAudioQuery();
  bool permissionStatus = await audioQuery.checkAndRequest();

  if (permissionStatus) {
    try {
      List<SongModel> musicList = await audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      List<AlbumModel> audioList = await audioQuery.queryAlbums();
      List<AlbumModel> albumList = await audioQuery.queryAlbums();
      List<ArtistModel> artistsList = await audioQuery.queryArtists();
      List<PlaylistModel> playlists = await audioQuery.queryPlaylists();
      List<GenreModel> genres = await audioQuery.queryGenres();
      
      debugPrint("###### audioList $audioList");
      debugPrint("###### albumList $albumList");
      debugPrint("###### artistsList $artistsList");
      debugPrint("###### playlists $playlists");
      debugPrint("###### genres $genres");

      var audioFiles = musicList.map((file) {
        return SongsModel(
          name: file.displayName,
          path: file.uri ?? '', // Add null safety
        );
      }).toList();

      audioFiles.sort((a, b) =>
          (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase()));

      emit(state.copyWith(songList: audioFiles));
    } catch (e) {
      debugPrint("Error fetching songs: $e");
     
    }
  } else {
    debugPrint("Permission denied");
  }
}

  void _stopSong(StopSongEvent event, Emitter<MusicPlayerState> emit) async {
    emit(state.copyWith(song: SongsModel()));
  }

  void _saveSongs(SaveSongEvent event, Emitter<MusicPlayerState> emit) {
    // Convert event songs to SongsModel objects
    var audioFiles = event.songs.map((file) {
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
        box.addAll(newFiles); // Add only new files
      }

      final songs = Boxes.getData().values.toList().cast<SongsModel>();
      emit(state.copyWith(songList: songs));

      if (duplicateFiles.isNotEmpty) {
        debugPrint(
            'Error: Duplicate files detected: ${duplicateFiles.map((e) => e.name).join(', ')}');
      }
    } catch (e) {
      debugPrint('Error saving songs: $e');
      emit(state.copyWith(songList: []));
    }
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
