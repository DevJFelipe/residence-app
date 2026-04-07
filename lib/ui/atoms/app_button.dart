import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';

/// Defines the visual variant for [AppButton].
enum AppButtonVariant {
  /// Solid orange background with white text.
  primary,

  /// Light orange background with orange text.
  secondary,

  /// Transparent background with orange border.
  outline,

  /// Text-only button without background or border.
  text,

  /// Circular icon-only button.
  icon,
}

/// A reusable button component with multiple visual
/// variants that match the Residence design system.
///
/// Use [AppButtonVariant] to switch between primary,
/// secondary, outline, text and icon styles.
class AppButton extends StatelessWidget {
  /// The button label displayed as text.
  /// Ignored when [variant] is [AppButtonVariant.icon].
  final String? label;

  /// Callback invoked when the button is tapped.
  final VoidCallback? onTap;

  /// The visual variant of the button.
  final AppButtonVariant variant;

  /// When true, shows a loading spinner instead of
  /// the label and disables interaction.
  final bool isLoading;

  /// When true, dims the button and disables taps.
  final bool isDisabled;

  /// Optional icon displayed before the label.
  /// For [AppButtonVariant.icon] this is required.
  final IconData? icon;

  /// When true, the button stretches to fill the
  /// available horizontal space.
  final bool fullWidth;

  const AppButton({
    super.key,
    this.label,
    this.onTap,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.fullWidth = false,
  });

  bool get _isInteractive =>
      !isLoading && !isDisabled && onTap != null;

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.icon) {
      return _buildIconVariant();
    }
    return _buildStandardVariant();
  }

  Widget _buildIconVariant() {
    return GestureDetector(
      onTap: _isInteractive ? onTap : null,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : Icon(
                    icon,
                    size: 20,
                    color: AppColors.primary,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildStandardVariant() {
    final bgColor = _backgroundColor;
    final fgColor = _foregroundColor;
    final border = _border;

    final content = Row(
      mainAxisSize:
          fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: fgColor,
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: 18, color: fgColor),
            const SizedBox(width: AppSpacing.sm),
          ],
          if (label != null)
            Text(
              label!,
              style: GoogleFonts.publicSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 24 / 16,
                color: fgColor,
              ),
            ),
        ],
      ],
    );

    return GestureDetector(
      onTap: _isInteractive ? onTap : null,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          width: fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(
              AppSpacing.radiusMd,
            ),
            border: border,
          ),
          child: content,
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.primary;
      case AppButtonVariant.secondary:
        return AppColors.primaryLight;
      case AppButtonVariant.outline:
      case AppButtonVariant.text:
        return Colors.transparent;
      case AppButtonVariant.icon:
        return AppColors.primaryLight;
    }
  }

  Color get _foregroundColor {
    switch (variant) {
      case AppButtonVariant.primary:
        return Colors.white;
      case AppButtonVariant.secondary:
      case AppButtonVariant.outline:
      case AppButtonVariant.text:
      case AppButtonVariant.icon:
        return AppColors.primary;
    }
  }

  Border? get _border {
    if (variant == AppButtonVariant.outline) {
      return Border.all(color: AppColors.primary);
    }
    return null;
  }
}
