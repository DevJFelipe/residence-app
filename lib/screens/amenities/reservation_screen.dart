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

  static const int _maxHours = 3;

  DateTime _selectedDate = DateTime.now();
  late DateTime _currentMonth;
  final Set<int> _selectedSlots = <int>{};
  int _guestCount = 1;
  bool _termsAccepted = false;
  bool _isSubmitting = false;
  String? _error;
  int _selectedTurn = 0; // 0: Mañana, 1: Tarde, 2: Noche

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
        final local = b.startTime.toLocal();
        final sameDay = local.year == _selectedDate.year &&
            local.month == _selectedDate.month &&
            local.day == _selectedDate.day;
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
    if (_selectedSlots.isEmpty) {
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

    final sortedIndices = _selectedSlots.toList()..sort();
    final firstSlot = _timeSlots[sortedIndices.first];
    final lastSlot = _timeSlots[sortedIndices.last];
    final startHour = int.parse(firstSlot['start']!);
    final endHour = int.parse(lastSlot['end']!);
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
                      if (_selectedSlots.isNotEmpty) _buildSelectionSummary(),
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
                                        _selectedSlots.clear();
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

  int _turnOfSlot(Map<String, String> slot) {
    final h = int.parse(slot['start']!);
    if (h < 12) return 0;
    if (h < 18) return 1;
    return 2;
  }

  int get _maxSelectable {
    final m = widget.amenity.maxHours;
    return m < _maxHours ? m : _maxHours;
  }

  void _toggleSlot(int index) {
    setState(() {
      _error = null;
      if (_selectedSlots.isEmpty) {
        _selectedSlots.add(index);
        return;
      }
      if (_selectedSlots.contains(index)) {
        final sorted = _selectedSlots.toList()..sort();
        // Allow removing only from edges to keep the range contiguous
        if (index == sorted.first || index == sorted.last) {
          _selectedSlots.remove(index);
        }
        return;
      }
      final sorted = _selectedSlots.toList()..sort();
      final first = sorted.first;
      final last = sorted.last;
      final isAdjacent = index == first - 1 || index == last + 1;
      final wouldExceed = _selectedSlots.length >= _maxSelectable;
      if (!isAdjacent || wouldExceed) {
        _selectedSlots
          ..clear()
          ..add(index);
        return;
      }
      _selectedSlots.add(index);
    });
  }

  Widget _buildTimeSlots2() {
    final slots = _timeSlots;

    // Auto-pick a turn that has slots, if current selection is empty
    final turnCounts = [0, 0, 0];
    for (final s in slots) {
      turnCounts[_turnOfSlot(s)]++;
    }
    var effectiveTurn = _selectedTurn;
    if (turnCounts[effectiveTurn] == 0) {
      for (var i = 0; i < 3; i++) {
        if (turnCounts[i] > 0) {
          effectiveTurn = i;
          break;
        }
      }
    }

    final visibleSlots = <MapEntry<int, Map<String, String>>>[];
    for (var i = 0; i < slots.length; i++) {
      if (_turnOfSlot(slots[i]) == effectiveTurn) {
        visibleSlots.add(MapEntry(i, slots[i]));
      }
    }

    const turnLabels = ['Mañana', 'Tarde', 'Noche'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  'Horarios disponibles',
                  style: GoogleFonts.publicSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 28 / 18,
                    letterSpacing: -0.45,
                    color: _dark,
                  ),
                ),
              ),
              Text(
                'Toca para elegir · hasta $_maxSelectable h',
                style: GoogleFonts.publicSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: _bodyText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Segmented control
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0x14000000),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: List.generate(3, (i) {
                final isActive = i == effectiveTurn;
                final isEmpty = turnCounts[i] == 0;
                return Expanded(
                  child: GestureDetector(
                    onTap: isEmpty
                        ? null
                        : () => setState(() {
                              _selectedTurn = i;
                              _selectedSlots.clear();
                            }),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isActive
                            ? const [
                                BoxShadow(
                                  color: Color(0x14000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        turnLabels[i],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.publicSans(
                          fontSize: 13,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isEmpty
                              ? const Color(0xFFCBD5E1)
                              : isActive
                                  ? _dark
                                  : _bodyText,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 14),
          if (_loadingSlots)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else if (visibleSlots.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No hay horarios en este turno',
                  style: GoogleFonts.publicSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _bodyText,
                  ),
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.4,
              ),
              itemCount: visibleSlots.length,
              itemBuilder: (_, i) {
                final entry = visibleSlots[i];
                final originalIndex = entry.key;
                final slot = entry.value;
                final startH = int.parse(slot['start']!);
                final endH = int.parse(slot['end']!);
                final isOccupied = _isSlotOccupied(startH, endH);
                final isSelected = _selectedSlots.contains(originalIndex);
                final start = _formatHour(startH);
                final end = _formatHour(endH);
                return GestureDetector(
                  onTap: isOccupied ? null : () => _toggleSlot(originalIndex),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    decoration: BoxDecoration(
                      color: isOccupied
                          ? const Color(0xFFF1F5F9)
                          : isSelected
                              ? _accent
                              : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isOccupied
                            ? const Color(0xFFE2E8F0)
                            : isSelected
                                ? _accent
                                : const Color(0x14000000),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: _accent.withValues(alpha: 0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                                spreadRadius: -2,
                              ),
                            ]
                          : isOccupied
                              ? null
                              : const [
                                  BoxShadow(
                                    color: Color(0x0A000000),
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          start,
                          style: GoogleFonts.publicSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: isOccupied
                                ? const Color(0xFF94A3B8)
                                : isSelected
                                    ? Colors.white
                                    : _dark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isOccupied ? 'Ocupado' : end,
                          style: GoogleFonts.publicSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isOccupied
                                ? const Color(0xFFEF4444)
                                : isSelected
                                    ? Colors.white.withValues(alpha: 0.85)
                                    : _bodyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSelectionSummary() {
    final sorted = _selectedSlots.toList()..sort();
    final first = _timeSlots[sorted.first];
    final last = _timeSlots[sorted.last];
    final startHour = int.parse(first['start']!);
    final endHour = int.parse(last['end']!);
    final duration = _selectedSlots.length;
    final atLimit = duration >= _maxSelectable;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _accent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _accent.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.schedule_rounded, size: 18, color: _accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$duration ${duration == 1 ? 'hora' : 'horas'} seleccionada${duration == 1 ? '' : 's'}',
                    style: GoogleFonts.publicSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                      color: _accent,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_formatHour(startHour)} → ${_formatHour(endHour)}',
                    style: GoogleFonts.publicSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: _dark,
                    ),
                  ),
                  if (atLimit) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Máximo por reserva',
                      style: GoogleFonts.publicSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: _bodyText,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _selectedSlots.clear()),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: _bodyText,
                ),
              ),
            ),
          ],
        ),
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
      child: GestureDetector(
        onTap: () => setState(() => _termsAccepted = !_termsAccepted),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _termsAccepted
                ? _accent.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _termsAccepted
                  ? _accent.withValues(alpha: 0.35)
                  : const Color(0x14000000),
              width: _termsAccepted ? 1.5 : 1,
            ),
            boxShadow: _termsAccepted
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: _termsAccepted ? _accent : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _termsAccepted ? _accent : const Color(0xFFCBD5E1),
                    width: 1.5,
                  ),
                ),
                child: _termsAccepted
                    ? const Icon(Icons.check_rounded,
                        size: 18, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Acepto el reglamento de áreas comunes',
                  style: GoogleFonts.publicSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                    color: _termsAccepted ? _dark : _dark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final canSubmit =
        _termsAccepted && _selectedSlots.isNotEmpty && !_isSubmitting;
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
