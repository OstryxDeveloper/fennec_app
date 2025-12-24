import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
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
    final cubit = BlocProvider.of<KycPromptCubit>(context);
    return BlocBuilder<KycPromptCubit, KycPromptState>(
      bloc: cubit,
      builder: (context, state) {
        // Preview mode: audio has been recorded
        if (cubit.isRecorded) {
          return _buildPreviewUI(context, cubit);
        }

        // Recording mode: capture live waveform
        return _buildRecordingUI(context, cubit);
      },
    );
  }

  /// Build UI for recorded audio preview
  Widget _buildPreviewUI(BuildContext context, KycPromptCubit cubit) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 80.h,
          child: Center(
            child: _buildWaveformPreview(cubit),
          ),
        ),
        const CustomSizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPlayButton(context, cubit),
            const CustomSizedBox(width: 24),
            _buildDeleteButton(context, cubit),
          ],
        ),
      ],
    );
  }

  /// Build UI for active recording
  Widget _buildRecordingUI(BuildContext context, KycPromptCubit cubit) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 32.h,
          child: AudioWaveforms(
            size: Size(double.infinity, 32.h),
            recorderController: cubit.recorderController,
            waveStyle: const WaveStyle(
              waveColor: Colors.white,
              extendWaveform: true,
              showMiddleLine: false,
            ),
          ),
        ),
        const CustomSizedBox(height: 16),
        _buildRecordButton(context, cubit),
      ],
    );
  }

  /// Record/Stop button (mic icon or stop icon)
  Widget _buildRecordButton(BuildContext context, KycPromptCubit cubit) {
    return GestureDetector(
      onTap: () async {
        if (cubit.isRecording) {
          await cubit.stopRecording();
        } else {
          await cubit.startRecording();
        }
      },
      child: Container(
        width: 96,
        height: 96,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: cubit.isRecording ? Colors.red : ColorPalette.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (cubit.isRecording ? Colors.red : ColorPalette.primary)
                  .withOpacity(0.5),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: cubit.isRecording
            ? const Icon(Icons.stop, color: Colors.white, size: 40)
            : SvgPicture.asset(
                Assets.icons.mic.path,
                width: 32,
                height: 32,
                color: Colors.white,
              ),
      ),
    );
  }

  /// Play/Stop button for preview
  Widget _buildPlayButton(BuildContext context, KycPromptCubit cubit) {
    return GestureDetector(
      onTap: () async {
        if (cubit.isPlaying) {
          await cubit.pausePreview();
        } else {
          await cubit.playPreview();
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
        child: cubit.isPlaying
            ? const Icon(Icons.stop, color: Colors.white, size: 32)
            : SvgPicture.asset(
                Assets.icons.play.path,
                color: Colors.white,
              ),
      ),
    );
  }

  /// Delete button
  Widget _buildDeleteButton(BuildContext context, KycPromptCubit cubit) {
    return GestureDetector(
      onTap: () {
        cubit.deleteAudio();
      },
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: SvgPicture.asset(
          Assets.icons.trash.path,
          width: 24,
          height: 24,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Waveform display for recorded audio
  Widget _buildWaveformPreview(KycPromptCubit cubit) {
    if (cubit.recordedWaveformData.isEmpty) {
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
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      );
    }

    return PromptAudioRow(
      audioPath: cubit.recordingPath ?? "",
      waveformData: cubit.recordedWaveformData,
      duration: cubit.recordedDuration,
      height: 80,
      backgroundColor: Colors.transparent,
      playButtonColor: ColorPalette.primary,
      waveformColor: Colors.white,
    );
  }
}
