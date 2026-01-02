import 'dart:developer';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:fennac_app/bloc/state/wave_form_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class WaveformCubit extends Cubit<WaveformState> {
  final WaveformExtractionController _extractor;

  WaveformCubit(this._extractor) : super(const WaveformState());

  Future<void> loadWaveform({
    required String audioPath,
    int samples = 5000,
  }) async {
    if (state.waveforms.containsKey(audioPath)) return;

    emit(state.copyWith(loading: true));

    try {
      String path = audioPath;
      if (audioPath.startsWith('assets/')) {
        final tempDir = await getTemporaryDirectory();
        final fileName = audioPath.split('/').last;
        final file = File('${tempDir.path}/$fileName');

        if (!await file.exists()) {
          final data = await rootBundle.load(audioPath);
          await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
        }
        path = file.path;
      }

      final data = await _extractor.extractWaveformData(
        path: path,
        noOfSamples: samples,
      );

      emit(
        state.copyWith(
          loading: false,
          waveforms: {...state.waveforms, audioPath: data},
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false));
      log('Waveform extraction error: $e');
    }
  }

  List<double>? getWaveform(String path) {
    return state.waveforms[path];
  }
}
