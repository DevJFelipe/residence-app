import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';

/// A section header row with a title on the left and
/// an optional action link on the right.
///
/// Commonly used for "Ver todos" / "Ver todo" links
/// next to section titles throughout the app.
class SectionHeader extends StatelessWidget {
  /// The section title text.
  final String title;

  /// Optional action link label, e.g. "Ver todos".
  final String? actionLabel;

  /// Callback invoked when the action link is tapped.
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.publicSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 28 / 18,
              color: AppColors.textDark,
            ),
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: GoogleFonts.publicSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 20 / 14,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}
