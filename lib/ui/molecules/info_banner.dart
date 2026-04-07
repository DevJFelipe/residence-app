import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';

/// Defines the color scheme for [InfoBanner].
enum InfoBannerType {
  /// Blue informational banner.
  info,

  /// Orange warning banner.
  warning,

  /// Green success banner.
  success,
}

/// An informational banner displaying an icon and a
/// message in a colored container.
///
/// Useful in forms or detail screens to communicate
/// contextual information to the user.
class InfoBanner extends StatelessWidget {
  /// The message text to display.
  final String message;

  /// The semantic type controlling colors and icon.
  final InfoBannerType type;

  const InfoBanner({
    super.key,
    required this.message,
    this.type = InfoBannerType.info,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusMd,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            colors.$3,
            size: 20,
            color: colors.$2,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.publicSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 20 / 14,
                color: colors.$2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns (bgColor, textColor, icon).
  (Color, Color, IconData) _resolveColors() {
    switch (type) {
      case InfoBannerType.info:
        return (
          AppColors.infoBackground,
          AppColors.info,
          Icons.info_outline_rounded,
        );
      case InfoBannerType.warning:
        return (
          AppColors.warningBackground,
          AppColors.warning,
          Icons.warning_amber_rounded,
        );
      case InfoBannerType.success:
        return (
          AppColors.successBackground,
          AppColors.success,
          Icons.check_circle_outline_rounded,
        );
    }
  }
}
