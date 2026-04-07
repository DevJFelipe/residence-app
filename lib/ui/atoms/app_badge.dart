import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';

/// Defines the semantic variant for [AppBadge].
enum AppBadgeVariant {
  /// Green badge for positive states like "Pagado".
  success,

  /// Orange/amber badge for pending states.
  warning,

  /// Red badge for negative states like "Vencido".
  error,

  /// Blue badge for informational states.
  info,

  /// Gray badge for neutral or inactive states.
  neutral,
}

/// A small pill-shaped status badge used throughout
/// the app for indicating item states.
///
/// Common labels include "Pagado", "Pendiente",
/// "Vencido", "Disponible", and "Mantenimiento".
class AppBadge extends StatelessWidget {
  /// The text displayed inside the badge.
  final String label;

  /// The semantic color variant.
  final AppBadgeVariant variant;

  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.neutral,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusFull,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.publicSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          height: 16 / 12,
          color: colors.$2,
        ),
      ),
    );
  }

  /// Returns (backgroundColor, textColor).
  (Color, Color) _resolveColors() {
    switch (variant) {
      case AppBadgeVariant.success:
        return (
          AppColors.successBackground,
          AppColors.success,
        );
      case AppBadgeVariant.warning:
        return (
          AppColors.warningBackground,
          AppColors.warning,
        );
      case AppBadgeVariant.error:
        return (
          AppColors.errorBackground,
          AppColors.error,
        );
      case AppBadgeVariant.info:
        return (
          AppColors.infoBackground,
          AppColors.info,
        );
      case AppBadgeVariant.neutral:
        return (
          AppColors.surfaceLight,
          AppColors.textSecondary,
        );
    }
  }
}
