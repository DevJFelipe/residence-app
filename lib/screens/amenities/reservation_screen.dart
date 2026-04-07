import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'confirmation_screen.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  static const Color _bg = Color(0xFFF7F4EF);
  static const Color _dark = Color(0xFF0F1B2D);
  static const Color _accent = Color(0xFFC2783A);
  static const Color _bodyText = Color(0xFF475569);

  int _selectedDay = 6;
  int _selectedTimeSlot = 0;
  int _guestCount = 15;
  bool _termsAccepted = false;

  final _dayHeaders = ['DOM', 'LUN', 'MAR', 'MIE', 'JUE', 'VIE', 'SAB'];

  // Nov 2023 starts on Wed, so first row: 29(prev),30(prev),1,2,3,4,5 / 6,7,8,9,10,11,12
  final _calendarRows = [
    [29, 30, 1, 2, 3, 4, 5],
    [6, 7, 8, 9, 10, 11, 12],
  ];
  final _prevMonthDays = {29, 30};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 57),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 128),
                  child: Column(
                    children: [
                      _buildSummaryCard(),
                      const SizedBox(height: 16),
                      _buildDatePicker(),
                      _buildTimeSlots(),
                      _buildGuestCounter(),
                      _buildTermsSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildHeader(context),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: _bg.withValues(alpha: 0.8),
              border: Border(
                bottom: BorderSide(color: _accent.withValues(alpha: 0.1)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/reserv_back.svg',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Text(
                        'Reservar Salón Social',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.publicSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 22.5 / 18,
                          letterSpacing: -0.45,
                          color: _dark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _accent.withValues(alpha: 0.05)),
          boxShadow: const [
            BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DETALLES DEL ÁREA',
                    style: GoogleFonts.publicSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 16 / 12,
                      letterSpacing: 0.6,
                      color: _accent,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Salón Social Principal',
                    style: GoogleFonts.publicSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 22.5 / 18,
                      color: _dark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/reserv_capacity.svg', width: 14, height: 7),
                      const SizedBox(width: 6),
                      Text(
                        'Capacidad: 50 personas',
                        style: GoogleFonts.publicSans(
                          fontSize: 14, fontWeight: FontWeight.w400, height: 20 / 14, color: _bodyText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/salon_thumb.png',
                width: 96,
                height: 96,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selecciona la fecha',
                style: GoogleFonts.publicSans(
                  fontSize: 18, fontWeight: FontWeight.w700, height: 28 / 18, letterSpacing: -0.45, color: _dark,
                ),
              ),
              Text(
                'Noviembre 2023',
                style: GoogleFonts.publicSans(
                  fontSize: 14, fontWeight: FontWeight.w500, height: 20 / 14, color: _accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Calendar card
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _accent.withValues(alpha: 0.05)),
              boxShadow: const [
                BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
              ],
            ),
            child: Column(
              children: [
                // Day headers
                Row(
                  children: _dayHeaders.map((d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: GoogleFonts.publicSans(
                          fontSize: 11, fontWeight: FontWeight.w700, height: 16.5 / 11, color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 8),
                // Calendar rows
                ..._calendarRows.map((row) => SizedBox(
                  height: 40,
                  child: Row(
                    children: row.map((day) {
                      final isPrev = _prevMonthDays.contains(day) && row == _calendarRows.first;
                      final isSelected = day == _selectedDay && !isPrev;
                      final isToday = day == 2 && !isPrev;

                      Color textColor = _dark;
                      if (isPrev) textColor = const Color(0xFFCBD5E1);

                      return Expanded(
                        child: GestureDetector(
                          onTap: isPrev ? null : () => setState(() => _selectedDay = day),
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _accent
                                    : isToday
                                        ? _accent.withValues(alpha: 0.1)
                                        : null,
                                shape: BoxShape.circle,
                                border: isToday && !isSelected
                                    ? Border.all(color: _accent.withValues(alpha: 0.2))
                                    : null,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: _accent.withValues(alpha: 0.2),
                                          blurRadius: 6,
                                          offset: const Offset(0, 4),
                                          spreadRadius: -1,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  '$day',
                                  style: GoogleFonts.publicSans(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : isToday
                                            ? FontWeight.w500
                                            : FontWeight.w400,
                                    height: 20 / 14,
                                    color: isSelected ? Colors.white : textColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlots() {
    final slots = [
      {'time': '10:00 AM - 02:00 PM', 'label': 'Turno Mañana'},
      {'time': '04:00 PM - 08:00 PM', 'label': 'Turno Tarde'},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Horarios disponibles',
            style: GoogleFonts.publicSans(
              fontSize: 18, fontWeight: FontWeight.w700, height: 28 / 18, letterSpacing: -0.45, color: _dark,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(slots.length, (index) {
            final slot = slots[index];
            final isSelected = _selectedTimeSlot == index;
            return Padding(
              padding: EdgeInsets.only(bottom: index < slots.length - 1 ? 12 : 0),
              child: GestureDetector(
                onTap: () => setState(() => _selectedTimeSlot = index),
                child: Container(
                  height: 76,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: isSelected ? _accent.withValues(alpha: 0.05) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? _accent : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? null
                        : const [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            slot['time']!,
                            style: GoogleFonts.publicSans(
                              fontSize: 16, fontWeight: FontWeight.w700, height: 24 / 16, color: _dark,
                            ),
                          ),
                          Text(
                            slot['label']!,
                            style: GoogleFonts.publicSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 16 / 12,
                              color: isSelected ? _accent : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      SvgPicture.asset(
                        isSelected ? 'assets/icons/reserv_check.svg' : 'assets/icons/reserv_circle.svg',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGuestCounter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Número de invitados',
            style: GoogleFonts.publicSans(
              fontSize: 18, fontWeight: FontWeight.w700, height: 28 / 18, letterSpacing: -0.45, color: _dark,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _accent.withValues(alpha: 0.05)),
              boxShadow: const [
                BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
              ],
            ),
            child: Row(
              children: [
                // Minus
                GestureDetector(
                  onTap: () {
                    if (_guestCount > 1) setState(() => _guestCount--);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: SvgPicture.asset('assets/icons/reserv_minus.svg', width: 14, height: 2),
                    ),
                  ),
                ),
                // Count
                Expanded(
                  child: Center(
                    child: Text(
                      '$_guestCount',
                      style: GoogleFonts.publicSans(
                        fontSize: 20, fontWeight: FontWeight.w700, height: 28 / 20, color: _dark,
                      ),
                    ),
                  ),
                ),
                // Plus
                GestureDetector(
                  onTap: () {
                    if (_guestCount < 50) setState(() => _guestCount++);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _accent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: _accent.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                          spreadRadius: -3,
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset('assets/icons/reserv_plus.svg', width: 14, height: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          // Checkbox + terms
          GestureDetector(
            onTap: () => setState(() => _termsAccepted = !_termsAccepted),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _termsAccepted ? _accent : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _termsAccepted ? _accent : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: _termsAccepted
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Acepto el reglamento de uso de áreas comunes y me hago responsable de cualquier daño.',
                    style: GoogleFonts.publicSans(
                      fontSize: 14, fontWeight: FontWeight.w400, height: 19.25 / 14, color: _bodyText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Info banner
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              border: Border(left: BorderSide(color: _accent, width: 4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/icons/reserv_info.svg', width: 20, height: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información de pago',
                        style: GoogleFonts.publicSans(
                          fontSize: 14, fontWeight: FontWeight.w600, height: 20 / 14, color: _dark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'El costo de la reserva será cargado automáticamente a su próximo recibo de mantenimiento.',
                        style: GoogleFonts.publicSans(
                          fontSize: 12, fontWeight: FontWeight.w400, height: 16 / 12, color: _bodyText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              16, 17, 16, 16 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              border: Border(top: BorderSide(color: _accent.withValues(alpha: 0.1))),
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ConfirmationScreen()),
              ),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _accent.withValues(alpha: 0.3),
                      blurRadius: 25,
                      offset: const Offset(0, 20),
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Confirmar Reserva',
                    style: GoogleFonts.publicSans(
                      fontSize: 16, fontWeight: FontWeight.w700, height: 24 / 16, color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/icons/reserv_confirm.svg', width: 19, height: 20),
                ],
              ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
