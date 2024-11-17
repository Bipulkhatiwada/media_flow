import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:media_flow/Models/songs_model.dart';

class MusicPlayerEvent extends Equatable {
  const MusicPlayerEvent();

  @override
  List<Object?> get props => [];
}

class SelectSongEvent extends MusicPlayerEvent {
  final SongsModel song;

  const SelectSongEvent({required this.song});

  @override
  List<Object> get props => [song];
}

class SaveSongEvent extends MusicPlayerEvent {
  final List<PlatformFile> songs;

  const SaveSongEvent({required this.songs});

  @override
  List<Object> get props => [songs];
}

class FetchSongEvent extends MusicPlayerEvent {}

class StopSongEvent extends MusicPlayerEvent {}


class NextSongEvent extends MusicPlayerEvent {
   final SongsModel song;

  const NextSongEvent({required this.song});

  @override
  List<Object> get props => [song];
}

class PrevSongEvent extends MusicPlayerEvent {
     final SongsModel song;

  const PrevSongEvent({required this.song});

  @override
  List<Object> get props => [song];

}