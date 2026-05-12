import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:residence_app/core/api_client.dart';
import 'package:residence_app/core/session_manager.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_decorations.dart';
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
    final local = dt.toLocal();
    final weekdays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${weekdays[local.weekday - 1]}, ${local.day} ${months[local.month - 1]}';
  }

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    final hour = local.hour > 12 ? local.hour - 12 : (local.hour == 0 ? 12 : local.hour);
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${local.minute.toString().padLeft(2, '0')} $period';
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Buenos días';
    if (h < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceWarm,
      child: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!,
                            style: GoogleFonts.publicSans(
                                color: AppColors.textMutedWarm)),
                        const SizedBox(height: 12),
                        TextButton(
                            onPressed: _load,
                            child: const Text('Reintentar')),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _load,
                    color: AppColors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWelcomeHeader(),
                          const SizedBox(height: 28),
                          _buildMiniStatCards(),
                          if (_pendingInvoices.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            _buildNextPaymentCard(),
                          ],
                          if (_upcomingBookings.isNotEmpty) ...[
                            const SizedBox(height: 32),
                            _buildUpcomingReservations(),
                          ],
                          if (_notifications.isNotEmpty) ...[
                            const SizedBox(height: 32),
                            _buildNotifications(),
                          ],
                          const SizedBox(height: 32),
                          _buildQuickActions(),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                    spreadRadius: -4,
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/welcome_logo.svg',
                  width: 19,
                  height: 19,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Residence',
              style: GoogleFonts.publicSans(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: AppColors.textDarkWarm,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          '${_greeting()},',
          style: GoogleFonts.publicSans(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.textMutedWarm,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$_userName.',
          style: GoogleFonts.publicSans(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 1.15,
            letterSpacing: -0.5,
            color: AppColors.textDarkWarm,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStatCards() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _MiniStatCard(
              icon: Icons.receipt_long_rounded,
              label: 'Pagos pendientes',
              value: '${_pendingInvoices.length}',
              statusColor: _pendingInvoices.isEmpty
                  ? AppColors.success
                  : AppColors.warning,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _MiniStatCard(
              icon: Icons.event_available_rounded,
              label: 'Reservas activas',
              value: '${_upcomingBookings.length}',
              statusColor: AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _MiniStatCard(
              icon: Icons.assignment_rounded,
              label: 'PQRS abiertas',
              value: '$_openPqrsCount',
              statusColor: _openPqrsCount == 0
                  ? AppColors.success
                  : AppColors.warning,
            ),
          ),
        ],
      ),
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
      decoration: AppDecorations.premiumCard(radius: 20),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Container(
            width: 6,
            height: 140,
            color: AppColors.primary,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PRÓXIMO PAGO',
                    style: GoogleFonts.publicSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$chargeType${period.isNotEmpty ? ' · $period' : ''}',
                    style: GoogleFonts.publicSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMutedWarm,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatCurrency(amount),
                    style: GoogleFonts.publicSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                      color: AppColors.textDarkWarm,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  if (dueDate.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 13,
                          color: AppColors.textMutedWarm,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Vence · $dueDate',
                          style: GoogleFonts.publicSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMutedWarm,
                          ),
                        ),
                      ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Reservas próximas'),
        const SizedBox(height: 14),
        SizedBox(
          height: 168,
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
                status: b.bookingStatusName,
                isApproved: b.isAprobada,
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
        _SectionHeader(title: 'Notificaciones recientes'),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: AppDecorations.premiumCard(radius: 16),
          child: Column(
            children: List.generate(_notifications.length, (i) {
              final n = _notifications[i];
              final title = n['title'] ?? 'Notificación';
              final body = n['body'] ?? n['message'] ?? '';
              final createdAt = n['created_at'];
              return Column(
                children: [
                  if (i > 0)
                    Divider(
                      height: 24,
                      thickness: 1,
                      color: AppColors.borderSubtle,
                    ),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: AppDecorations.iconTile(
                          tint: AppColors.primary,
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title.toString(),
                              style: GoogleFonts.publicSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDarkWarm,
                              ),
                            ),
                            if (body.toString().isNotEmpty)
                              Text(
                                body.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.publicSans(
                                  fontSize: 12,
                                  color: AppColors.textMutedWarm,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (createdAt != null)
                        Text(
                          _formatDate(createdAt.toString()),
                          style: GoogleFonts.publicSans(
                            fontSize: 11,
                            color: AppColors.textMutedWarm,
                          ),
                        ),
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
        _SectionHeader(title: 'Acciones rápidas'),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.calendar_month_rounded,
                label: 'Reservar área',
                subtitle: 'Espacios comunes',
                tint: AppColors.primary,
                onTap: () => widget.onSwitchTab?.call(1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.event_available_rounded,
                label: 'Mis reservas',
                subtitle: 'Historial y próximas',
                tint: AppColors.success,
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
                subtitle: 'Registra tus invitados',
                tint: const Color(0xFF8B5CF6),
                onTap: () => widget.onSwitchTab?.call(3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.assignment_rounded,
                label: 'Mis PQRS',
                subtitle: 'Consulta y crea',
                tint: AppColors.warning,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UserPqrsScreen(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.publicSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.3,
        color: AppColors.textDarkWarm,
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color statusColor;

  const _MiniStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: AppDecorations.premiumCard(radius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: AppDecorations.iconTile(tint: statusColor),
            child: Icon(icon, size: 17, color: statusColor),
          ),
          const SizedBox(height: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.publicSans(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  letterSpacing: -0.8,
                  color: AppColors.textDarkWarm,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.publicSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                  letterSpacing: 0.1,
                  color: AppColors.textMutedWarm,
                ),
              ),
            ],
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
  final String? status;
  final bool isApproved;

  const _ReservationPreviewCard({
    required this.title,
    required this.date,
    required this.time,
    this.status,
    this.isApproved = false,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = isApproved ? AppColors.success : AppColors.warning;
    return Container(
      width: 208,
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.premiumCard(
        color: AppColors.surfaceWarmElevated,
        radius: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: AppDecorations.iconTile(tint: AppColors.primary),
                child: const Icon(
                  Icons.event_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              if (status != null) ...[
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    status!,
                    style: GoogleFonts.publicSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      color: badgeColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.publicSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.25,
              letterSpacing: -0.3,
              color: AppColors.textDarkWarm,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            date,
            style: GoogleFonts.publicSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textMutedWarm,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            time,
            style: GoogleFonts.publicSans(
              fontSize: 12,
              color: AppColors.textMutedWarm,
              fontFeatures: const [FontFeature.tabularFigures()],
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
  final String subtitle;
  final Color tint;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.tint,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 124,
        decoration: AppDecorations.premiumCard(radius: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: AppDecorations.iconTile(tint: tint),
                  child: Icon(icon, size: 20, color: tint),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ],
            ),
            const Spacer(),
            Text(
              label,
              style: GoogleFonts.publicSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
                color: AppColors.textDarkWarm,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.publicSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textMutedWarm,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
