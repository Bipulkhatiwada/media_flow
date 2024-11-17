// Music Player State
import 'package:equatable/equatable.dart';
import 'package:media_flow/Models/songs_model.dart';

class MusicPlayerState extends Equatable {
  final SongsModel? song;
  final List<SongsModel>? songList;

  const MusicPlayerState({
    this.song,
    this.songList,
  });

  MusicPlayerState copyWith({
    SongsModel? song,
    List<SongsModel>? songList,
  }) {
    return MusicPlayerState(
      song: song ?? this.song,
      songList: songList ?? this.songList,
    );
  }

  @override
  List<Object?> get props => [song, songList];
}