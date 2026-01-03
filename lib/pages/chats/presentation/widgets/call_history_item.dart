import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class CallHistoryItem extends StatelessWidget {
  final String? name;
  final List<String>? names;
  final String? callType;
  final String? duration;
  final String? lastMessage;
  final String timeAgo;
  final String? avatar;
  final List<String>? avatars;
  final bool isGroup;
  final EdgeInsets? padding;
  final bool showBorder;
  final Color? backgroundColor;

  const CallHistoryItem({
    super.key,
    this.name,
    this.names,
    this.callType,
    this.duration,
    this.lastMessage,
    required this.timeAgo,
    this.avatar,
    this.avatars,
    this.isGroup = false,
    this.padding,
    this.showBorder = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isCallItem = callType != null && duration != null;

    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: showBorder
            ? Border(
                bottom: BorderSide(
                  color: ColorPalette.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          // Avatar or avatars stack
          if (isGroup && avatars != null)
            _buildGroupAvatars()
          else
            _buildSingleAvatar(),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isGroup ? names!.join(', ') : name!,
                  style: AppTextStyles.subHeading(context).copyWith(
                    color: ColorPalette.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _buildSecondaryText(isCallItem),
                  style: AppTextStyles.bodySmall(context).copyWith(
                    color: ColorPalette.textSecondary,
                    height: isCallItem ? 1.0 : 1.5,
                  ),
                  maxLines: isCallItem ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Time
          Text(
            timeAgo,
            style: AppTextStyles.bodySmall(
              context,
            ).copyWith(color: ColorPalette.textSecondary),
          ),
        ],
      ),
    );
  }

  String _buildSecondaryText(bool isCallItem) {
    if (isCallItem) {
      return '$callType • $duration';
    } else {
      return lastMessage ?? '';
    }
  }

  Widget _buildSingleAvatar() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ColorPalette.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        image: DecorationImage(image: AssetImage(avatar!), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildGroupAvatars() {
    return SizedBox(
      width: 80,
      height: 60,
      child: Stack(
        children: [
          if (avatars!.isNotEmpty)
            Positioned(left: 0, top: 0, child: _buildAvatar(avatars![0])),
          if (avatars!.length > 1)
            Positioned(left: 20, top: 0, child: _buildAvatar(avatars![1])),
          if (avatars!.length > 2)
            Positioned(left: 40, top: 0, child: _buildAvatar(avatars![2])),
          if (avatars!.length > 3)
            Positioned(left: 10, bottom: 0, child: _buildAvatar(avatars![3])),
          if (avatars!.length > 4)
            Positioned(left: 30, bottom: 0, child: _buildAvatar(avatars![4])),
        ],
      ),
    );
  }

  Widget _buildAvatar(String assetPath) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ColorPalette.secondary, width: 2),
        image: DecorationImage(image: AssetImage(assetPath), fit: BoxFit.cover),
      ),
    );
  }
}
