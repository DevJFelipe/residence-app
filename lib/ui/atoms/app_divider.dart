import 'package:flutter/material.dart';
import 'package:residence_app/core/theme/app_colors.dart';

/// A consistent horizontal divider line matching the
/// Residence design system.
///
/// Defaults to the standard border color and can be
/// customized via [height], [color], and [indent].
class AppDivider extends StatelessWidget {
  /// The thickness of the divider line.
  final double height;

  /// The color of the divider line.
  final Color color;

  /// Horizontal indentation applied to both sides.
  final double indent;

  const AppDivider({
    super.key,
    this.height = 1,
    this.color = AppColors.borderLight,
    this.indent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: height,
      color: color,
      indent: indent,
      endIndent: indent,
    );
  }
}
