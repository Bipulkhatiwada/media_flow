// Music Player State
import 'package:equatable/equatable.dart';
import 'package:media_flow/Models/songs_model.dart';

class MusicPlayerState extends Equatable {
  final SongsModel? song;
  final List<SongsModel>? songList;
  final List<SongsModel>? filteredFileList;
  final bool? isSearching;


  const MusicPlayerState({
    this.song,
    this.songList,
    this.filteredFileList,
    this.isSearching,
  });

  MusicPlayerState copyWith({
    SongsModel? song,
    List<SongsModel>? songList,
    List<SongsModel>? filteredFileList,
    bool isSearching = false,
  }) {
    return MusicPlayerState(
      song: song ?? this.song,
      songList: songList ?? this.songList,
      filteredFileList:  filteredFileList ?? this.filteredFileList,
      isSearching: isSearching
    );
  }

  @override
  List<Object?> get props => [song, songList, filteredFileList];
}