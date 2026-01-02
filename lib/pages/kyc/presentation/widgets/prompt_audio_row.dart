import 'dart:developer';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/bloc/cubit/wave_form_cubit.dart';
import 'package:fennac_app/bloc/state/wave_form_state.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';

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
  final waveformExtraction = WaveformExtractionController();
  final WaveformCubit _waveformCubit = Di().sl<WaveformCubit>();

  Future<void> _loadWaveform() async {
    await _waveformCubit.loadWaveform(
      audioPath: widget.audioPath,
      samples: 200,
    );
  }

  bool _isPrepared = false;

  int _totalDurationMs = 1;
  double _progress = 0.0; // 0..1

  @override
  void initState() {
    super.initState();
    _playerController = PlayerController();
    _preparePlayer();
    _listenToPlayer();
    _loadWaveform();
  }

  Future<String> _loadAssetToTemp(String assetPath) async {
    final tempDir = await getTemporaryDirectory();
    final fileName = assetPath.split('/').last;
    final file = File('${tempDir.path}/$fileName');

    if (await file.exists()) return file.path;

    final data = await rootBundle.load(assetPath);
    await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
    return file.path;
  }

  void _listenToPlayer() {
    _playerController.onCurrentDurationChanged.listen((ms) {
      if (!mounted) return;
      setState(() {
        _progress = ms / _totalDurationMs;
      });
    });

    _playerController.onPlayerStateChanged.listen((state) async {
      if (!mounted) return;
      if (state == PlayerState.playing) {
        final duration = await _playerController.getDuration();
        setState(() {
          _totalDurationMs = duration;
        });
      } else if (state == PlayerState.stopped) {
        setState(() {
          _progress = 0.0;
        });
      }
    });
  }

  Future<void> _preparePlayer() async {
    try {
      if (widget.audioPath.isEmpty) return;

      final isAsset = widget.audioPath.startsWith('assets/');
      final path = isAsset
          ? await _loadAssetToTemp(widget.audioPath)
          : widget.audioPath;

      // 🔥 FAST audio prepare
      await _playerController.preparePlayer(
        path: path,
        shouldExtractWaveform: false,
      );

      final duration = await _playerController.getDuration();
      setState(() {
        _totalDurationMs = duration > 0 ? duration : 1;
        _isPrepared = true;
      });
    } catch (e) {
      log('Audio prepare error: $e');
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
        color: widget.backgroundColor ?? ColorPalette.secondary,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(48),
      ),
      child: Row(
        children: [
          _buildPlayButton(),

          const SizedBox(width: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  height: 32,
                  child: _buildWaveform(),
                );
              },
            ),
          ),
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
        if (!_isPrepared || widget.audioPath.isEmpty) return;

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

  Widget _buildWaveform() {
    if (!_isPrepared) {
      return const SizedBox(height: 34);
    }

    return BlocBuilder<WaveformCubit, WaveformState>(
      bloc: _waveformCubit,
      buildWhen: (prev, curr) =>
          prev.waveforms[widget.audioPath] != curr.waveforms[widget.audioPath],
      builder: (context, state) {
        final waveform = state.waveforms[widget.audioPath];

        if (waveform == null || waveform.isEmpty) {
          return _waveformPlaceholder();
        }

        return _renderWaveform(waveform);
      },
    );
  }

  Widget _renderWaveform(List<double> waveform) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barCount = waveform.length;
        const maxVisibleBars = 120;
        final visibleBars = barCount > maxVisibleBars
            ? maxVisibleBars
            : barCount;
        final barWidth = constraints.maxWidth / visibleBars;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: (details) {
            final dx = details.localPosition.dx.clamp(0, constraints.maxWidth);
            final ratio = dx / constraints.maxWidth;
            _playerController.seekTo((_totalDurationMs * ratio).toInt());
          },
          onHorizontalDragUpdate: (details) {
            final dx = details.localPosition.dx.clamp(0, constraints.maxWidth);
            final ratio = dx / constraints.maxWidth;
            _playerController.seekTo((_totalDurationMs * ratio).toInt());
          },
          child: Row(
            children: List.generate(visibleBars, (index) {
              final waveformIndex = (index * barCount / visibleBars).floor();
              final playedBars = (_progress * visibleBars).floor();
              final isPlayed = index <= playedBars;

              return SizedBox(
                width: barWidth,
                child: Center(
                  child: Container(
                    width: barWidth * 0.7,
                    height: waveform[waveformIndex] * 36,
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
  }

  Widget _waveformPlaceholder() {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
