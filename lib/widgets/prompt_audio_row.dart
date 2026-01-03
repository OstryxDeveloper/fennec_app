import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/widgets/audio_play_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cubit/audio_player_cubit.dart';
import 'custom_duration_text.dart';
import 'custom_waveform_view.dart';

class PromptAudioRow extends StatefulWidget {
  final String audioPath;
  final String duration;
  final List<double>? waveformData;
  final VoidCallback? onPlay;
  final Color? backgroundColor;
  final Color? playButtonColor;
  final Color? waveformColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final double height;

  const PromptAudioRow({
    super.key,
    required this.audioPath,
    this.duration = '00:16',
    this.waveformData,
    this.onPlay,
    this.backgroundColor,
    this.playButtonColor,
    this.waveformColor,
    this.padding,
    this.borderRadius,
    this.height = 56,
  });

  @override
  State<PromptAudioRow> createState() => _PromptAudioRowState();
}

class _PromptAudioRowState extends State<PromptAudioRow> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AudioPlayerCubit()..setSource(widget.audioPath),
      child: Container(
        height: widget.height,
        padding:
            widget.padding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? ColorPalette.secondary,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(48),
        ),
        child: Row(
          children: [
            PlayPauseButton(color: widget.playButtonColor),
            SizedBox(width: 12),
            Expanded(
              child: WaveformView(
                waveform: widget.waveformData ?? [],
                waveformColor: widget.waveformColor,
              ),
            ),
            SizedBox(width: 12),
            DurationText(),
          ],
        ),
      ),
    );
  }
}
