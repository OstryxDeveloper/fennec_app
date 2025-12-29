import 'dart:developer';

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

  List<double> data = [];
  final waveformExtraction = WaveformExtractionController();
  Future<void> _preparePlayer() async {
    try {
      debugPrint(
        'Preparing audio player for: ${widget.audioPath} :: waveform samples: ${widget.waveformData?.length ?? 0}',
      );

      // If no audio path, skip player prep and use provided/default waveform
      if (widget.audioPath.isEmpty) {
        final source = widget.waveformData ?? _imageWaveform;
        final normalized = _normalizeWaveform(source);
        if (mounted) {
          setState(() {
            _isPrepared = true;
            data = normalized;
          });
        }
        return;
      }

      await _playerController.preparePlayer(path: widget.audioPath);

      List<double> waveformData;
      if (widget.waveformData != null && widget.waveformData!.isNotEmpty) {
        waveformData = _normalizeWaveform(widget.waveformData!);
      } else {
        waveformData = await waveformExtraction.extractWaveformData(
          path: widget.audioPath,
          noOfSamples: 200,
        );
      }

      /// IMPORTANT: force rebuild after waveform extraction
      if (mounted) {
        setState(() {
          _isPrepared = true;
          data = waveformData;
          log('Extracted waveform data length: ${data.length}');
        });
      }
    } catch (e) {
      log("Error preparing player: $e");
    }
  }

  /// Normalize incoming waveform samples to 0..1 and apply a small boost.
  List<double> _normalizeWaveform(List<double> input) {
    if (input.isEmpty) return input;
    // Detect typical ranges (0..1 or 0..100)
    final maxVal = input.reduce((a, b) => a > b ? a : b);
    final scale = maxVal == 0 ? 1.0 : maxVal;
    // Map to 0..1 and apply 1.2x visual boost (clamped)
    return input
        .map((v) => ((v / scale) * 1.2).clamp(0.0, 1.0))
        .toList(growable: false);
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
        color: widget.backgroundColor ?? ColorPalette.secondary,
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

        // If there is no audio source, just return after callback
        if (widget.audioPath.isEmpty || !_isPrepared) return;

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

    // Compute an inner height based on the container height/padding.
    final padding =
        (widget.padding as EdgeInsets?) ??
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
    final innerHeight = (widget.height - padding.vertical)
        .clamp(24, widget.height.toInt())
        .toDouble();

    return AudioFileWaveforms(
      playerController: _playerController,
      waveformData: data,
      waveformType: WaveformType.fitWidth,
      size: Size(double.infinity, innerHeight),

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

// Fallback waveform used when no audio path is provided.
const List<double> _imageWaveform = [
  0.16,
  0.28,
  0.42,
  0.56,
  0.72,
  0.88,
  0.98,
  0.86,
  0.72,
  0.58,
  0.42,
  0.30,
  0.18,
  0.10,
  0.22,
  0.38,
  0.54,
  0.70,
  0.86,
  0.98,
  0.88,
  0.72,
  0.54,
  0.36,
  0.24,
  0.14,
  0.24,
  0.38,
  0.54,
  0.70,
  0.86,
  0.98,
  0.90,
  0.78,
  0.62,
  0.46,
  0.32,
  0.20,
  0.12,
  0.24,
  0.40,
  0.58,
  0.74,
  0.90,
  0.98,
  0.88,
  0.72,
  0.56,
  0.40,
  0.26,
  0.16,
  0.16,
  0.26,
  0.40,
  0.56,
  0.72,
  0.88,
  0.98,
  0.90,
  0.74,
  0.58,
  0.40,
  0.24,
  0.14,
  0.22,
  0.36,
  0.54,
  0.70,
  0.86,
  0.98,
  0.88,
  0.70,
  0.52,
  0.36,
  0.22,
  0.12,
  0.18,
  0.30,
  0.42,
  0.58,
  0.74,
  0.90,
  0.98,
  0.86,
  0.70,
  0.54,
  0.38,
  0.24,
  0.16,
  0.16,
  0.24,
  0.38,
  0.54,
  0.70,
  0.86,
  0.98,
  0.88,
  0.72,
  0.58,
  0.42,
  0.28,
  0.16,
];
