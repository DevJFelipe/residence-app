import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';

/// Defines the status of a reservation.
enum ReservationStatus {
  /// Reservation is confirmed.
  confirmed,

  /// Reservation is awaiting confirmation.
  pending,

  /// Reservation has been completed.
  finished,
}

/// A card representing a user's reservation for a
/// community amenity.
///
/// Displays status badge, title, date, time slot,
/// guest count, optional reference code, a thumbnail
/// image, and a view-details action.
class ReservationCard extends StatelessWidget {
  /// The amenity name, e.g. "Salon Social".
  final String title;

  /// Path to the local thumbnail image asset.
  final String image;

  /// The reservation date string.
  final String date;

  /// The time slot, e.g. "18:00 - 22:00".
  final String timeSlot;

  /// Number of guests.
  final int guests;

  /// The current reservation status.
  final ReservationStatus status;

  /// Optional reference code for the reservation.
  final String? referenceCode;

  /// Optional callback for the view details button.
  final VoidCallback? onViewDetails;

  const ReservationCard({
    super.key,
    required this.title,
    required this.image,
    required this.date,
    required this.timeSlot,
    required this.guests,
    this.status = ReservationStatus.confirmed,
    this.referenceCode,
    this.onViewDetails,
  });

  bool get _isFinished =>
      status == ReservationStatus.finished;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isFinished ? 0.8 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: _isFinished
              ? const Color(0x99FFFFFF)
              : Colors.white,
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
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _buildStatusBadge(),
                  const SizedBox(
                    height: AppSpacing.xs,
                  ),
                  Text(
                    title,
                    style: GoogleFonts.publicSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 24 / 18,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.xs,
                  ),
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    date,
                  ),
                  _buildInfoRow(
                    Icons.access_time_rounded,
                    timeSlot,
                  ),
                  _buildInfoRow(
                    Icons.people_outline_rounded,
                    '$guests invitados',
                  ),
                  if (referenceCode != null)
                    _buildInfoRow(
                      Icons.tag_rounded,
                      referenceCode!,
                    ),
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
                  GestureDetector(
                    onTap: onViewDetails,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: _isFinished
                            ? null
                            : AppColors.textDark,
                        borderRadius:
                            BorderRadius.circular(
                          AppSpacing.radiusSm,
                        ),
                        border: _isFinished
                            ? Border.all(
                                color:
                                    AppColors.textDark,
                              )
                            : null,
                      ),
                      child: Text(
                        'VER DETALLES',
                        style: GoogleFonts.publicSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 16 / 12,
                          letterSpacing: 0.6,
                          color: _isFinished
                              ? AppColors.textDark
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                AppSpacing.radiusSm,
              ),
              child: ColorFiltered(
                colorFilter: _isFinished
                    ? const ColorFilter.mode(
                        Colors.white,
                        BlendMode.saturation,
                      )
                    : const ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.dst,
                      ),
                child: Image.asset(
                  image,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    late Color bgColor;
    late Color textColor;
    late String label;

    switch (status) {
      case ReservationStatus.confirmed:
        bgColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF15803D);
        label = 'CONFIRMADA';
      case ReservationStatus.pending:
        bgColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFB45309);
        label = 'PENDIENTE';
      case ReservationStatus.finished:
        bgColor = const Color(0xFFE2E8F0);
        textColor = const Color(0xFF475569);
        label = 'FINALIZADA';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusFull,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.publicSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 15 / 10,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(
            icon,
            size: 12,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.xs),
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
      ),
    );
  }
}
