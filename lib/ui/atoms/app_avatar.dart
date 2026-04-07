import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';

/// An avatar circle that shows either user initials
/// or a network image.
///
/// When [imageUrl] is provided and loads successfully,
/// the image is displayed. Otherwise, [initials] are
/// rendered centered inside the circle.
class AppAvatar extends StatelessWidget {
  /// One or two character initials to display as
  /// a fallback or primary content.
  final String initials;

  /// Optional URL for the user's profile image.
  final String? imageUrl;

  /// The diameter of the avatar circle.
  final double size;

  /// Background color when showing initials.
  final Color backgroundColor;

  /// Text color for the initials.
  final Color textColor;

  const AppAvatar({
    super.key,
    required this.initials,
    this.imageUrl,
    this.size = 40,
    this.backgroundColor = AppColors.avatarPlaceholder,
    this.textColor = AppColors.textDark,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) {
            return _buildInitials();
          },
        ),
      );
    }
    return _buildInitials();
  }

  Widget _buildInitials() {
    final fontSize = size * 0.38;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: GoogleFonts.publicSans(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
