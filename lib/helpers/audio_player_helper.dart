import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerHelper {
  final AudioPlayer player = AudioPlayer();
  final waveformExtraction = WaveformExtractionController();

  Future<void> setSource(String path) async {
    if (path.startsWith('assets/')) {
      await player.setAsset(path);
    } else if (path.startsWith('http://') || path.startsWith('https://')) {
      await player.setUrl(path);
    } else {
      await player.setFilePath(path);
    }
  }

  Future<void> play() async => player.play();

  Future<void> pause() async => player.pause();

  Future<void> stop() async => player.stop();

  bool get isPlaying => player.playing;

  Stream<Duration> get positionStream => player.positionStream;

  Stream<Duration?> get durationStream => player.durationStream;

  Future<void> dispose() async => player.dispose();

  String formatedDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<List<double>> extractWaveformData(
    String audioPath, {
    int samples = 100,
  }) async {
    return await waveformExtraction.extractWaveformData(
      path: audioPath,
      noOfSamples: samples,
    );
  }
}
