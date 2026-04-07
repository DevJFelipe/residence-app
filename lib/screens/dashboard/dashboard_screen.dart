import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../login/login_screen.dart';
import 'widgets/stat_card.dart';
import 'widgets/collections_chart.dart';
import 'widgets/quick_action_button.dart';
import 'widgets/activity_item.dart';
import 'widgets/visitors_table.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _showMenu(BuildContext context) {
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
                // Handle
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                // Header
                Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('AD', style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14,
                        )),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Administrador', style: GoogleFonts.publicSans(
                          fontSize: 16, fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        )),
                        Text('admin@residence.com', style: GoogleFonts.publicSans(
                          fontSize: 13, fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        )),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(height: 1, color: AppColors.borderLight),
                const SizedBox(height: 8),
                // Logout
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFEF4444),
                    size: 22,
                  ),
                  title: Text('Cerrar sesión', style: GoogleFonts.publicSans(
                    fontSize: 15, fontWeight: FontWeight.w600,
                    color: const Color(0xFFEF4444),
                  )),
                  onTap: () {
                    Navigator.of(ctx).pop(); // close sheet
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(),
                  const SizedBox(height: 32),
                  _buildStatsCards(),
                  const SizedBox(height: 32),
                  const CollectionsChart(),
                  const SizedBox(height: 32),
                  _buildQuickActionsAndFeed(),
                  const SizedBox(height: 32),
                  const VisitorsTable(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          bottom: BorderSide(color: AppColors.divider),
        ),
      ),
      child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Menu + Logo
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _showMenu(context),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SvgPicture.asset(
                        'assets/icons/menu.svg',
                        width: 18,
                        height: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Residence',
                    style: AppTextStyles.heading3.copyWith(fontSize: 18),
                  ),
                ],
              ),
              // Right: Bell + Divider + Button
              Row(
                children: [
                  // Bell with notification dot
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: 16,
                      height: 20,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/bell.svg',
                            width: 16,
                            height: 20,
                          ),
                          Positioned(
                            top: 0,
                            right: -2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Divider
                  Container(
                    width: 1,
                    height: 32,
                    color: AppColors.divider,
                  ),
                  const SizedBox(width: 16),
                  // Orange button with plus
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/plus.svg',
                      width: 10.5,
                      height: 10.5,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ],
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

  Widget _buildStatsCards() {
    return Column(
      children: [
        StatCard(
          iconAsset: 'assets/icons/stat_units.svg',
          iconWidth: 34,
          iconHeight: 34,
          label: 'Total Unidades',
          value: '240',
          changeText: '+2%',
          isPositive: true,
        ),
        const SizedBox(height: 24),
        StatCard(
          iconAsset: 'assets/icons/stat_residents.svg',
          iconWidth: 38,
          iconHeight: 32,
          label: 'Residentes Activos',
          value: '856',
          changeText: '+5%',
          isPositive: true,
        ),
        const SizedBox(height: 24),
        StatCard(
          iconAsset: 'assets/icons/stat_payments.svg',
          iconWidth: 35,
          iconHeight: 34,
          label: 'Pagos Pendientes',
          value: '\$12.4M',
          changeText: '-8%',
          isPositive: false,
        ),
        const SizedBox(height: 24),
        StatCard(
          iconAsset: 'assets/icons/stat_pqrs.svg',
          iconWidth: 20,
          iconHeight: 34,
          label: 'PQRS Abiertos',
          value: '14',
          changeText: '-12%',
          isPositive: false,
        ),
      ],
    );
  }

  Widget _buildQuickActionsAndFeed() {
    return Column(
      children: [
        _buildQuickActions(),
        const SizedBox(height: 32),
        _buildRecentActivity(),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(25),
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
                label: 'Agregar\nResidente',
                isPrimary: true,
              ),
              QuickActionButton(
                iconAsset: 'assets/icons/action_register_visitor.svg',
                iconWidth: 25,
                iconHeight: 25,
                label: 'Registrar\nVisitante',
                isPrimary: true,
              ),
              QuickActionButton(
                iconAsset: 'assets/icons/action_announcement.svg',
                iconWidth: 25,
                iconHeight: 20,
                label: 'Enviar Anuncio',
              ),
              QuickActionButton(
                iconAsset: 'assets/icons/action_billing.svg',
                iconWidth: 22.5,
                iconHeight: 25,
                label: 'Generar Cobros',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(25),
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
          Text('Actividad Reciente', style: AppTextStyles.heading3),
          const SizedBox(height: 16),
          const ActivityItem(
            iconBackground: AppColors.activityPaymentBg,
            iconAsset: 'assets/icons/activity_payment.svg',
            iconSize: 11.667,
            title: 'Pago Recibido - Apto 402',
            time: 'Hace 15 min',
          ),
          const SizedBox(height: 16),
          const ActivityItem(
            iconBackground: AppColors.activityVisitorBg,
            iconAsset: 'assets/icons/activity_visitor.svg',
            iconSize: 9.333,
            title: 'Visitante Registrado - Torre B',
            time: 'Hace 45 min',
          ),
          const SizedBox(height: 16),
          const ActivityItem(
            iconBackground: AppColors.activityPqrsBg,
            iconAsset: 'assets/icons/activity_pqrs.svg',
            iconSize: 10.5,
            title: 'Nueva PQRS - Daño Ascensor',
            time: 'Hace 2 horas',
          ),
          const SizedBox(height: 16),
          // "Ver todo el historial" button
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Ver todo el historial',
                style: AppTextStyles.bold14.copyWith(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
