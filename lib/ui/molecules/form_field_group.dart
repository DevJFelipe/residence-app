import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';

/// A labeled wrapper for form fields that adds a
/// text label above any child widget.
///
/// When [isRequired] is true, a red asterisk is
/// appended to the label text.
class FormFieldGroup extends StatelessWidget {
  /// The label text displayed above the child.
  final String label;

  /// The form field or widget below the label.
  final Widget child;

  /// When true, shows a red asterisk after the label.
  final bool isRequired;

  const FormFieldGroup({
    super.key,
    required this.label,
    required this.child,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: GoogleFonts.publicSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 20 / 14,
              color: AppColors.textDark,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: GoogleFonts.publicSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 20 / 14,
                        color: AppColors.error,
                      ),
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}
