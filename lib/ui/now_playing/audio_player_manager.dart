import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerManager {
  final player = AudioPlayer();
  String songUrl;
  Stream<DurationState>? durationState;

  AudioPlayerManager({required this.songUrl});

  void init() {
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        player.positionStream,
        player.playbackEventStream,
        (position, playbackEvent) => DurationState(
            progress: position,
            buffer: playbackEvent.bufferedPosition,
            total: playbackEvent.duration));

    player.setUrl(songUrl);
  }
}

class DurationState {
  final Duration progress;
  final Duration buffer;
  final Duration? total;

  DurationState({required this.progress, required this.buffer, this.total});
}
