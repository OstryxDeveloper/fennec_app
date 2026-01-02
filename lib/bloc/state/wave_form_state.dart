class WaveformState {
  final Map<String, List<double>> waveforms;
  final bool loading;

  const WaveformState({this.waveforms = const {}, this.loading = false});

  WaveformState copyWith({
    Map<String, List<double>>? waveforms,
    bool? loading,
  }) {
    return WaveformState(
      waveforms: waveforms ?? this.waveforms,
      loading: loading ?? this.loading,
    );
  }
}
