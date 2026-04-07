import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';

/// An active visitor card displaying the visitor's
/// name, location, entry time, type badge, and an
/// optional exit action.
class VisitorCard extends StatelessWidget {
  /// The visitor's full name.
  final String name;

  /// The destination unit or area.
  final String location;

  /// The time the visitor entered.
  final String entryTime;

  /// The visitor type label, e.g. "Domicilio".
  final String type;

  /// The background color for the type badge.
  final Color typeBadgeColor;

  /// The text color for the type badge.
  final Color typeBadgeTextColor;

  /// Optional callback for the exit action button.
  final VoidCallback? onExit;

  const VisitorCard({
    super.key,
    required this.name,
    required this.location,
    required this.entryTime,
    required this.type,
    this.typeBadgeColor = AppColors.infoBackground,
    this.typeBadgeTextColor = AppColors.info,
    this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusMd,
        ),
        border: Border.all(
          color: AppColors.borderLight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.publicSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 24 / 16,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              _buildTypeBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildDetailRow(
            Icons.location_on_outlined,
            location,
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildDetailRow(
            Icons.access_time_rounded,
            entryTime,
          ),
          if (onExit != null) ...[
            const SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: onExit,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.errorBackground,
                  borderRadius: BorderRadius.circular(
                    AppSpacing.radiusSm,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Registrar salida',
                    style: GoogleFonts.publicSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 20 / 14,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: typeBadgeColor,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusFull,
        ),
      ),
      child: Text(
        type,
        style: GoogleFonts.publicSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: typeBadgeTextColor,
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          text,
          style: GoogleFonts.publicSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 20 / 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
