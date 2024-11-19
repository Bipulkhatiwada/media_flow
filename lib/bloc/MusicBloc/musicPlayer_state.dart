import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_flow/Models/songs_model.dart';

class MusicPlayerState extends Equatable {
  final SongsModel? song;
  final List<SongsModel>? songList;
  final List<SongsModel>? filteredFileList;
  final bool? isSearching;
  final AudioPlayer audioPlayer;

  MusicPlayerState({
    this.song,
    this.songList,
    this.filteredFileList,
    this.isSearching,
    AudioPlayer? audioPlayer,  
  }) : audioPlayer = audioPlayer ?? AudioPlayer(); 

  MusicPlayerState copyWith({
    SongsModel? song,
    List<SongsModel>? songList,
    List<SongsModel>? filteredFileList,
    bool? isSearching,
  }) {
    return MusicPlayerState(
      song: song ?? this.song,
      songList: songList ?? this.songList,
      filteredFileList: filteredFileList ?? this.filteredFileList,
      isSearching: isSearching ?? this.isSearching,
      audioPlayer: audioPlayer, 
    );
  }

  @override
  List<Object?> get props => [song, songList, filteredFileList, isSearching, audioPlayer];
}