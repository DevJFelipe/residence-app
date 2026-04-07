import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';

/// A gauge card showing the current visitor occupancy
/// as a fraction and progress bar.
///
/// Extracted from the visitors occupancy card pattern.
/// Accepts dynamic [current] and [capacity] values.
class OccupancyGauge extends StatelessWidget {
  /// Current number of visitors present.
  final int current;

  /// Maximum recommended visitor capacity.
  final int capacity;

  const OccupancyGauge({
    super.key,
    required this.current,
    required this.capacity,
  });

  double get _fraction =>
      capacity > 0 ? (current / capacity).clamp(0, 1) : 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.primaryExtraLight,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusMd,
        ),
        border: Border.all(
          color: AppColors.primaryBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSpacing.sm),
          _buildProgressBar(),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'CAPACIDAD DE VISITANTES RECOMENDADA',
            style: GoogleFonts.publicSans(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              height: 15 / 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'OCUPACION ACTUAL',
          style: GoogleFonts.publicSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            height: 16 / 12,
            letterSpacing: 1.2,
            color: AppColors.primary.withValues(
              alpha: 0.7,
            ),
          ),
        ),
        Text(
          '$current/$capacity',
          style: GoogleFonts.publicSans(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 32 / 24,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusFull,
        ),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: _fraction.toDouble(),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(
              AppSpacing.radiusFull,
            ),
          ),
        ),
      ),
    );
  }
}
