import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/theme/app_colors.dart';
import '../bloc/cubit/audio_player_cubit.dart';
import '../bloc/state/audio_player_state.dart';

class PlayPauseButton extends StatelessWidget {
  final Color? color;
  const PlayPauseButton({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
      builder: (_, state) {
        final isStopped =
            state.status == AudioStatus.stopped ||
            state.status == AudioStatus.paused;

        return GestureDetector(
          onTap: () => context.read<AudioPlayerCubit>().toggle(),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color ?? ColorPalette.primary,
            ),
            child: Icon(
              isStopped ? Icons.play_arrow : Icons.pause,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
