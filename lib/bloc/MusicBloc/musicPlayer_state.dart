import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_flow/Models/songs_model.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';

class MusicPlayerState extends Equatable {
  final SongsModel? song;
  final List<SongsModel>? songList;
  final List<SongsModel>? filteredFileList;
  final AudioPlayer audioPlayer;
  final bool? isShuffledOn;

  final List<AlbumModel>? albumList;
  final List<ArtistModel>? artistList;
  final List<PlaylistModel>? playLists;
  final List<GenreModel>? genreList;

  final  bool? isExpanded;

  MusicPlayerState({
    this.song,
    this.songList,
    this.albumList,
    this.artistList,
    this.genreList,
    this.playLists,
    this.filteredFileList,
    this.isExpanded,
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
    List<AlbumModel>? albumList,
    List<ArtistModel>? artistList,
    List<PlaylistModel>? playLists,
    List<GenreModel>? genreList,
    bool? isExpanded
  }) {
    return MusicPlayerState(
        song: song ?? this.song,
        songList: songList ?? this.songList,
        filteredFileList: filteredFileList ?? this.filteredFileList,
        audioPlayer: audioPlayer ?? this.audioPlayer,
        isShuffledOn: isShuffledOn ?? this.isShuffledOn,
        albumList: albumList ?? this.albumList,
        artistList: artistList ?? this.artistList,
        genreList: genreList ?? this.genreList,
        playLists: playLists ?? this.playLists,
        isExpanded:  isExpanded ?? this.isExpanded,
        );
  }

  @override
  List<Object?> get props =>
      [song, songList, filteredFileList, audioPlayer, isShuffledOn, albumList, artistList, playLists, genreList, isExpanded ];
}
