import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/session_manager.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_text_styles.dart';
import 'package:residence_app/screens/admin/admin_profile_screen.dart';
import 'package:residence_app/screens/admin/announcements_screen.dart';
import 'package:residence_app/screens/admin/condo_info_screen.dart';
import 'package:residence_app/screens/admin/notifications_screen.dart';
import 'package:residence_app/screens/amenities/amenities_screen.dart';
import 'package:residence_app/screens/login/login_screen.dart';
import 'package:residence_app/screens/visitors/visitors_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  String _userName = 'Administrador';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await SessionManager().getUser();
    if (!mounted || user == null) return;
    setState(() {
      _userName = (user['full_name'] ?? '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}').toString().trim();
      _userEmail = user['email'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: 20),
                  _buildSection(context, 'Gestionar', [
                    _MenuItem(Icons.people_alt_rounded, 'Visitantes',
                        () => _push(context, const VisitorsScreen())),
                    _MenuItem(Icons.pool_rounded, 'Áreas comunes',
                        () => _push(context, const AmenitiesScreen())),
                    _MenuItem(Icons.campaign_rounded, 'Anuncios',
                        () => _push(context, const AnnouncementsScreen())),
                  ]),
                  const SizedBox(height: 24),
                  _buildSection(context, 'Configuración', [
                    _MenuItem(Icons.settings_rounded, 'Datos del conjunto',
                        () => _push(context, const CondoInfoScreen())),
                    _MenuItem(Icons.notifications_rounded, 'Notificaciones',
                        () => _push(context, const NotificationsScreen())),
                  ]),
                  const SizedBox(height: 24),
                  _buildSection(context, 'Cuenta', [
                    _MenuItem(Icons.person_rounded, 'Mi perfil',
                        () => _push(context, const AdminProfileScreen())),
                  ]),
                  const SizedBox(height: 32),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Más opciones',
              style: GoogleFonts.publicSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 28 / 20,
                letterSpacing: -0.5,
                color: AppColors.textDark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final initials = _userName.isNotEmpty
        ? _userName
            .split(' ')
            .where((w) => w.isNotEmpty)
            .take(2)
            .map((w) => w[0].toUpperCase())
            .join()
        : 'AD';

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              initials,
              style: GoogleFonts.publicSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _userName,
              style: GoogleFonts.publicSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            if (_userEmail.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                _userEmail,
                style: GoogleFonts.publicSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.publicSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
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
            children: List.generate(items.length, (index) {
              final item = items[index];
              return Column(
                children: [
                  if (index > 0)
                    const Divider(
                      height: 1,
                      indent: 52,
                      color: AppColors.borderLight,
                    ),
                  _buildMenuRow(context, item),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuRow(BuildContext context, _MenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(item.icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: AppTextStyles.medium14,
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () async {
          await SessionManager().clear();
          if (!context.mounted) return;
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFECACA)),
            color: AppColors.errorBackground,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Cerrar sesión',
                  style: GoogleFonts.publicSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _MenuItem(this.icon, this.title, this.onTap);
}
