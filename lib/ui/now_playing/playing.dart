import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/model/song.dart';
import 'audio_player_manager.dart';

class NowPlaying extends StatelessWidget {
  final List<Song> songs;
  final Song playingSong;

  const NowPlaying({super.key, required this.songs, required this.playingSong});

  @override
  Widget build(BuildContext context) {
    return NowPlayingPage(songs: songs, playingSong: playingSong);
  }
}

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage(
      {super.key, required this.songs, required this.playingSong});

  final List<Song> songs;
  final Song playingSong;

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AudioPlayerManager _audioPlayerManager;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 12000));
    _audioPlayerManager =
        AudioPlayerManager(songUrl: widget.playingSong.source);
    _audioPlayerManager.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 64;
    final radius = (screenWidth - delta) / 2;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Now Playing'),
        trailing: IconButton(
            onPressed: () {}, icon: const Icon(Icons.more_horiz_sharp)),
      ),
      child: Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(widget.playingSong.title),
          const SizedBox(
            height: 16,
          ),
          const Text("_ ___ __"),
          const SizedBox(
            height: 48,
          ),
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/ITunes.jpg',
                  image: widget.playingSong.image,
                  width: screenWidth - delta,
                  height: screenWidth - delta,
                  imageErrorBuilder: (context, error, strackTrace) {
                    return Image.asset(
                      'assets/images/Itunes.jpg',
                      width: 48,
                      height: 48,
                    );
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 64, bottom: 16),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.share_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  Column(
                    children: [
                      Text(widget.playingSong.title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color)),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        widget.playingSong.artist,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color),
                      )
                    ],
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite_outline,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                ],
              ),
            ),
          ),
          Padding(
              padding:
                  EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 16),
              child: _progressBar())
        ])),
      ),
    );
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
        stream: _audioPlayerManager.durationState,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          final progress = durationState?.progress ?? Duration.zero;
          final buffer = durationState?.buffer ?? Duration.zero;
          final total = durationState?.total ?? Duration.zero;
          return ProgressBar(progress: progress, total: total);
        });
  }
}
