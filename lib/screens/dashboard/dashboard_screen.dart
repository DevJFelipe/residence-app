import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../core/api_client.dart';
import '../../services/dashboard_service.dart';
import '../../models/dashboard_models.dart';
import 'widgets/stat_card.dart';
import 'widgets/quick_action_button.dart';
import 'widgets/visitors_table.dart';

class DashboardScreen extends StatefulWidget {
  final void Function(int)? onSwitchTab;

  const DashboardScreen({super.key, this.onSwitchTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _dashboardService = DashboardService();
  final _dio = ApiClient().dio;
  DashboardSummary? _summary;
  List<Map<String, dynamic>> _notifications = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        _dashboardService.getSummary(),
        _dio.get('/api/v1/notifications/me'),
      ]);
      if (!mounted) return;
      setState(() {
        _summary = results[0] as DashboardSummary;
        final notifResp = results[1] as dynamic;
        _notifications = List<Map<String, dynamic>>.from(notifResp.data['data'])
            .take(5)
            .toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      // Try loading just the dashboard summary if notifications fail
      try {
        final summary = await _dashboardService.getSummary();
        if (!mounted) return;
        setState(() {
          _summary = summary;
          _loading = false;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _error = 'No se pudo cargar el dashboard';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : _error != null
                  ? _buildError()
                  : RefreshIndicator(
                      onRefresh: _loadDashboard,
                      color: AppColors.primary,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildWelcomeSection(),
                              const SizedBox(height: 24),
                              _buildStatsCards(),
                              const SizedBox(height: 24),
                              _buildQuickActions(),
                              const SizedBox(height: 24),
                              _buildRecentNotifications(),
                              const SizedBox(height: 24),
                              VisitorsTable(visitors: _summary!.activeVisitors),
                            ],
                          ),
                        ),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error!, style: AppTextStyles.bodyLarge),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadDashboard,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Reintentar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Residence',
              style: AppTextStyles.heading3.copyWith(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Panel de Administración', style: AppTextStyles.heading2),
        Text(
          'Bienvenido de nuevo. Aquí tienes un\nresumen de hoy en la copropiedad.',
          style: AppTextStyles.bodyLarge,
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(0)}K';
    }
    return '\$${amount.toStringAsFixed(0)}';
  }

  Widget _buildStatsCards() {
    final stats = _summary!.stats;
    return Column(
      children: [
        StatCard(
          iconAsset: 'assets/icons/stat_units.svg',
          iconWidth: 34,
          iconHeight: 34,
          label: 'Total Unidades',
          value: '${stats.totalUnits}',
        ),
        const SizedBox(height: 16),
        StatCard(
          iconAsset: 'assets/icons/stat_residents.svg',
          iconWidth: 38,
          iconHeight: 32,
          label: 'Residentes Activos',
          value: '${stats.activeResidents}',
        ),
        const SizedBox(height: 16),
        StatCard(
          iconAsset: 'assets/icons/stat_payments.svg',
          iconWidth: 35,
          iconHeight: 34,
          label: 'Pagos Pendientes',
          value: _formatCurrency(stats.pendingPayments),
        ),
        const SizedBox(height: 16),
        StatCard(
          iconAsset: 'assets/icons/stat_pqrs.svg',
          iconWidth: 20,
          iconHeight: 34,
          label: 'PQRS Abiertos',
          value: '${stats.openPqrs}',
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Acciones Rápidas', style: AppTextStyles.heading3),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.0,
            children: [
              QuickActionButton(
                iconAsset: 'assets/icons/action_add_resident.svg',
                iconWidth: 27.5,
                iconHeight: 20,
                label: 'Residentes',
                isPrimary: true,
                onTap: () => widget.onSwitchTab?.call(1),
              ),
              QuickActionButton(
                iconAsset: 'assets/icons/action_billing.svg',
                iconWidth: 22.5,
                iconHeight: 25,
                label: 'Pagos',
                isPrimary: true,
                onTap: () => widget.onSwitchTab?.call(2),
              ),
              QuickActionButton(
                iconAsset: 'assets/icons/activity_pqrs.svg',
                iconWidth: 20,
                iconHeight: 20,
                label: 'PQRS',
                onTap: () => widget.onSwitchTab?.call(3),
              ),
              QuickActionButton(
                iconAsset: 'assets/icons/action_announcement.svg',
                iconWidth: 25,
                iconHeight: 20,
                label: 'Más opciones',
                onTap: () => widget.onSwitchTab?.call(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentNotifications() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Notificaciones Recientes', style: AppTextStyles.heading3),
          const SizedBox(height: 16),
          if (_notifications.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text('Sin notificaciones recientes',
                    style: GoogleFonts.publicSans(fontSize: 13, color: Colors.grey)),
              ),
            )
          else
            ..._notifications.map((n) => _notificationTile(n)),
        ],
      ),
    );
  }

  Widget _notificationTile(Map<String, dynamic> n) {
    final title = n['title'] ?? '';
    final body = n['body'] ?? n['message'] ?? '';
    final isRead = n['is_read'] == true || n['read_at'] != null;
    final date = n['created_at'] != null ? DateTime.tryParse(n['created_at']) : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isRead ? Colors.grey.shade300 : AppColors.primary,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.publicSans(
                        fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                if (body.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(body,
                      style: GoogleFonts.publicSans(fontSize: 12, color: const Color(0xFF475569)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
                if (date != null) ...[
                  const SizedBox(height: 2),
                  Text('${date.day}/${date.month}/${date.year}',
                      style: GoogleFonts.publicSans(fontSize: 11, color: Colors.grey)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
