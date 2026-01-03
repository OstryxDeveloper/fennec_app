import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/theme/text_styles.dart';
import '../bloc/cubit/audio_player_cubit.dart';
import '../bloc/state/audio_player_state.dart';

class DurationText extends StatelessWidget {
  const DurationText({super.key});

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
      buildWhen: (p, c) => p.position != c.position || p.duration != c.duration,
      builder: (_, state) {
        final pos = state.position;
        final dur = state.duration;
        final bool isPlaying = state.status == AudioStatus.playing;
        return Text(
          isPlaying ? _format(pos) : _format(dur),
          style: AppTextStyles.bodySmall(context),
        );
      },
    );
  }
}
