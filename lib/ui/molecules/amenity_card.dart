import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';

/// Defines the availability status of an amenity.
enum AmenityStatus {
  /// The amenity is open for reservations.
  available,

  /// The amenity is under maintenance.
  maintenance,
}

/// A card representing a community amenity with an
/// image, title, capacity, status badge, and an
/// optional reserve action.
///
/// Based on the amenities screen card pattern.
class AmenityCard extends StatelessWidget {
  /// The amenity name.
  final String title;

  /// Path to the local image asset.
  final String image;

  /// Capacity text, e.g. "Capacidad: 20 personas".
  final String capacity;

  /// The current availability status.
  final AmenityStatus status;

  /// Optional callback for the reserve button.
  /// Only active when status is [AmenityStatus.available].
  final VoidCallback? onReserve;

  const AmenityCard({
    super.key,
    required this.title,
    required this.image,
    required this.capacity,
    this.status = AmenityStatus.available,
    this.onReserve,
  });

  bool get _isAvailable =>
      status == AmenityStatus.available;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusMd,
        ),
        border: Border.all(
          color: AppColors.divider.withValues(
            alpha: 0.05,
          ),
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
          _buildImage(),
          Opacity(
            opacity: _isAvailable ? 1.0 : 0.8,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.publicSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 28 / 20,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.xs,
                  ),
                  Text(
                    capacity,
                    style: GoogleFonts.publicSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 20 / 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  _buildButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final badgeColor = _isAvailable
        ? const Color(0xFF10B981)
        : const Color(0xFFF59E0B);
    final badgeLabel = _isAvailable
        ? 'DISPONIBLE'
        : 'MANTENIMIENTO';

    return SizedBox(
      height: 192,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(image, fit: BoxFit.cover),
          Positioned(
            top: 9,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 2.5,
              ),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(
                  AppSpacing.radiusFull,
                ),
              ),
              child: Text(
                badgeLabel,
                style: GoogleFonts.publicSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 15 / 10,
                  letterSpacing: 1,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return GestureDetector(
      onTap: _isAvailable ? onReserve : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: _isAvailable
              ? AppColors.primary
              : const Color(0xFFCBD5E1),
          borderRadius: BorderRadius.circular(
            AppSpacing.radiusSm,
          ),
        ),
        child: Center(
          child: Text(
            _isAvailable
                ? 'Reservar ahora'
                : 'No disponible',
            style: GoogleFonts.publicSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 24 / 16,
              color: _isAvailable
                  ? Colors.white
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
