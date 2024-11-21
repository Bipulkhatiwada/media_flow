import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';

class DynamicAudioFolderView extends StatelessWidget {
  final List<AlbumModel>? albums;
  final List<ArtistModel>? artists;
  final List<PlaylistModel>? playlists;
  final List<GenreModel>? genres;
  final Function(dynamic item, String type)? onItemTap;

  const DynamicAudioFolderView({
    super.key,
    this.albums,
    this.artists,
    this.playlists,
    this.genres,
    this.onItemTap,
  });

  bool get hasNoContent =>
      (albums?.isEmpty ?? true) &&
      (artists?.isEmpty ?? true) &&
      (playlists?.isEmpty ?? true) &&
      (genres?.isEmpty ?? true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.withOpacity(0.2),
              Colors.black,
            ],
          ),
        ),
        child: hasNoContent
            ? _buildEmptyState()
            : CustomScrollView(
                slivers: [
                  if (albums?.isNotEmpty ?? false)
                    _buildSection(
                      title: "Albums",
                      items: albums!,
                      icon: Icons.album,
                      type: "album",
                    ),
                  if (artists?.isNotEmpty ?? false)
                    _buildSection(
                      title: "Artists",
                      items: artists!,
                      icon: Icons.person,
                      type: "artist",
                    ),
                  if (playlists?.isNotEmpty ?? false)
                    _buildSection(
                      title: "Playlists",
                      items: playlists!,
                      icon: Icons.playlist_play,
                      type: "playlist",
                    ),
                  if (genres?.isNotEmpty ?? false)
                    _buildSection(
                      title: "Genres",
                      items: genres!,
                      icon: Icons.category,
                      type: "genre",
                    ),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1DB954).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.music_note,
              color: const Color(0xFF1DB954),
              size: 64,
            ),
          ),
           SizedBox(height: 24.h),
           Text(
            "No Music Found",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "Add some music to your device\nto see it here",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List items,
    required IconData icon,
    required String type,
  }) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF1DB954),
                  size: 24,
                ),
                 SizedBox(width: 8.w),
                Text(
                  title,
                  style:  TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding:  EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: items.length,
            itemBuilder: (context, index) =>
                _buildFolderItem(items[index], type),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderItem(dynamic item, String type) {
    String title = '';
    String subtitle = '';

    switch (type) {
      case "album":
        AlbumModel album = item as AlbumModel;
        title = album.album;
        subtitle = "${album.numOfSongs} songs";
        break;
      case "artist":
        ArtistModel artist = item as ArtistModel;
        title = artist.artist;
        subtitle = "${artist.numberOfTracks} tracks";
        break;
      case "playlist":
        PlaylistModel playlist = item as PlaylistModel;
        title = playlist.playlist;
        subtitle = "${playlist.numOfSongs} songs";
        break;
      case "genre":
        GenreModel genre = item as GenreModel;
        title = genre.genre;
        subtitle = "${genre.numOfSongs} songs";
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF282828),
            Color(0xFF1E1E1E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Material(
           
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onItemTap?.call(item, type),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1DB954).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconForType(type),
                      color: const Color(0xFF1DB954),
                      size: 24,
                    ),
                  ),
                   SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                         SizedBox(height: 4.h),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case "album":
        return Icons.album;
      case "artist":
        return Icons.person;
      case "playlist":
        return Icons.playlist_play;
      case "genre":
        return Icons.category;
      default:
        return Icons.folder;
    }
  }
}