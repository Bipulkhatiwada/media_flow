part of 'video_player_bloc.dart';

class VideoPlayerState extends Equatable {
  final VideoModel? video;
  final List<VideoModel>? videoList;
  final File? videoFile;

  VideoPlayerState({
    this.video,
    this.videoList,
    this.videoFile
  });

  VideoPlayerState copyWith({
    VideoModel? video,
    List<VideoModel>? videoList,
    File? videoFile
  }) {
    return VideoPlayerState(
      video: video ?? this.video,
      videoList: videoList ?? this.videoList,
      videoFile: videoFile ?? this.videoFile
    );
  }

  @override
  List<Object?> get props => [video, videoList, videoFile];
}
