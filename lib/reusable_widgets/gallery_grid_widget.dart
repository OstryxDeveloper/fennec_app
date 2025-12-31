import 'package:fennac_app/bloc/cubit/imagepicker_cubit.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/media_container_widget.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:flutter/material.dart';

class GalleryGridWidget extends StatelessWidget {
  final List<MediaItem> mediaList;
  final Function(BuildContext context, {int? containerIndex}) onShowMediaPicker;
  final bool hasHeader;
  final MediaItem? headerMedia;

  const GalleryGridWidget({
    super.key,
    required this.mediaList,
    required this.onShowMediaPicker,
    this.hasHeader = false,
    this.headerMedia,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final largeSize = 250.0;
        final smallSize = 120.0;
        final gap = 8.0;

        // Adjust sizes if needed based on available width
        final availableWidthForTop = largeSize + gap + smallSize;
        final scaleFactor = maxWidth < availableWidthForTop
            ? maxWidth / availableWidthForTop
            : 1.0;

        final adjustedLargeSize = largeSize * scaleFactor;
        final adjustedSmallSize = smallSize * scaleFactor;
        final offset = hasHeader ? 0 : 0;

        return Column(
          children: [
            if (hasHeader) ...[
              SizedBox(
                width: double.infinity,
                height: 272,
                child: MediaContainerWidget(
                  media: headerMedia,
                  index: -1,
                  width: double.infinity,
                  height: 272,
                  onTapAdd: () async {
                    onShowMediaPicker(context, containerIndex: -1);
                  },
                ),
              ),
              CustomSizedBox(height: 8),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: adjustedLargeSize,
                  width: adjustedLargeSize,
                  child: MediaContainerWidget(
                    media: mediaList.isNotEmpty ? mediaList[0] : null,
                    index: offset,
                    width: adjustedLargeSize,
                    height: adjustedLargeSize,
                    onTapAdd: () async {
                      onShowMediaPicker(context, containerIndex: offset);
                    },
                  ),
                ),
                CustomSizedBox(width: gap),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: adjustedSmallSize,
                      height: adjustedSmallSize,
                      child: MediaContainerWidget(
                        media: mediaList.length > 1 ? mediaList[1] : null,
                        index: offset + 1,
                        width: adjustedSmallSize,
                        height: adjustedSmallSize,
                        onTapAdd: () async {
                          onShowMediaPicker(
                            context,
                            containerIndex: offset + 1,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: gap),
                    SizedBox(
                      width: adjustedSmallSize,
                      height: adjustedSmallSize,
                      child: MediaContainerWidget(
                        media: mediaList.length > 2 ? mediaList[2] : null,
                        index: offset + 2,
                        width: adjustedSmallSize,
                        height: adjustedSmallSize,
                        onTapAdd: () async {
                          onShowMediaPicker(
                            context,
                            containerIndex: offset + 2,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: gap),
            // Bottom row: 3 small containers with flexible widths
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    height: adjustedSmallSize,
                    child: MediaContainerWidget(
                      media: mediaList.length > 3 ? mediaList[3] : null,
                      index: offset + 3,
                      width: adjustedSmallSize,
                      height: adjustedSmallSize,
                      onTapAdd: () async {
                        onShowMediaPicker(context, containerIndex: offset + 3);
                      },
                    ),
                  ),
                ),
                SizedBox(width: gap),
                Expanded(
                  child: SizedBox(
                    height: adjustedSmallSize,
                    child: MediaContainerWidget(
                      media: mediaList.length > 4 ? mediaList[4] : null,
                      index: offset + 4,
                      width: adjustedSmallSize,
                      height: adjustedSmallSize,
                      onTapAdd: () async {
                        onShowMediaPicker(context, containerIndex: offset + 4);
                      },
                    ),
                  ),
                ),
                SizedBox(width: gap),
                Expanded(
                  child: SizedBox(
                    height: adjustedSmallSize,
                    child: MediaContainerWidget(
                      media: mediaList.length > 5 ? mediaList[5] : null,
                      index: offset + 5,
                      width: adjustedSmallSize,
                      height: adjustedSmallSize,
                      onTapAdd: () async {
                        onShowMediaPicker(context, containerIndex: offset + 5);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
