part of 'video_player_bloc.dart';

sealed class VideoPlayerEvent extends Equatable {
  const VideoPlayerEvent();

  @override
  List<Object> get props => [];
}


class SelectVideoEvent extends VideoPlayerEvent {
  final VideoModel video;

  const SelectVideoEvent({required this.video});

  @override
  List<Object> get props => [video];
}

class FetchVideoEvent extends VideoPlayerEvent {}
