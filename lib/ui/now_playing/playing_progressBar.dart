import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import 'audio_player_manager.dart';

class PlayingProgressbar extends StatelessWidget {
  final AudioPlayerManager audioPlayerManager;
  const PlayingProgressbar({super.key, required this.audioPlayerManager});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DurationState>(
        stream: audioPlayerManager.durationState,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          final progress = durationState?.progress ?? Duration.zero;
          final buffer = durationState?.buffer ?? Duration.zero;
          final total = durationState?.total ?? Duration.zero;
          return ProgressBar(
            progress: progress,
            total: total,
            buffered: buffer,
            onSeek: audioPlayerManager.player.seek,
            bufferedBarColor: Colors.grey.withOpacity(0.3),
          );
        });
  }
}
