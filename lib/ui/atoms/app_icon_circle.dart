import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:residence_app/core/theme/app_colors.dart';

/// A circular container that displays either an SVG
/// asset or a Material icon.
///
/// Used throughout the app for feature grids,
/// activity items, and other iconographic elements.
class AppIconCircle extends StatelessWidget {
  /// Path to an SVG asset file. Takes priority over
  /// [iconData] when both are provided.
  final String? svgAsset;

  /// A Material icon to display inside the circle.
  final IconData? iconData;

  /// The diameter of the outer circle.
  final double size;

  /// Background color of the circle.
  final Color backgroundColor;

  /// Color applied to the icon or SVG.
  final Color iconColor;

  /// Size of the icon or SVG within the circle.
  final double iconSize;

  const AppIconCircle({
    super.key,
    this.svgAsset,
    this.iconData,
    this.size = 40,
    this.backgroundColor = AppColors.primaryLight,
    this.iconColor = AppColors.primary,
    this.iconSize = 20,
  }) : assert(
         svgAsset != null || iconData != null,
         'Either svgAsset or iconData is required.',
       );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(child: _buildIcon()),
    );
  }

  Widget _buildIcon() {
    if (svgAsset != null) {
      return SvgPicture.asset(
        svgAsset!,
        width: iconSize,
        height: iconSize,
        colorFilter: ColorFilter.mode(
          iconColor,
          BlendMode.srcIn,
        ),
      );
    }
    return Icon(
      iconData,
      size: iconSize,
      color: iconColor,
    );
  }
}
