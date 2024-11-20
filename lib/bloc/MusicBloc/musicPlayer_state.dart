import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_flow/Models/songs_model.dart';

class MusicPlayerState extends Equatable {
  final SongsModel? song;
  final List<SongsModel>? songList;
  final List<SongsModel>? filteredFileList;
  final AudioPlayer audioPlayer;
  final bool? isShuffledOn;

  MusicPlayerState({
    this.song,
    this.songList,
    this.filteredFileList,
    AudioPlayer? audioPlayer,
    this.isShuffledOn = false,

  }) : audioPlayer = audioPlayer ?? AudioPlayer();

  MusicPlayerState copyWith({
    SongsModel? song,
    List<SongsModel>? songList,
    List<SongsModel>? filteredFileList,
    bool? isSearching,
    AudioPlayer? audioPlayer,
    bool? isShuffledOn,
  }) {
    return MusicPlayerState(
      song: song ?? this.song,
      songList: songList ?? this.songList,
      filteredFileList: filteredFileList ?? this.filteredFileList,
      audioPlayer: audioPlayer ?? this.audioPlayer,
      isShuffledOn: isShuffledOn ?? this.isShuffledOn
    );
  }

  @override
  List<Object?> get props => [song, songList, filteredFileList, audioPlayer, isShuffledOn];
}