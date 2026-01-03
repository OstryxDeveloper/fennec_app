enum AudioStatus { idle, loading, playing, paused, stopped }

class AudioPlayerState {
  final AudioStatus status;
  final Duration position;
  final Duration duration;
  final String? path;
  final List<double>? waveformData;

  const AudioPlayerState({
    required this.status,
    required this.position,
    required this.duration,
    this.waveformData,
    this.path,
  });

  factory AudioPlayerState.initial() => const AudioPlayerState(
    status: AudioStatus.idle,
    position: Duration.zero,
    duration: Duration.zero,
    waveformData: [],
  );

  AudioPlayerState copyWith({
    AudioStatus? status,
    Duration? position,
    Duration? duration,
    String? path,
    List<double>? waveformData,
  }) {
    return AudioPlayerState(
      status: status ?? this.status,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      path: path ?? this.path,
      waveformData: waveformData ?? this.waveformData,
    );
  }
}
