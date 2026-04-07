import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';

/// A news card from the condo profile screen.
///
/// Displays a colored category tag, title, description
/// preview, and a relative time indicator.
class NewsCard extends StatelessWidget {
  /// The category tag text, e.g. "MANTENIMIENTO".
  final String tag;

  /// The foreground color of the tag text.
  final Color tagColor;

  /// The background color of the tag container.
  final Color tagBgColor;

  /// The news title.
  final String title;

  /// A brief description, truncated to 2 lines.
  final String description;

  /// A relative time string, e.g. "Hoy" or "Ayer".
  final String timeAgo;

  /// Optional left border color for emphasis.
  /// Pass [Colors.transparent] to remove it.
  final Color? leftBorderColor;

  /// Optional background color override.
  final Color? backgroundColor;

  const NewsCard({
    super.key,
    required this.tag,
    required this.tagColor,
    this.tagBgColor = AppColors.borderLight,
    required this.title,
    required this.description,
    required this.timeAgo,
    this.leftBorderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasLeftBorder = leftBorderColor != null &&
        leftBorderColor != Colors.transparent;
    final bgColor =
        backgroundColor ?? AppColors.borderLight;

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        AppSpacing.radiusMd,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: bgColor,
          border: hasLeftBorder
              ? Border(
                  left: BorderSide(
                    color: leftBorderColor!,
                    width: 4,
                  ),
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                _buildTag(),
                Text(
                  timeAgo,
                  style: GoogleFonts.publicSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: GoogleFonts.publicSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 20 / 14,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              description,
              style: GoogleFonts.publicSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 16 / 12,
                color: const Color(0xFF475569),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: tagBgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        tag,
        style: GoogleFonts.publicSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 15 / 10,
          letterSpacing: 1,
          color: tagColor,
        ),
      ),
    );
  }
}
