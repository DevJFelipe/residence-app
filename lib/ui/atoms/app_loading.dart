import 'package:flutter/material.dart';
import 'package:residence_app/core/theme/app_colors.dart';

/// A centered loading spinner using the app's primary
/// color by default.
///
/// Drop this widget anywhere a loading state is needed
/// for a consistent spinner appearance.
class AppLoading extends StatelessWidget {
  /// The diameter of the spinner.
  final double size;

  /// The color of the spinning arc.
  final Color color;

  const AppLoading({
    super.key,
    this.size = 32,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: color,
        ),
      ),
    );
  }
}
