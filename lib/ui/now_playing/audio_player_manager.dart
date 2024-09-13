import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerManager {
  AudioPlayerManager._internal();

  static final AudioPlayerManager _instance = AudioPlayerManager._internal();

  factory AudioPlayerManager() => _instance;

  final player = AudioPlayer();
  String songUrl = "";
  Stream<DurationState>? durationState;

  void prepare({bool isNewSong = false}) {
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        player.positionStream,
        player.playbackEventStream,
        (position, playbackEvent) => DurationState(
            progress: position,
            buffer: playbackEvent.bufferedPosition,
            total: playbackEvent.duration));
    if (isNewSong) {
      player.setUrl(songUrl);
    }
  }

  void dispose() {
    player.dispose();
  }

  void updateSongUrl(String url) {
    songUrl = url;
    prepare();
  }
}

class DurationState {
  final Duration progress;
  final Duration buffer;
  final Duration? total;

  DurationState({required this.progress, required this.buffer, this.total});
}
