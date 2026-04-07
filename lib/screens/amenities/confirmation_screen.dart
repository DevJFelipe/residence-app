import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  static const Color _dark = Color(0xFF1A2433);
  static const Color _bodyText = Color(0xFF475569);

  @override
  Widget build(BuildContext context) {
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
                    _buildSuccessState(),
                    const SizedBox(height: 32),
                    _buildReservationCard(),
                    const SizedBox(height: 32),
                    _buildQrSection(),
                    const SizedBox(height: 32),
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomNav(context),
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

  Widget _buildSuccessState() {
    return Column(
      children: [
        // Success circle
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
          '¡Tu reserva ha sido\nconfirmada!',
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
          'Todo está listo para tu evento en Residence.',
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
      child: Column(
        children: [
          // Image
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Image.asset('assets/images/confirm_salon.png', fit: BoxFit.cover),
          ),
          // Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Salón Social Principal',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 24, fontWeight: FontWeight.w700, height: 32 / 24, color: _dark,
                  ),
                ),
                Text(
                  'Club House - Torre A',
                  style: GoogleFonts.dmSans(
                    fontSize: 16, fontWeight: FontWeight.w500, height: 24 / 16, color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                // Divider
                Container(height: 1, color: AppColors.borderLight),
                const SizedBox(height: 17),
                // Info grid
                Row(
                  children: [
                    Expanded(child: _buildInfoItem('assets/icons/confirm_calendar.svg', 18, 20, 'FECHA', '6 Nov, 2023')),
                    Expanded(child: _buildInfoItem('assets/icons/confirm_clock.svg', 20, 20, 'HORARIO', '10:00 AM -\n02:00 PM')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildInfoItem('assets/icons/confirm_people.svg', 22, 16, 'INVITADOS', '15 Personas')),
                    Expanded(child: _buildInfoItem('assets/icons/confirm_ref.svg', 20, 16, 'REF.', '#RES-48291')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String icon, double iconW, double iconH, String label, String value) {
    return Row(
      children: [
        SvgPicture.asset(icon, width: iconW, height: iconH),
        const SizedBox(width: 12),
        Column(
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
      ],
    );
  }

  Widget _buildQrSection() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0x0DEC5B13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x4DEC5B13),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Código de acceso para invitados',
              style: GoogleFonts.dmSans(
                fontSize: 16, fontWeight: FontWeight.w700, height: 24 / 16, color: _dark,
              ),
            ),
          ),
          // QR Code
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Color(0x0D000000), blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: Image.asset('assets/images/qr_code.png', width: 160, height: 160),
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            'Puedes compartir este código con tus\ninvitados para agilizar su ingreso en la\nportería principal.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 14, fontWeight: FontWeight.w400, height: 20 / 14, color: _bodyText,
            ),
          ),
          const SizedBox(height: 12),
          // Share button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/confirm_share.svg', width: 10.5, height: 11.667),
              const SizedBox(width: 8),
              Text(
                'Compartir con invitados',
                style: GoogleFonts.dmSans(
                  fontSize: 14, fontWeight: FontWeight.w700, height: 20 / 14, color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          // Download button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Color(0x1A000000), blurRadius: 15, offset: Offset(0, 10), spreadRadius: -3),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/confirm_download.svg', width: 16, height: 16),
                const SizedBox(width: 8),
                Text(
                  'Descargar Comprobante',
                  style: GoogleFonts.dmSans(
                    fontSize: 16, fontWeight: FontWeight.w700, height: 24 / 16, color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Back to home button
          GestureDetector(
            onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: Container(
              width: double.infinity,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Center(
                child: Text(
                  'Volver al Inicio',
                  style: GoogleFonts.dmSans(
                    fontSize: 16, fontWeight: FontWeight.w700, height: 24 / 16, color: const Color(0xFF334155),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final items = [
      {'icon': 'assets/icons/cnav_home.svg', 'label': 'INICIO', 'active': false, 'w': 16.0, 'h': 18.0},
      {'icon': 'assets/icons/cnav_reservas.svg', 'label': 'RESERVAS', 'active': true, 'w': 18.0, 'h': 20.0},
      {'icon': 'assets/icons/cnav_visitas.svg', 'label': 'VISITAS', 'active': false, 'w': 24.0, 'h': 12.0},
      {'icon': 'assets/icons/cnav_perfil.svg', 'label': 'PERFIL', 'active': false, 'w': 16.0, 'h': 16.0},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 13,
        bottom: 12 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          final isActive = item['active'] as bool;
          final color = isActive ? AppColors.primary : const Color(0xFF94A3B8);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                item['icon'] as String,
                width: item['w'] as double,
                height: item['h'] as double,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              const SizedBox(height: 4),
              Text(
                item['label'] as String,
                style: GoogleFonts.dmSans(
                  fontSize: 10, fontWeight: FontWeight.w500, height: 15 / 10,
                  letterSpacing: -0.5, color: color,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
