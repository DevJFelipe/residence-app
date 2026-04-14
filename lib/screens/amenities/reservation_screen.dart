import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/session_manager.dart';
import 'package:residence_app/models/amenity_models.dart';
import 'package:residence_app/models/auth_models.dart';
import 'package:residence_app/services/amenities_service.dart';
import 'confirmation_screen.dart';

class ReservationScreen extends StatefulWidget {
  final Amenity amenity;
  const ReservationScreen({super.key, required this.amenity});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  static const Color _bg = Color(0xFFF7F4EF);
  static const Color _dark = Color(0xFF0F1B2D);
  static const Color _accent = Color(0xFFC2783A);
  static const Color _bodyText = Color(0xFF475569);

  final _service = AmenitiesService();

  DateTime _selectedDate = DateTime.now();
  late DateTime _currentMonth;
  int _selectedTimeSlot = -1;
  int _guestCount = 1;
  bool _termsAccepted = false;
  bool _isSubmitting = false;
  String? _error;

  // User's property for booking
  UserProperty? _userProperty;

  // Existing bookings for the selected date (to mark occupied slots)
  List<Booking> _existingBookings = [];
  bool _loadingSlots = false;

  final _dayHeaders = ['DOM', 'LUN', 'MAR', 'MIE', 'JUE', 'VIE', 'SAB'];

  // Generate time slots based on amenity availability
  List<Map<String, String>> get _timeSlots {
    final from = widget.amenity.availableFrom;
    final until = widget.amenity.availableUntil;
    final minH = widget.amenity.minHours;

    if (from != null && until != null) {
      final fromParts = from.split(':');
      final untilParts = until.split(':');
      final startHour = int.parse(fromParts[0]);
      final endHour = int.parse(untilParts[0]);

      final slots = <Map<String, String>>[];
      for (var h = startHour; h + minH <= endHour; h += minH) {
        final end = h + minH;
        slots.add({
          'time': '${_formatHour(h)} - ${_formatHour(end)}',
          'label': h < 12 ? 'Turno Mañana' : 'Turno Tarde',
          'start': '$h',
          'end': '$end',
        });
      }
      return slots;
    }

    // Default slots if no availability info
    return [
      {'time': '08:00 AM - 12:00 PM', 'label': 'Turno Mañana', 'start': '8', 'end': '12'},
      {'time': '02:00 PM - 06:00 PM', 'label': 'Turno Tarde', 'start': '14', 'end': '18'},
      {'time': '06:00 PM - 10:00 PM', 'label': 'Turno Noche', 'start': '18', 'end': '22'},
    ];
  }

  String _formatHour(int hour) {
    final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final period = hour >= 12 ? 'PM' : 'AM';
    return '${h.toString().padLeft(2, '0')}:00 $period';
  }

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
    _loadUserProperty();
    _loadBookingsForDate();
  }

  Future<void> _loadUserProperty() async {
    final userData = await SessionManager().getUser();
    if (userData != null && mounted) {
      final user = LoginResponse.fromJson(userData);
      if (user.properties.isNotEmpty) {
        setState(() => _userProperty = user.properties.first);
      }
    }
  }

  Future<void> _loadBookingsForDate() async {
    setState(() => _loadingSlots = true);
    try {
      final bookings = await _service.getBookings(
        amenityId: widget.amenity.id,
      );
      if (!mounted) return;
      // Filter bookings for the selected date that are active (pendiente=1, aprobada=2)
      final dateBookings = bookings.where((b) {
        final sameDay = b.startTime.year == _selectedDate.year &&
            b.startTime.month == _selectedDate.month &&
            b.startTime.day == _selectedDate.day;
        return sameDay && (b.bookingStatusId == 1 || b.bookingStatusId == 2);
      }).toList();
      setState(() {
        _existingBookings = dateBookings;
        _loadingSlots = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingSlots = false);
    }
  }

  bool _isSlotOccupied(int startHour, int endHour) {
    final slotStart = DateTime(
      _selectedDate.year, _selectedDate.month, _selectedDate.day, startHour,
    );
    final slotEnd = DateTime(
      _selectedDate.year, _selectedDate.month, _selectedDate.day, endHour,
    );
    for (final b in _existingBookings) {
      if (b.startTime.isBefore(slotEnd) && b.endTime.isAfter(slotStart)) {
        return true;
      }
    }
    return false;
  }

  List<List<int?>> _buildCalendarGrid() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final startWeekday = firstDay.weekday % 7; // 0=Sun

    final grid = <List<int?>>[];
    var row = List<int?>.filled(7, null);

    var day = 1;
    for (var i = startWeekday; i < 7 && day <= lastDay.day; i++) {
      row[i] = day++;
    }
    grid.add(row);

    while (day <= lastDay.day) {
      row = List<int?>.filled(7, null);
      for (var i = 0; i < 7 && day <= lastDay.day; i++) {
        row[i] = day++;
      }
      grid.add(row);
    }
    return grid;
  }

  bool _isDateInPast(int day) {
    final date = DateTime(_currentMonth.year, _currentMonth.month, day);
    final today = DateTime.now();
    return date.isBefore(DateTime(today.year, today.month, today.day));
  }

  Future<void> _submitBooking() async {
    if (_selectedTimeSlot < 0) {
      setState(() => _error = 'Selecciona un horario');
      return;
    }
    if (!_termsAccepted) {
      setState(() => _error = 'Debes aceptar el reglamento');
      return;
    }
    if (_userProperty == null) {
      setState(() => _error = 'No tienes una propiedad asignada');
      return;
    }

    final slot = _timeSlots[_selectedTimeSlot];
    final startHour = int.parse(slot['start']!);
    final endHour = int.parse(slot['end']!);
    final startTime = DateTime(
      _selectedDate.year, _selectedDate.month, _selectedDate.day,
      startHour,
    );
    final endTime = DateTime(
      _selectedDate.year, _selectedDate.month, _selectedDate.day,
      endHour,
    );

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final booking = await _service.createBooking(
        amenityId: widget.amenity.id,
        propertyId: _userProperty!.propertyId,
        startTime: startTime,
        endTime: endTime,
        notes: 'Invitados: $_guestCount',
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ConfirmationScreen(
            booking: booking,
            amenityName: widget.amenity.name,
          ),
        ),
      );
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AmenitiesService.parseError(e);
        _isSubmitting = false;
      });
    }
  }

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
                      _buildTimeSlots2(),
                      _buildGuestCounter(),
                      if (_error != null) _buildError(),
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

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0x1AEF4444),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0x33EF4444)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, size: 18, color: Color(0xFFEF4444)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _error!,
                style: GoogleFonts.publicSans(
                  fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFFEF4444),
                ),
              ),
            ),
          ],
        ),
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
                        'Reservar ${widget.amenity.name}',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
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
    final amenity = widget.amenity;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DETALLES DEL ÁREA',
              style: GoogleFonts.publicSans(
                fontSize: 12, fontWeight: FontWeight.w600, height: 16 / 12,
                letterSpacing: 0.6, color: _accent,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              amenity.name,
              style: GoogleFonts.publicSans(
                fontSize: 18, fontWeight: FontWeight.w700, height: 22.5 / 18, color: _dark,
              ),
            ),
            const SizedBox(height: 4),
            if (amenity.capacity != null)
              Row(
                children: [
                  SvgPicture.asset('assets/icons/reserv_capacity.svg', width: 14, height: 7),
                  const SizedBox(width: 6),
                  Text(
                    'Capacidad: ${amenity.capacity} personas',
                    style: GoogleFonts.publicSans(
                      fontSize: 14, fontWeight: FontWeight.w400, height: 20 / 14, color: _bodyText,
                    ),
                  ),
                ],
              ),
            if (amenity.hourlyCost > 0) ...[
              const SizedBox(height: 4),
              Text(
                '\$${amenity.hourlyCost.toStringAsFixed(0)}/hora',
                style: GoogleFonts.publicSans(
                  fontSize: 14, fontWeight: FontWeight.w600, color: _accent,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
    ];
    final grid = _buildCalendarGrid();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selecciona la fecha',
                style: GoogleFonts.publicSans(
                  fontSize: 18, fontWeight: FontWeight.w700, height: 28 / 18,
                  letterSpacing: -0.45, color: _dark,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentMonth = DateTime(
                          _currentMonth.year, _currentMonth.month - 1,
                        );
                      });
                    },
                    child: const Icon(Icons.chevron_left, color: _accent),
                  ),
                  Text(
                    '${months[_currentMonth.month - 1]} ${_currentMonth.year}',
                    style: GoogleFonts.publicSans(
                      fontSize: 14, fontWeight: FontWeight.w500, height: 20 / 14,
                      color: _accent,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentMonth = DateTime(
                          _currentMonth.year, _currentMonth.month + 1,
                        );
                      });
                    },
                    child: const Icon(Icons.chevron_right, color: _accent),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                Row(
                  children: _dayHeaders
                      .map((d) => Expanded(
                            child: Center(
                              child: Text(
                                d,
                                style: GoogleFonts.publicSans(
                                  fontSize: 11, fontWeight: FontWeight.w700,
                                  height: 16.5 / 11,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                ...grid.map((row) => SizedBox(
                      height: 40,
                      child: Row(
                        children: row.map((day) {
                          if (day == null) {
                            return const Expanded(child: SizedBox());
                          }
                          final isPast = _isDateInPast(day);
                          final isSelected = day == _selectedDate.day &&
                              _currentMonth.month == _selectedDate.month &&
                              _currentMonth.year == _selectedDate.year;
                          final today = DateTime.now();
                          final isToday = day == today.day &&
                              _currentMonth.month == today.month &&
                              _currentMonth.year == today.year;

                          return Expanded(
                            child: GestureDetector(
                              onTap: isPast
                                  ? null
                                  : () {
                                      setState(() {
                                        _selectedDate = DateTime(
                                          _currentMonth.year,
                                          _currentMonth.month,
                                          day,
                                        );
                                        _selectedTimeSlot = -1;
                                      });
                                      _loadBookingsForDate();
                                    },
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
                                            : FontWeight.w400,
                                        height: 20 / 14,
                                        color: isSelected
                                            ? Colors.white
                                            : isPast
                                                ? const Color(0xFFCBD5E1)
                                                : _dark,
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

  Widget _buildTimeSlots2() {
    final slots = _timeSlots;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Horarios disponibles',
            style: GoogleFonts.publicSans(
              fontSize: 18, fontWeight: FontWeight.w700, height: 28 / 18,
              letterSpacing: -0.45, color: _dark,
            ),
          ),
          const SizedBox(height: 16),
          if (_loadingSlots)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )),
            )
          else
            ...List.generate(slots.length, (index) {
              final slot = slots[index];
              final startH = int.parse(slot['start']!);
              final endH = int.parse(slot['end']!);
              final isOccupied = _isSlotOccupied(startH, endH);
              final isSelected = _selectedTimeSlot == index;
              return Padding(
                padding: EdgeInsets.only(bottom: index < slots.length - 1 ? 12 : 0),
                child: GestureDetector(
                  onTap: isOccupied ? null : () => setState(() => _selectedTimeSlot = index),
                  child: Opacity(
                    opacity: isOccupied ? 0.5 : 1.0,
                    child: Container(
                      height: 76,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: isOccupied
                            ? const Color(0xFFF1F5F9)
                            : isSelected
                                ? _accent.withValues(alpha: 0.05)
                                : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isOccupied
                              ? const Color(0xFFE2E8F0)
                              : isSelected ? _accent : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: isSelected || isOccupied
                            ? null
                            : const [
                                BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
                              ],
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
                                  fontSize: 16, fontWeight: FontWeight.w700, height: 24 / 16,
                                  color: isOccupied ? const Color(0xFF94A3B8) : _dark,
                                ),
                              ),
                              Text(
                                isOccupied ? 'Ocupado' : slot['label']!,
                                style: GoogleFonts.publicSans(
                                  fontSize: 12, fontWeight: FontWeight.w500, height: 16 / 12,
                                  color: isOccupied
                                      ? const Color(0xFFEF4444)
                                      : isSelected ? _accent : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          if (isOccupied)
                            const Icon(Icons.block_rounded, size: 20, color: Color(0xFFEF4444))
                          else
                            SvgPicture.asset(
                              isSelected
                                  ? 'assets/icons/reserv_check.svg'
                                  : 'assets/icons/reserv_circle.svg',
                              width: 20,
                              height: 20,
                            ),
                        ],
                      ),
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
    final maxGuests = widget.amenity.capacity ?? 50;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Número de invitados',
            style: GoogleFonts.publicSans(
              fontSize: 18, fontWeight: FontWeight.w700, height: 28 / 18,
              letterSpacing: -0.45, color: _dark,
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
                GestureDetector(
                  onTap: () {
                    if (_guestCount < maxGuests) setState(() => _guestCount++);
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
                        widget.amenity.hourlyCost > 0
                            ? 'El costo de la reserva será cargado automáticamente a su próximo recibo de mantenimiento.'
                            : 'Esta área no tiene costo de reserva.',
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
    final canSubmit = _termsAccepted && _selectedTimeSlot >= 0 && !_isSubmitting;
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
              onTap: canSubmit ? _submitBooking : null,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: canSubmit ? _accent : _accent.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: canSubmit
                      ? [
                          BoxShadow(
                            color: _accent.withValues(alpha: 0.3),
                            blurRadius: 25,
                            offset: const Offset(0, 20),
                            spreadRadius: -5,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isSubmitting)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    else ...[
                      Text(
                        'Confirmar Reserva',
                        style: GoogleFonts.publicSans(
                          fontSize: 16, fontWeight: FontWeight.w700, height: 24 / 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset('assets/icons/reserv_confirm.svg', width: 19, height: 20),
                    ],
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
