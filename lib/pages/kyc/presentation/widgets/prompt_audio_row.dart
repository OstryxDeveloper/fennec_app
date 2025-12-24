import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  late final PlayerController _playerController;
  bool _isPrepared = false;

  @override
  void initState() {
    super.initState();
    _playerController = PlayerController();
    _preparePlayer();
  }

  Future<void> _preparePlayer() async {
    debugPrint(
      'Preparing audio player for: ${widget.audioPath} :: waveform samples: ${widget.waveformData?.length ?? 0}',
    );
    await _playerController.preparePlayer(
      path: widget.audioPath,
      noOfSamples: widget.waveformData?.length ?? 120,
      shouldExtractWaveform: true,
    );

    /// IMPORTANT: force rebuild after waveform extraction
    if (mounted) {
      setState(() {
        _isPrepared = true;
      });
    }
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding:
          widget.padding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? ColorPalette.secondry,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(48),
      ),
      child: Row(
        children: [
          _buildPlayButton(),
          const SizedBox(width: 12),
          Expanded(child: _buildWaveform(context)),
          const SizedBox(width: 12),
          Text(widget.duration, style: AppTextStyles.bodySmall(context)),
        ],
      ),
    );
  }

  Widget _buildPlayButton() {
    return GestureDetector(
      onTap: () async {
        widget.onPlay?.call();

        if (_playerController.playerState == PlayerState.playing) {
          await _playerController.pausePlayer();
        } else {
          await _playerController.startPlayer();
        }
      },
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.playButtonColor ?? ColorPalette.primary,
        ),
        child: SvgPicture.asset(Assets.icons.play.path, width: 12, height: 15),
      ),
    );
  }

  Widget _buildWaveform(BuildContext context) {
    if (!_isPrepared) {
      return const SizedBox(height: 34);
    }

    return AudioFileWaveforms(
      playerController: _playerController,
      waveformType: WaveformType.fitWidth,
      size: const Size(double.infinity, 34),

      playerWaveStyle: PlayerWaveStyle(
        showTop: true,
        fixedWaveColor: widget.waveformColor ?? Colors.white,
        liveWaveColor: ColorPalette.primary,
        waveCap: StrokeCap.round,
        spacing: 4,
        waveThickness: 2,
      ),
    );
  }
}
