import 'package:flutter/material.dart';

import '../../widgets/media_button_control.dart';

class PlayingMediaButtonControl extends StatefulWidget {
  const PlayingMediaButtonControl({super.key});

  @override
  State<PlayingMediaButtonControl> createState() => _PlayingMediaButtonControlState();
}

class _PlayingMediaButtonControlState extends State<PlayingMediaButtonControl> {
  @override
  Widget build(BuildContext context) {
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

  void _setShuffle() {
    setState(() {
      _isShuffle = !_isShuffle;
    });
  }
}
