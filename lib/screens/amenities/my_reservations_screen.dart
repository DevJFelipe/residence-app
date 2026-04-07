import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

enum ReservationStatus { confirmada, pendiente, finalizada }

class _ReservationData {
  final ReservationStatus status;
  final String title;
  final String date;
  final String time;
  final String image;

  const _ReservationData({
    required this.status,
    required this.title,
    required this.date,
    required this.time,
    required this.image,
  });
}

class MyReservationsScreen extends StatefulWidget {
  final bool embedded;
  const MyReservationsScreen({super.key, this.embedded = false});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  static const Color _bg = Color(0xFFF7F4EF);
  static const Color _dark = Color(0xFF0F1B2D);
  static const Color _accent = Color(0xFFC2783A);

  int _activeTab = 0;

  static const List<_ReservationData> _reservations = [
    _ReservationData(
      status: ReservationStatus.confirmada,
      title: 'Salón Social',
      date: '15 Oct, 2023',
      time: '18:00 - 22:00',
      image: 'assets/images/reserv_salon.png',
    ),
    _ReservationData(
      status: ReservationStatus.pendiente,
      title: 'Cancha de Tenis',
      date: '18 Oct, 2023',
      time: '07:00 - 09:00',
      image: 'assets/images/reserv_tennis.png',
    ),
    _ReservationData(
      status: ReservationStatus.finalizada,
      title: 'Piscina Climatizada',
      date: '10 Oct, 2023',
      time: '14:00 - 16:00',
      image: 'assets/images/reserv_pool.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 49),
              itemCount: _reservations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) => _buildCard(_reservations[index]),
            ),
          ),
          if (!widget.embedded) _buildBottomNav(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: _bg,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          children: [
            // Title row
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset('assets/icons/myres_back.svg', width: 16, height: 16),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Mis Reservas',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 24, fontWeight: FontWeight.w700, height: 32 / 24, color: _dark,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset('assets/icons/myres_search.svg', width: 18, height: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Subtitle
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'CONJUNTO RESIDENCIAL EL NOGAL',
                style: GoogleFonts.dmSans(
                  fontSize: 14, fontWeight: FontWeight.w500, height: 20 / 14,
                  letterSpacing: 1.4, color: _accent,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Tabs
            Row(
              children: [
                _buildTab('Próximas', 0),
                _buildTab('Historial', 1),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          padding: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                height: 20 / 14,
                color: isActive ? AppColors.primary : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(_ReservationData reservation) {
    final isFinished = reservation.status == ReservationStatus.finalizada;

    late Color badgeBg;
    late Color badgeText;
    late String badgeLabel;

    switch (reservation.status) {
      case ReservationStatus.confirmada:
        badgeBg = const Color(0xFFDCFCE7);
        badgeText = const Color(0xFF15803D);
        badgeLabel = 'CONFIRMADA';
      case ReservationStatus.pendiente:
        badgeBg = const Color(0xFFFEF3C7);
        badgeText = const Color(0xFFB45309);
        badgeLabel = 'PENDIENTE';
      case ReservationStatus.finalizada:
        badgeBg = const Color(0xFFE2E8F0);
        badgeText = const Color(0xFF475569);
        badgeLabel = 'FINALIZADA';
    }

    return Opacity(
      opacity: isFinished ? 0.8 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: isFinished ? const Color(0x99FFFFFF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: const [
            BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      badgeLabel,
                      style: GoogleFonts.dmSans(
                        fontSize: 10, fontWeight: FontWeight.w700, height: 15 / 10, color: badgeText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Title
                  Text(
                    reservation.title,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 20, fontWeight: FontWeight.w700, height: 25 / 20, color: _dark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Date
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/myres_calendar.svg', width: 10.5, height: 11.667),
                      const SizedBox(width: 4),
                      Text(
                        reservation.date,
                        style: GoogleFonts.dmSans(
                          fontSize: 14, fontWeight: FontWeight.w400, height: 20 / 14, color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  // Time
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/myres_clock.svg', width: 11.667, height: 11.667),
                      const SizedBox(width: 4),
                      Text(
                        reservation.time,
                        style: GoogleFonts.dmSans(
                          fontSize: 14, fontWeight: FontWeight.w400, height: 20 / 14, color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Button
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isFinished ? 17 : 16,
                      vertical: isFinished ? 9 : 8,
                    ),
                    decoration: BoxDecoration(
                      color: isFinished ? null : _dark,
                      borderRadius: BorderRadius.circular(8),
                      border: isFinished ? Border.all(color: _dark) : null,
                    ),
                    child: Text(
                      'VER DETALLES',
                      style: GoogleFonts.dmSans(
                        fontSize: 12, fontWeight: FontWeight.w700, height: 16 / 12,
                        letterSpacing: 0.6, color: isFinished ? _dark : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ColorFiltered(
                colorFilter: isFinished
                    ? const ColorFilter.mode(Colors.white, BlendMode.saturation)
                    : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                child: Image.asset(
                  reservation.image,
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

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _dark,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: SizedBox(
        height: 112,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Nav items
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _navItem('assets/icons/mrnav_home.svg', 'INICIO', false, 16, 18),
                    _navItem('assets/icons/mrnav_reservas.svg', 'RESERVAS', true, 18, 20),
                    const SizedBox(width: 58), // FAB space
                    _navItem('assets/icons/mrnav_pagos.svg', 'PAGOS', false, 22, 16),
                    _navItem('assets/icons/mrnav_perfil.svg', 'PERFIL', false, 16, 16),
                  ],
                ),
              ),
            ),
            // FAB
            Positioned(
              left: 0,
              right: 0,
              top: -20,
              child: Center(
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: _dark, width: 4),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66EC5B13),
                        blurRadius: 15,
                        offset: Offset(0, 10),
                        spreadRadius: -3,
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset('assets/icons/mrnav_fab.svg', width: 20, height: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(String icon, String label, bool active, double w, double h) {
    final color = active ? Colors.white : const Color(0xFF94A3B8);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(icon, width: w, height: h, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 10, fontWeight: FontWeight.w500, height: 15 / 10,
            letterSpacing: -0.5, color: color,
          ),
        ),
      ],
    );
  }
}
