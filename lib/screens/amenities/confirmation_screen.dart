import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/models/amenity_models.dart';
import '../../theme/app_colors.dart';

class ConfirmationScreen extends StatelessWidget {
  final Booking booking;
  final String amenityName;

  const ConfirmationScreen({
    super.key,
    required this.booking,
    required this.amenityName,
  });

  static const Color _dark = Color(0xFF1A2433);
  static const Color _bodyText = Color(0xFF475569);

  String _formatDate(DateTime dt) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    return '${dt.day} ${months[dt.month - 1]}, ${dt.year}';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${h.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    final statusText = booking.isPendiente
        ? '¡Tu reserva ha sido\nregistrada!'
        : '¡Tu reserva ha sido\nconfirmada!';
    final subtitleText = booking.isPendiente
        ? 'Tu solicitud está pendiente de aprobación.'
        : 'Todo está listo para tu evento en Residence.';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                child: Column(
                  children: [
                    _buildSuccessState(statusText, subtitleText),
                    const SizedBox(height: 32),
                    _buildReservationCard(),
                    const SizedBox(height: 32),
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0x1AEC5B13))),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: SvgPicture.asset('assets/icons/confirm_back.svg', width: 16, height: 16),
                ),
              ),
            ),
            Text(
              'Confirmación de Reserva',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 32 / 24,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState(String title, String subtitle) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: const BoxDecoration(
            color: Color(0x1AEC5B13),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset('assets/icons/confirm_check.svg', width: 50, height: 50),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            height: 36 / 30,
            color: _dark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 24 / 16,
            color: _bodyText,
          ),
        ),
      ],
    );
  }

  Widget _buildReservationCard() {
    final date = _formatDate(booking.startTime);
    final timeRange = '${_formatTime(booking.startTime)} -\n${_formatTime(booking.endTime)}';
    final refId = '#${booking.id.substring(0, 8).toUpperCase()}';

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x0DEC5B13)),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 15, offset: Offset(0, 10), spreadRadius: -3),
          BoxShadow(color: Color(0x1A000000), blurRadius: 6, offset: Offset(0, 4), spreadRadius: -4),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              amenityName,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 24, fontWeight: FontWeight.w700, height: 32 / 24, color: _dark,
              ),
            ),
            if (booking.bookingStatusName != null)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: booking.isPendiente
                      ? const Color(0xFFFEF3C7)
                      : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  booking.bookingStatusName!,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: booking.isPendiente
                        ? const Color(0xFFB45309)
                        : const Color(0xFF15803D),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Container(height: 1, color: AppColors.borderLight),
            const SizedBox(height: 17),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'assets/icons/confirm_calendar.svg', 18, 20,
                    'FECHA', date,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'assets/icons/confirm_clock.svg', 20, 20,
                    'HORARIO', timeRange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'assets/icons/confirm_ref.svg', 20, 16,
                    'REF.', refId,
                  ),
                ),
                if (booking.totalCost > 0)
                  Expanded(
                    child: _buildInfoItem(
                      'assets/icons/confirm_people.svg', 22, 16,
                      'COSTO', '\$${booking.totalCost.toStringAsFixed(0)}',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String icon, double iconW, double iconH, String label, String value) {
    return Row(
      children: [
        SvgPicture.asset(icon, width: iconW, height: iconH),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 10, fontWeight: FontWeight.w400, height: 15 / 10,
                  letterSpacing: 0.5, color: const Color(0xFF64748B),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.dmSans(
                  fontSize: 14, fontWeight: FontWeight.w700, height: 20 / 14, color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Color(0x1A000000), blurRadius: 15, offset: Offset(0, 10), spreadRadius: -3),
                ],
              ),
              child: Center(
                child: Text(
                  'Volver al Inicio',
                  style: GoogleFonts.dmSans(
                    fontSize: 16, fontWeight: FontWeight.w700, height: 24 / 16, color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
