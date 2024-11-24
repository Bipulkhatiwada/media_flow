
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_flow/Models/video_model.dart';
import 'package:media_flow/features/Music/Presentation/bloc/MusicBloc/remote/musicPlayer_bloc.dart';
import 'package:media_flow/features/Music/Presentation/bloc/MusicBloc/remote/musicPlayer_event.dart';
import 'package:media_flow/bloc/VideoPlayerBloc/video_player_bloc.dart';
import 'package:media_flow/core/Navigation/navigation_service.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  _VideoListScreen createState() => _VideoListScreen();
}

class _VideoListScreen extends State<VideoListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<VideoPlayerBloc>();
    bloc.add(FetchVideoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Videos'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF1B1B1B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
          builder: (context, state) {
            if (state.videoList == null || state.videoList!.isEmpty) {
              return _buildEmptyState();
            } else {
              return _buildVideoList(context, state.videoList!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.music_note_rounded,
            color: Colors.greenAccent,
            size: 100,
          ),
          SizedBox(height: 20.h),
           Text(
            'No videos available',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 10.h),
           Text(
            'Add some videos to start enjoying your collection!',
            style: TextStyle(fontSize: 16.sp, color: Colors.white54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVideoList(BuildContext context,List<VideoModel> videoFiles) {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding:  EdgeInsets.symmetric(vertical: 16.h),
      itemCount: videoFiles.length,
      itemBuilder: (context, index) {
        return _buildVideoCard(context, videoFiles[index]);
      },
    );
  }

  Widget _buildVideoCard(BuildContext context,VideoModel video) {
    return GestureDetector(
      onTap: () {
        context.read<MusicBloc>().add(StopSongEvent());
        NavigationService.navigateToVideoPlayer(context, videoFile: video.videoFile!);
        },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF81C784)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:  BorderRadius.vertical(
                        top: Radius.circular(12.r),
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          video.path ?? 'assets/images/video_placeholder.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.black12,
                              child: const Center(
                                child: Icon(
                                  Icons.video_library,
                                  color: Colors.white54,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Play Button Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius:  BorderRadius.vertical(
                            top: Radius.circular(12.r),
                          ),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Color(0xFF2E7D32),
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Duration Badge
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child:  Text(
                          "00:00",
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      
                // Video Info Section
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video.name ?? 'Unknown Video',
                              style:  TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // More Options Button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20.r),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      
                // Progress Bar
                Container(
                  height: 3,
                  decoration:  BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.r),
                      bottomRight: Radius.circular(12.r),
                    ),
                  ),
                  child: FractionallySizedBox(
                    child: Container(
                      decoration:  BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}