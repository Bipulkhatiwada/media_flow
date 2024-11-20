import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_flow/Widgets/audio_file_list.dart';
import 'package:media_flow/Widgets/dynamic_audio_folder.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_bloc.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_event.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_state.dart';

class NestedTabBar extends StatefulWidget {
  const NestedTabBar(this.outerTab, {super.key});

  final String outerTab;

  @override
  State<NestedTabBar> createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    context.read<MusicBloc>().add(FetchSongEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(
                text: 'Songs',
              ),
              Tab(
                text: 'Playlists',
              ),
              Tab(
                text: 'albums',
              ),
              Tab(
                text: 'artists',
              ),
              Tab(
                text: 'Genres(',
              ),
            ],
          ),
        ),
        BlocBuilder<MusicBloc, MusicPlayerState>(
          builder: (context, state) {
            return Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const AudioFileList(),
                  DynamicAudioFolderView(
                    playlists: state.playLists ?? [],
                  ),
                  DynamicAudioFolderView(
                    albums: state.albumList ?? [],
                  ),
                  DynamicAudioFolderView(
                    artists: state.artistList ?? [],
                  ),
                  DynamicAudioFolderView(
                    genres: state.genreList ?? [],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
