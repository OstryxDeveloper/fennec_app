import 'dart:io';

import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/bloc/cubit/imagepicker_cubit.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

class MediaContainerWidget extends StatefulWidget {
  final MediaItem? media;
  final int index;
  final double width;
  final double height;
  final VoidCallback onTapAdd;

  const MediaContainerWidget({
    super.key,
    this.media,
    required this.index,
    required this.width,
    required this.height,
    required this.onTapAdd,
  });

  @override
  State<MediaContainerWidget> createState() => _MediaContainerWidgetState();
}

class _MediaContainerWidgetState extends State<MediaContainerWidget> {
  VideoPlayerController? _videoController;
  Future<void>? _videoInitFuture;

  @override
  void initState() {
    super.initState();
    _initVideoControllerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant MediaContainerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.media?.path != widget.media?.path ||
        oldWidget.media?.type != widget.media?.type) {
      _disposeVideo();
      _initVideoControllerIfNeeded();
    }
  }

  @override
  void dispose() {
    _disposeVideo();
    super.dispose();
  }

  void _initVideoControllerIfNeeded() {
    if (widget.media?.type != MediaType.video) return;

    _videoController = VideoPlayerController.file(File(widget.media!.path));
    _videoInitFuture = _videoController!
        .initialize()
        .then(
          (_) => _videoController
            ?..setVolume(0)
            ..pause(),
        )
        .catchError((error) {
          debugPrint('Video preview init failed: $error');
          return null;
        });
  }

  void _disposeVideo() {
    _videoController?.dispose();
    _videoController = null;
    _videoInitFuture = null;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = Di().sl<ImagePickerCubit>();

    if (widget.media == null) {
      return _buildUploadPlaceholder();
    }

    return LongPressDraggable<int>(
      data: widget.index,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: _buildMediaPreview(cubit),
      ),
      childWhenDragging: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          color: Colors.black.withOpacity(0.3),
        ),
      ),
      child: DragTarget<int>(
        onAcceptWithDetails: (details) {
          cubit.reorderMedia(details.data, widget.index);
        },
        builder: (context, candidateData, rejectedData) {
          return _buildMediaWithDelete(cubit);
        },
      ),
    );
  }

  Widget _buildUploadPlaceholder() {
    return GestureDetector(
      onTap: widget.onTapAdd,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: ColorPalette.secondry.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Center(
          child: SvgPicture.asset(
            Assets.icons.camera.path,
            fit: BoxFit.scaleDown,
            width: 32,
            height: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPreview(ImagePickerCubit cubit) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: widget.media!.type == MediaType.image
            ? Image.file(
                File(widget.media!.path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildErrorWidget();
                },
              )
            : _buildVideoThumbnail(),
      ),
    );
  }

  Widget _buildMediaWithDelete(ImagePickerCubit cubit) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: widget.media!.type == MediaType.image
                ? Image.file(
                    File(widget.media!.path),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildErrorWidget();
                    },
                  )
                : _buildVideoThumbnail(),
          ),
          // Delete button
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () =>
                  cubit.removeMedia(widget.media!.id, index: widget.index),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
          // Video badge
          if (widget.media!.type == MediaType.video)
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'VIDEO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoThumbnail() {
    if (_videoController == null || _videoInitFuture == null) {
      return _buildVideoPlaceholder();
    }

    return FutureBuilder(
      future: _videoInitFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildVideoPlaceholder(isLoading: true);
        }
        if (snapshot.hasError || !_videoController!.value.isInitialized) {
          return _buildVideoPlaceholder();
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController!.value.size.width,
                height: _videoController!.value.size.height,
                child: VideoPlayer(_videoController!),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVideoPlaceholder({bool isLoading = false}) {
    return Container(
      color: ColorPalette.secondry.withOpacity(0.3),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(
                Icons.video_camera_back,
                color: Colors.white.withOpacity(0.6),
                size: 40,
              ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: ColorPalette.secondry.withOpacity(0.5),
      child: const Icon(Icons.broken_image, color: Colors.white54, size: 30),
    );
  }
}
