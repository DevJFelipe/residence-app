import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:residence_app/core/theme/app_spacing.dart';
import 'package:residence_app/core/theme/app_text_styles.dart';

/// A single row representing a recent activity entry
/// with a colored icon circle, title and timestamp.
///
/// Optionally tappable via [onTap]. Based on the
/// dashboard activity feed pattern.
class ActivityItem extends StatelessWidget {
  /// Path to an SVG icon asset.
  final String iconAsset;

  /// Size of the SVG icon inside the circle.
  final double iconSize;

  /// Background color of the icon circle.
  final Color iconBackground;

  /// Primary text describing the activity.
  final String title;

  /// Timestamp or relative time string.
  final String time;

  /// Optional callback when the row is tapped.
  final VoidCallback? onTap;

  const ActivityItem({
    super.key,
    required this.iconAsset,
    required this.iconSize,
    required this.iconBackground,
    required this.title,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconAsset,
                  width: iconSize,
                  height: iconSize,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.semiBold14,
                ),
                Text(
                  time,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
