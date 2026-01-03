import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/theme/app_colors.dart';
import '../bloc/cubit/audio_player_cubit.dart';
import '../bloc/state/audio_player_state.dart';

class WaveformView extends StatefulWidget {
  final List<double> waveform;
  final Color? waveformColor;

  const WaveformView({super.key, this.waveform = const [], this.waveformColor});

  @override
  State<WaveformView> createState() => _WaveformViewState();
}

class _WaveformViewState extends State<WaveformView> {
  double? _dragProgress;
  bool _wasPlaying = false;

  @override
  initState() {
    if (widget.waveform == null || widget.waveform!.isEmpty) {
      context.read<AudioPlayerCubit>().extractWaveForms();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
      builder: (_, state) {
        final realProgress = state.duration.inMilliseconds == 0
            ? 0.0
            : state.position.inMilliseconds / state.duration.inMilliseconds;

        final progress = _dragProgress ?? realProgress;
        return LayoutBuilder(
          builder: (context, constraints) {
            final barCount = widget.waveform.isEmpty
                ? state.waveformData?.length ?? 0
                : widget.waveform.length;
            const maxVisibleBars = 70;
            final visibleBars = (barCount) > maxVisibleBars
                ? maxVisibleBars
                : barCount;
            final barWidth = constraints.maxWidth / (visibleBars);

            void updateDrag(Offset localPos) {
              final dx = localPos.dx.clamp(0, constraints.maxWidth);
              setState(() {
                _dragProgress = dx / constraints.maxWidth;
              });
            }

            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart: (_) {
                final cubit = context.read<AudioPlayerCubit>();
                _wasPlaying = cubit.state.status == AudioStatus.playing;
              },
              onHorizontalDragUpdate: (details) =>
                  updateDrag(details.localPosition),
              onHorizontalDragEnd: (_) async {
                final cubit = context.read<AudioPlayerCubit>();
                final target = _dragProgress ?? realProgress;

                await cubit.seek(target);

                setState(() => _dragProgress = null);
              },
              onTapDown: (details) async {
                final cubit = context.read<AudioPlayerCubit>();
                final dx = details.localPosition.dx.clamp(
                  0,
                  constraints.maxWidth,
                );
                await cubit.seek(dx / constraints.maxWidth);
              },
              child: Row(
                children: List.generate((visibleBars), (index) {
                  final waveformIndex = (index * (barCount) / (visibleBars))
                      .floor()
                      .clamp(0, (barCount) - 1);
                  final playedBars = (progress * (visibleBars)).floor();
                  final isPlayed = index <= playedBars;

                  return SizedBox(
                    width: barWidth,
                    child: Center(
                      child: Container(
                        width: barWidth * 0.5,
                        height:
                            (widget.waveform.isEmpty
                                ? state.waveformData
                                : widget.waveform)?[waveformIndex] ??
                            0,
                        decoration: BoxDecoration(
                          color: isPlayed
                              ? ColorPalette.primary
                              : (widget.waveformColor ?? Colors.white),
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          },
        );
      },
    );
  }
}
