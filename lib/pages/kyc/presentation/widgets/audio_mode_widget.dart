// import 'dart:math';

import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_prompt_cubit.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/state/kyc_prompt_state.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/prompt_audio_row.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// AudioModeWidget - Thin, declarative UI
/// All logic is handled by KycPromptCubit
class AudioModeWidget extends StatelessWidget {
  final bool? isCustom;
  final String promptText;
  final String? existingAnswer;
  final String? existingAudioPath;
  final AudioPromptData? existingAudioData;

  const AudioModeWidget({
    super.key,
    this.isCustom = false,
    required this.promptText,
    this.existingAnswer,
    this.existingAudioPath,
    this.existingAudioData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KycPromptCubit, KycPromptState>(
      bloc: _kycPromptCubit,
      builder: (context, state) {
        // Preview mode: audio has been recorded
        if (_kycPromptCubit.isRecorded) {
          return _buildPreviewUI(
            context,
            existingAudioPath ?? "",
            existingAudioData,
          );
        }

        // Recording mode: capture live waveform
        return _buildRecordingUI(context);
      },
    );
  }

  /// Build UI for recorded audio preview
  Widget _buildPreviewUI(
    BuildContext context,
    String audioPath,
    AudioPromptData? audioData,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 80.h,
          child: Center(
            child: _buildWaveformPreview(
              _kycPromptCubit.recordingPath ?? existingAudioPath!,
              existingAudioData,
            ),
          ),
        ),
        const CustomSizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPlayButton(context),
            const CustomSizedBox(width: 24),
            _buildDeleteButton(context),
          ],
        ),
      ],
    );
  }

  /// Build UI for active recording
  Widget _buildRecordingUI(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 32.h,
          child: BlocBuilder<KycPromptCubit, KycPromptState>(
            bloc: _kycPromptCubit,
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (scrollController.hasClients) {
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });
              return SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _kycPromptCubit.recordedWaveformData.map((sample) {
                    // Map 0..100 or 0..1 to visual height (8..32)
                    final normalized = sample > 1.0 ? sample / 100.0 : sample;
                    final boosted = (normalized * 1.25).clamp(0.0, 1.0);
                    final barHeight = (8 + (24 * boosted)).clamp(8.0, 32.h);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Container(
                        width: 3,
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),

        // SizedBox(
        //   height: 32.h,
        //   child: StreamBuilder<Amplitude>(
        //     stream: cubit.record.onAmplitudeChanged(
        //       const Duration(milliseconds: 80),
        //     ),
        //     builder: (context, snapshot) {
        //       final amp = snapshot.data?.current ?? -60.0;

        //       // 1️⃣ Clamp amplitude safely
        //       final normalizedAmp = amp.clamp(-60.0, 0.0);

        //       // 2️⃣ Convert to height
        //       final rawHeight = ((normalizedAmp + 60) / 60) * 30;

        //       // 3️⃣ Final safety clamp
        //       final height = rawHeight.clamp(2.0, 30.0);

        //       return Align(
        //         alignment: Alignment.bottomCenter,
        //         child: Container(
        //           width: 2,
        //           height: height,
        //           decoration: BoxDecoration(
        //             color: Colors.white,
        //             borderRadius: BorderRadius.circular(2),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),

        // SizedBox(
        //   height: 32.h,
        //   child: AudioWaveforms(
        //     size: Size(double.infinity, 32.h),
        //     recorderController: cubit.recorderController,
        //     waveStyle: const WaveStyle(
        //       waveColor: Colors.white,
        //       extendWaveform: true,
        //       showMiddleLine: false,
        //     ),
        //   ),
        // ),
        const CustomSizedBox(height: 16),
        _buildRecordButton(context),
      ],
    );
  }

  /// Record/Stop button (mic icon or stop icon)
  Widget _buildRecordButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (_kycPromptCubit.isRecording) {
          await _kycPromptCubit.stopRecording();
        } else {
          await _kycPromptCubit.startRecording();
        }
      },
      child: Container(
        width: 96,
        height: 96,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _kycPromptCubit.isRecording
              ? Colors.red
              : ColorPalette.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color:
                  (_kycPromptCubit.isRecording
                          ? Colors.red
                          : ColorPalette.primary)
                      .withValues(alpha: 0.5),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: _kycPromptCubit.isRecording
            ? const Icon(Icons.stop, color: Colors.white, size: 40)
            : SvgPicture.asset(
                Assets.icons.mic.path,
                width: 32,
                height: 32,
                colorFilter: ColorFilter.mode(
                  ColorPalette.white,
                  BlendMode.srcIn,
                ),
              ),
      ),
    );
  }

  /// Play/Stop button for preview
  Widget _buildPlayButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (_kycPromptCubit.isPlaying) {
          await _kycPromptCubit.pausePreview();
        } else {
          await _kycPromptCubit.playPreview();
        }
      },
      child: Container(
        width: 96.h,
        height: 96.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorPalette.primary,
          shape: BoxShape.circle,
        ),
        child: _kycPromptCubit.isPlaying
            ? const Icon(Icons.stop, color: Colors.white, size: 32)
            : SvgPicture.asset(
                Assets.icons.play.path,
                colorFilter: ColorFilter.mode(
                  ColorPalette.white,
                  BlendMode.srcIn,
                ),
              ),
      ),
    );
  }

  /// Delete button
  Widget _buildDeleteButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _kycPromptCubit.deleteAudio();
      },
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: SvgPicture.asset(
          Assets.icons.trash.path,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(ColorPalette.white, BlendMode.srcIn),
        ),
      ),
    );
  }

  /// Waveform display for recorded audio
  Widget _buildWaveformPreview(String audioPath, AudioPromptData? audioData) {
    if (_kycPromptCubit.recordedWaveformData.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(40, (i) {
          final heights = [25.0, 35.0, 45.0, 30.0, 40.0, 50.0];
          return Container(
            width: 3,
            height: heights[i % heights.length],
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      );
    }

    return PromptAudioRow(
      audioPath: existingAudioPath ?? _kycPromptCubit.recordingPath ?? "",
      waveformData: audioData?.waveformData.isNotEmpty ?? false
          ? audioData?.waveformData ?? []
          : _kycPromptCubit.recordedWaveformData,
      duration: audioData?.duration ?? _kycPromptCubit.recordedDuration,
      height: 80,
      backgroundColor: Colors.transparent,
      playButtonColor: ColorPalette.primary,
      waveformColor: Colors.white,
    );
  }
}

final _kycPromptCubit = Di().sl<KycPromptCubit>();
