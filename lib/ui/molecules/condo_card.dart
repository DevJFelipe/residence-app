import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';
import 'package:residence_app/core/theme/app_text_styles.dart';

/// A featured condominium card used in the explorar
/// (explore) tab.
///
/// Shows a cover image, the condo name, and location
/// with a pin icon. Tappable via [onTap].
class CondoCard extends StatelessWidget {
  /// Path to the local image asset.
  final String image;

  /// The condominium name.
  final String name;

  /// The location string, e.g. "Bogota, Norte".
  final String location;

  /// Callback invoked when the card is tapped.
  final VoidCallback? onTap;

  const CondoCard({
    super.key,
    required this.image,
    required this.name,
    required this.location,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 256,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                AppSpacing.radiusMd,
              ),
              child: Image.asset(
                image,
                width: 256,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              name,
              style: GoogleFonts.publicSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 24 / 16,
                color: AppColors.textDark,
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/welcome_pin.svg',
                  width: 9.333,
                  height: 11.667,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  location,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
