import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:residence_app/core/api_client.dart';
import 'package:residence_app/core/session_manager.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/models/amenity_models.dart';
import 'package:residence_app/services/amenities_service.dart';
import 'package:residence_app/services/billing_service.dart';
import 'package:residence_app/services/pqrs_service.dart';
import 'package:residence_app/ui/screens/user/pqrs/user_pqrs_screen.dart';

class UserHomeScreen extends StatefulWidget {
  final void Function(int)? onSwitchTab;

  const UserHomeScreen({super.key, this.onSwitchTab});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final _billingService = BillingService();
  final _amenitiesService = AmenitiesService();
  final _pqrsService = PqrsService();
  final _dio = ApiClient().dio;

  bool _loading = true;
  String? _error;

  String _userName = 'Residente';
  List<Map<String, dynamic>> _pendingInvoices = [];
  List<Booking> _upcomingBookings = [];
  int _openPqrsCount = 0;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final user = await SessionManager().getUser();
      _userName = (user?['full_name'] ?? user?['name'] ?? 'Residente')
          .toString()
          .split(' ')
          .first;

      // Each call independent so one failure doesn't block the rest
      List<Map<String, dynamic>> invoices = [];
      List<Booking> allBookings = [];
      List<Map<String, dynamic>> pqrs = [];
      List<Map<String, dynamic>> notifs = [];

      await Future.wait<void>([
        _billingService
            .getInvoices(paymentStatusCode: 'pending', limit: 5)
            .then((v) { invoices = v; })
            .catchError((_) {}),
        _amenitiesService
            .getMyBookings()
            .then((v) { allBookings = v; })
            .catchError((_) {}),
        _pqrsService
            .getPqrs(limit: 50)
            .then((v) { pqrs = v; })
            .catchError((_) {}),
        _dio
            .get('/api/v1/notifications/me')
            .then((r) { notifs =
                List<Map<String, dynamic>>.from(r.data['data'] ?? []); })
            .catchError((_) {}),
      ]);

      if (!mounted) return;

      final upcoming = allBookings.where((b) => b.isUpcoming).toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

      setState(() {
        _pendingInvoices = invoices;
        _upcomingBookings = upcoming.take(5).toList();
        _openPqrsCount = pqrs.length;
        _notifications = notifs.take(5).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  String _formatCurrency(dynamic amount) {
    final n = (amount is num) ? amount : double.tryParse('$amount') ?? 0;
    return '\$${n.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.')}';
  }

  String _formatDate(String? iso) {
    if (iso == null) return '';
    try {
      final d = DateTime.parse(iso);
      return DateFormat('d MMM yyyy', 'es').format(d);
    } catch (_) {
      return iso;
    }
  }

  String _formatBookingDate(DateTime dt) {
    final weekdays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${weekdays[dt.weekday - 1]}, ${dt.day} ${months[dt.month - 1]}';
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${dt.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!,
                          style: GoogleFonts.publicSans(color: Colors.grey)),
                      const SizedBox(height: 12),
                      TextButton(
                          onPressed: _load, child: const Text('Reintentar')),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeHeader(),
                        const SizedBox(height: 24),
                        _buildMiniStatCards(),
                        if (_pendingInvoices.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          _buildNextPaymentCard(),
                        ],
                        if (_upcomingBookings.isNotEmpty) ...[
                          const SizedBox(height: 28),
                          _buildUpcomingReservations(),
                        ],
                        if (_notifications.isNotEmpty) ...[
                          const SizedBox(height: 28),
                          _buildNotifications(),
                        ],
                        const SizedBox(height: 28),
                        _buildQuickActions(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bienvenido, $_userName',
          style: GoogleFonts.publicSans(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 32 / 24,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Residence',
          style: GoogleFonts.publicSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStatCards() {
    return Row(
      children: [
        Expanded(
          child: _MiniStatCard(
            label: 'Pagos\npendientes',
            value: '${_pendingInvoices.length}',
            color: _pendingInvoices.isEmpty
                ? AppColors.success
                : AppColors.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MiniStatCard(
            label: 'Reservas\nactivas',
            value: '${_upcomingBookings.length}',
            color: AppColors.info,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MiniStatCard(
            label: 'PQRS\nabiertas',
            value: '$_openPqrsCount',
            color: _openPqrsCount == 0 ? AppColors.success : AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildNextPaymentCard() {
    final inv = _pendingInvoices.first;
    final chargeType = inv['charge_type_name'] ?? 'Cuota';
    final amount = inv['total_amount'] ?? inv['balance'] ?? 0;
    final dueDate = _formatDate(inv['due_date']?.toString());
    final period = inv['billing_period_start'] != null
        ? _formatDate(inv['billing_period_start']?.toString())
        : '';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 110,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Próximo pago',
                    style: GoogleFonts.publicSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$chargeType${period.isNotEmpty ? ' - $period' : ''}',
                    style: GoogleFonts.publicSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatCurrency(amount),
                    style: GoogleFonts.publicSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  if (dueDate.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Vence: $dueDate',
                      style: GoogleFonts.publicSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingReservations() {
    final colors = [
      const Color(0xFFFFF7ED),
      const Color(0xFFEFF6FF),
      const Color(0xFFF0FDF4),
      const Color(0xFFFDF4FF),
    ];
    final iconColors = [
      AppColors.primary,
      AppColors.info,
      AppColors.success,
      const Color(0xFF8B5CF6),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reservas próximas',
            style: GoogleFonts.publicSans(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _upcomingBookings.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final b = _upcomingBookings[i];
              return _ReservationPreviewCard(
                title: b.amenityName ?? 'Área #${b.amenityId}',
                date: _formatBookingDate(b.startTime),
                time:
                    '${_formatTime(b.startTime)} - ${_formatTime(b.endTime)}',
                color: colors[i % colors.length],
                iconColor: iconColors[i % iconColors.length],
                status: b.bookingStatusName,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notificaciones recientes',
            style: GoogleFonts.publicSans(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: List.generate(_notifications.length, (i) {
              final n = _notifications[i];
              final title = n['title'] ?? 'Notificación';
              final body = n['body'] ?? n['message'] ?? '';
              final createdAt = n['created_at'];
              return Column(
                children: [
                  if (i > 0)
                    const Divider(height: 24, color: AppColors.borderLight),
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.notifications_outlined,
                            size: 18, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title.toString(),
                                style: GoogleFonts.publicSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark)),
                            if (body.toString().isNotEmpty)
                              Text(body.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.publicSans(
                                      fontSize: 12,
                                      color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      if (createdAt != null)
                        Text(_formatDate(createdAt.toString()),
                            style: GoogleFonts.publicSans(
                                fontSize: 11,
                                color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Acciones rápidas',
            style: GoogleFonts.publicSans(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.calendar_month_rounded,
                label: 'Reservar área',
                color: AppColors.info,
                bgColor: const Color(0xFFEFF6FF),
                onTap: () => widget.onSwitchTab?.call(1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.event_available_rounded,
                label: 'Mis reservas',
                color: AppColors.success,
                bgColor: const Color(0xFFF0FDF4),
                onTap: () => widget.onSwitchTab?.call(2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.people_alt_rounded,
                label: 'Visitantes',
                color: const Color(0xFF8B5CF6),
                bgColor: const Color(0xFFFDF4FF),
                onTap: () => widget.onSwitchTab?.call(3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.assignment_rounded,
                label: 'Mis PQRS',
                color: AppColors.warning,
                bgColor: const Color(0xFFFFFBEB),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const UserPqrsScreen()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
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
          Text(
            value,
            style: GoogleFonts.publicSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.publicSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.3,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReservationPreviewCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final Color color;
  final Color iconColor;
  final String? status;

  const _ReservationPreviewCard({
    required this.title,
    required this.date,
    required this.time,
    required this.color,
    required this.iconColor,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.event_rounded, size: 20, color: iconColor),
              ),
              if (status != null) ...[
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(status!,
                      style: GoogleFonts.publicSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: iconColor)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.publicSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: GoogleFonts.publicSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            time,
            style: GoogleFonts.publicSans(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 100,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.publicSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
