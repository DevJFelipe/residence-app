import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';

/// A notice card from the avisos (announcements) tab.
///
/// Displays a colored tag, title, description preview
/// and a date string. The tag color can be fully
/// customized to match the notice category.
class NoticeCard extends StatelessWidget {
  /// The category tag text, e.g. "MANTENIMIENTO".
  final String tag;

  /// The foreground color of the tag text.
  final Color tagColor;

  /// The background color of the tag container.
  final Color tagBgColor;

  /// The notice title.
  final String title;

  /// A brief description, truncated to 2 lines.
  final String description;

  /// A relative or absolute date string.
  final String date;

  const NoticeCard({
    super.key,
    required this.tag,
    required this.tagColor,
    required this.tagBgColor,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              _buildTag(),
              Text(
                date,
                style: GoogleFonts.publicSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.publicSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 22 / 15,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: GoogleFonts.publicSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 20 / 13,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTag() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: tagBgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        tag,
        style: GoogleFonts.publicSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: tagColor,
        ),
      ),
    );
  }
}
