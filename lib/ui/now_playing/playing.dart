import 'dart:ffi';
import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/ui/now_playing/playing_favorite_feature.dart';
import 'package:music_app/ui/now_playing/playing_image_rotation.dart';
import 'package:music_app/ui/now_playing/playing_progressBar.dart';
import 'package:music_app/ui/now_playing/playing_share_feature.dart';
import 'package:music_app/ui/now_playing/playing_song_details.dart';
import 'package:music_app/ui/now_playing/playing_title.dart';

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
  late AnimationController _imageAnimationController;
  late AudioPlayerManager _audioPlayerManager;
  late int _selectedItemIndex;
  late Song _song;
  late double _currentAnimationPosition;
  late bool _isShuffle = false;
  late LoopMode _loopMode;

  @override
  void initState() {
    _song = widget.playingSong;
    _currentAnimationPosition = 0.0;
    _imageAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 12000));
    _audioPlayerManager = AudioPlayerManager();
    if (_audioPlayerManager.songUrl.compareTo(_song.source) != 0) {
      _audioPlayerManager.updateSongUrl(_song.source);
      _audioPlayerManager.prepare(isNewSong: true);
    } else {
      _audioPlayerManager.prepare(isNewSong: false);
    }

    _selectedItemIndex = widget.songs.indexOf(_song);
    _loopMode = LoopMode.off;
    super.initState();
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          PlayingTitle(
            title: _song.title,
          ),
          PlayingImageRotation(
            imageAnimationController: _imageAnimationController,
            image: _song.image,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 64, bottom: 16),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const PlayingShareFeature(),
                  PlayingSongDetails(
                    title: _song.title,
                    artist: _song.artist,
                  ),
                  const PlayingFavoriteFeature(),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 32, bottom: 16),
              child: PlayingProgressbar(audioPlayerManager: _audioPlayerManager,)),
          Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: _mediaButtonControl())
        ])),
      ),
    );
  }

  Widget _mediaButtonControl() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButtonControl(
              function: _setShuffle,
              icon: Icons.shuffle,
              color: _getColorShuffle(),
              size: 24),
          MediaButtonControl(
              function: _setPrevSong,
              icon: Icons.skip_previous,
              color: Colors.deepPurple,
              size: 36),
          _playButton(),
          MediaButtonControl(
              function: _setNextSong,
              icon: Icons.skip_next,
              color: Colors.deepPurple,
              size: 36),
          MediaButtonControl(
              function: _setupRepeatIcon,
              icon: _repeatingIcon(),
              color: _getRepeatingColor(),
              size: 24),
        ],
      ),
    );
  }

  StreamBuilder<PlayerState> _playButton() {
    return StreamBuilder(
        stream: _audioPlayerManager.player.playerStateStream,
        builder: (context, snapshot) {
          final playState = snapshot.data;
          final processingState = playState?.processingState;
          final playing = playState?.playing;
          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering) {
            _pauseRotationAnimation();
            return Container(
              margin: const EdgeInsets.all(8),
              width: 48,
              height: 48,
              child: const CircularProgressIndicator(),
            );
          } else if (playing != true) {
            return MediaButtonControl(
                function: () {
                  _audioPlayerManager.player.play();
                },
                icon: Icons.play_arrow,
                size: 48,
                color: Colors.deepPurple);
          } else if (processingState != ProcessingState.completed) {
            _playRotationAnimation();
            return MediaButtonControl(
                function: () {
                  _audioPlayerManager.player.pause();
                  _pauseRotationAnimation();
                },
                icon: Icons.pause,
                size: 48,
                color: Colors.deepPurple);
          } else {
            if (processingState == ProcessingState.completed) {
              _stopRotationAnimation();
              _resetRotationAnimation();
            }
            return MediaButtonControl(
                function: () {
                  _resetRotationAnimation();
                  _playRotationAnimation();
                  _audioPlayerManager.player.seek(Duration.zero);
                },
                icon: Icons.replay,
                size: 48,
                color: Colors.deepPurple);
          }
        });
  }

  void _setNextSong() {
    if (_isShuffle) {
      var random = Random();
      _selectedItemIndex = random.nextInt(widget.songs.length);
    } else if (_selectedItemIndex < widget.songs.length - 1) {
      ++_selectedItemIndex;
    } else if (_loopMode == LoopMode.all &&
        _selectedItemIndex == widget.songs.length - 1) {
      _selectedItemIndex = 0;
    }

    if (_selectedItemIndex >= widget.songs.length) {
      _selectedItemIndex = _selectedItemIndex % widget.songs.length;
    }
    final nextSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(nextSong.source);
    _resetRotationAnimation();
    setState(() {
      _song = nextSong;
    });
  }

  void _setPrevSong() {
    if (_isShuffle) {
      var random = Random();
      _selectedItemIndex = random.nextInt(widget.songs.length);
    } else if (_selectedItemIndex > 0) {
      --_selectedItemIndex;
    } else if (_loopMode == LoopMode.all && _selectedItemIndex == 0) {
      _selectedItemIndex = widget.songs.length - 1;
    }

    if (_selectedItemIndex < 0) {
      _selectedItemIndex = (-1 * _selectedItemIndex) % widget.songs.length;
    }
    final prevSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(prevSong.source);
    _resetRotationAnimation();
    setState(() {
      _song = prevSong;
    });
  }

  void _playRotationAnimation() {
    _imageAnimationController.forward(from: _currentAnimationPosition);
    _imageAnimationController.repeat();
  }

  void _pauseRotationAnimation() {
    _stopRotationAnimation();
  }

  void _stopRotationAnimation() {
    _imageAnimationController.stop();
    _currentAnimationPosition = _imageAnimationController.value;
  }

  void _resetRotationAnimation() {
    _currentAnimationPosition = 0.0;
    _imageAnimationController.value = _currentAnimationPosition;
  }

  void _setShuffle() {
    setState(() {
      _isShuffle = !_isShuffle;
    });
  }

  Color? _getColorShuffle() {
    return _isShuffle ? Colors.deepPurple : Colors.grey;
  }

  void _setupRepeatIcon() {
    if (_loopMode == LoopMode.off) {
      _loopMode = LoopMode.one;
    } else if (_loopMode == LoopMode.one) {
      _loopMode = LoopMode.all;
    } else {
      _loopMode = LoopMode.off;
    }
    setState(() {
      _audioPlayerManager.player.setLoopMode(_loopMode);
    });
  }

  IconData _repeatingIcon() {
    return switch (_loopMode) {
      LoopMode.one => Icons.repeat_one,
      LoopMode.all => Icons.repeat_on,
      _ => Icons.repeat,
    };
  }

  Color? _getRepeatingColor() {
    return _loopMode == LoopMode.off ? Colors.grey : Colors.deepPurple;
  }
}


