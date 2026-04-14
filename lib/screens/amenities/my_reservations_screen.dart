import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/models/amenity_models.dart';
import 'package:residence_app/services/amenities_service.dart';
import '../../theme/app_colors.dart';

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

  final _service = AmenitiesService();
  List<Booking> _bookings = [];
  bool _isLoading = true;
  String? _error;
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final bookings = await _service.getMyBookings();
      if (!mounted) return;
      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AmenitiesService.parseError(e);
        _isLoading = false;
      });
    }
  }

  List<Booking> get _filteredBookings {
    if (_activeTab == 0) {
      // Próximas: pendiente or aprobada
      return _bookings.where((b) => b.isUpcoming).toList();
    } else {
      // Historial: finalizada, cancelada, rechazada, or past
      return _bookings.where((b) => !b.isUpcoming).toList();
    }
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    return '${dt.day} ${months[dt.month - 1]}, ${dt.year}';
  }

  String _formatTime(DateTime start, DateTime end) {
    String fmt(DateTime dt) {
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    return '${fmt(start)} - ${fmt(end)}';
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredBookings;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadBookings,
              color: _accent,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.error_outline,
                                    size: 48,
                                    color: _dark.withValues(alpha: 0.3)),
                                const SizedBox(height: 16),
                                Text(_error!,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.dmSans(
                                        color: const Color(0xFF64748B))),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: _loadBookings,
                                  child: const Text('Reintentar'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : filtered.isEmpty
                          ? ListView(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: Center(
                                    child: Text(
                                      _activeTab == 0
                                          ? 'No tienes reservas próximas'
                                          : 'No tienes historial de reservas',
                                      style: GoogleFonts.dmSans(
                                          color: const Color(0xFF64748B)),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 49),
                              itemCount: filtered.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) =>
                                  _buildCard(filtered[index]),
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
      decoration: BoxDecoration(
        color: _bg,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          children: [
            Row(
              children: [
                if (!widget.embedded)
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset('assets/icons/myres_back.svg',
                          width: 16, height: 16),
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Mis Reservas',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 32 / 24,
                        color: _dark,
                      ),
                    ),
                  ),
                ),
                // Spacer to balance the back button on the left
                const SizedBox(width: 32),
              ],
            ),
            const SizedBox(height: 16),
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

  Widget _buildCard(Booking booking) {
    final isFinished = booking.isFinalizada || booking.isCancelada || booking.isRechazada;

    late Color badgeBg;
    late Color badgeText;
    late String badgeLabel;

    if (booking.isAprobada) {
      badgeBg = const Color(0xFFDCFCE7);
      badgeText = const Color(0xFF15803D);
      badgeLabel = 'APROBADA';
    } else if (booking.isPendiente) {
      badgeBg = const Color(0xFFFEF3C7);
      badgeText = const Color(0xFFB45309);
      badgeLabel = 'PENDIENTE';
    } else if (booking.isFinalizada) {
      badgeBg = const Color(0xFFE2E8F0);
      badgeText = const Color(0xFF475569);
      badgeLabel = 'FINALIZADA';
    } else if (booking.isCancelada) {
      badgeBg = const Color(0xFFFEE2E2);
      badgeText = const Color(0xFFDC2626);
      badgeLabel = 'CANCELADA';
    } else if (booking.isRechazada) {
      badgeBg = const Color(0xFFFEE2E2);
      badgeText = const Color(0xFFDC2626);
      badgeLabel = 'RECHAZADA';
    } else {
      badgeBg = const Color(0xFFE2E8F0);
      badgeText = const Color(0xFF475569);
      badgeLabel = booking.bookingStatusName?.toUpperCase() ?? 'DESCONOCIDO';
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
            BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 2,
                offset: Offset(0, 1)),
          ],
        ),
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
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 15 / 10,
                  color: badgeText,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Title
            Text(
              booking.amenityName ?? 'Reserva',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 25 / 20,
                color: _dark,
              ),
            ),
            const SizedBox(height: 4),
            // Date
            Row(
              children: [
                SvgPicture.asset('assets/icons/myres_calendar.svg',
                    width: 10.5, height: 11.667),
                const SizedBox(width: 4),
                Text(
                  _formatDate(booking.startTime),
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            // Time
            Row(
              children: [
                SvgPicture.asset('assets/icons/myres_clock.svg',
                    width: 11.667, height: 11.667),
                const SizedBox(width: 4),
                Text(
                  _formatTime(booking.startTime, booking.endTime),
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            if (booking.totalCost > 0) ...[
              const SizedBox(height: 4),
              Text(
                'Costo: \$${booking.totalCost.toStringAsFixed(0)}',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _accent,
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Detail button
            GestureDetector(
              onTap: () => _showDetail(booking),
              child: Container(
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
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 16 / 12,
                    letterSpacing: 0.6,
                    color: isFinished ? _dark : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(Booking booking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  booking.amenityName ?? 'Reserva',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 32 / 24,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 16),
                _detailRow(Icons.calendar_today,
                    'Fecha: ${_formatDate(booking.startTime)}'),
                const SizedBox(height: 8),
                _detailRow(Icons.access_time,
                    'Horario: ${_formatTime(booking.startTime, booking.endTime)}'),
                const SizedBox(height: 8),
                _detailRow(Icons.info_outline,
                    'Estado: ${booking.bookingStatusName?.toUpperCase() ?? "N/A"}'),
                if (booking.totalCost > 0) ...[
                  const SizedBox(height: 8),
                  _detailRow(Icons.attach_money,
                      'Costo: \$${booking.totalCost.toStringAsFixed(0)}'),
                ],
                if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _detailRow(Icons.note_outlined, 'Notas: ${booking.notes}'),
                ],
                const SizedBox(height: 24),
                if (booking.isUpcoming)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _confirmCancel(ctx, booking),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Cancelar reserva',
                          style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                if (booking.isUpcoming) const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _dark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cerrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext sheetCtx, Booking booking) {
    showDialog(
      context: sheetCtx,
      builder: (ctx) => AlertDialog(
        title: Text('Cancelar reserva',
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w700, color: _dark)),
        content: Text(
          '¿Estás seguro de que deseas cancelar esta reserva?',
          style: GoogleFonts.publicSans(color: const Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('No',
                style: GoogleFonts.publicSans(color: const Color(0xFF64748B))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop(); // close dialog
              Navigator.of(sheetCtx).pop(); // close bottom sheet
              try {
                await _service.cancelBooking(booking.id);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Reserva cancelada',
                        style: GoogleFonts.publicSans(
                            fontWeight: FontWeight.w500)),
                    backgroundColor: const Color(0xFF10B981),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                );
                _loadBookings();
              } on DioException catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AmenitiesService.parseError(e),
                        style: GoogleFonts.publicSans(
                            fontWeight: FontWeight.w500)),
                    backgroundColor: const Color(0xFFEF4444),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                );
              }
            },
            child: Text('Sí, cancelar',
                style: GoogleFonts.publicSans(
                    color: const Color(0xFFEF4444),
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: GoogleFonts.dmSans(
                  fontSize: 14, color: const Color(0xFF64748B))),
        ),
      ],
    );
  }
}
