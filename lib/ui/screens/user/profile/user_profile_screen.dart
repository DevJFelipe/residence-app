import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/api_client.dart';
import 'package:residence_app/core/session_manager.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_text_styles.dart';
import 'package:residence_app/models/auth_models.dart';
import 'package:residence_app/screens/login/login_screen.dart';
import 'package:residence_app/screens/profile/change_password_screen.dart';
import 'package:residence_app/ui/screens/user/pqrs/user_pqrs_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String _name = '';
  String _email = '';
  String _initials = '?';
  String? _phone;
  String? _document;
  UserProperty? _property;
  String _roleName = 'Residente';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Try /auth/me first, fallback to cached session
    Map<String, dynamic>? userData;
    try {
      final resp = await ApiClient().dio.get('/api/v1/auth/me');
      userData = resp.data['data'];
    } catch (_) {
      userData = await SessionManager().getUser();
    }

    if (userData == null || !mounted) return;

    final String name =
        (userData['full_name'] ?? '').toString().trim();
    final String email = (userData['email'] ?? '').toString();
    final initials = name.isNotEmpty
        ? name
            .split(' ')
            .where((w) => w.isNotEmpty)
            .take(2)
            .map((w) => w[0].toUpperCase())
            .join()
        : '?';

    UserProperty? prop;
    final props = userData['properties'] as List?;
    if (props != null && props.isNotEmpty) {
      prop = UserProperty.fromJson(Map<String, dynamic>.from(props.first));
    }

    String role = 'Residente';
    final condos = userData['condominiums'] as List?;
    if (condos != null && condos.isNotEmpty) {
      final first = condos.first;
      if (first is Map) {
        role = (first['role_name'] ?? first['role'] ?? 'Residente').toString();
      }
    }

    setState(() {
      _name = name;
      _email = email;
      _initials = initials;
      _phone = userData?['phone']?.toString();
      _document = userData?['document_number']?.toString();
      _property = prop;
      _roleName = role;
      _loading = false;
    });
  }

  Future<void> _logout() async {
    await SessionManager().clear();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SafeArea(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 24),
              if (_property != null) ...[
                _buildUnitInfoCard(),
                const SizedBox(height: 24),
              ],
              _buildPersonalInfoCard(),
              const SizedBox(height: 24),
              _buildMenuSection(context, 'Gestiones', [
                _MenuItem(Icons.assignment_rounded, 'Mis PQRS',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const UserPqrsScreen()))),
              ]),
              const SizedBox(height: 24),
              _buildMenuSection(context, 'Mi Cuenta', [
                _MenuItem(Icons.lock_outline_rounded, 'Cambiar contraseña',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ChangePasswordScreen()))),
              ]),
              const SizedBox(height: 24),
              Text(
                'Residence v1.0.0',
                style: GoogleFonts.publicSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              _initials,
              style: GoogleFonts.publicSans(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _name,
          style: GoogleFonts.publicSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _email,
          style: GoogleFonts.publicSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        if (_property != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _property!.displayName,
              style: GoogleFonts.publicSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUnitInfoCard() {
    final prop = _property!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mi Unidad',
          style: GoogleFonts.publicSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
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
            children: [
              if (prop.block != null && prop.block!.isNotEmpty) ...[
                _infoRow('Bloque/Torre', prop.block!),
                const Divider(height: 20, color: AppColors.borderLight),
              ],
              _infoRow('Unidad', prop.propertyNumber),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Información Personal',
          style: GoogleFonts.publicSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
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
            children: [
              _infoRow('Nombre', _name),
              const Divider(height: 20, color: AppColors.borderLight),
              _infoRow('Email', _email),
              if (_phone != null && _phone!.isNotEmpty) ...[
                const Divider(height: 20, color: AppColors.borderLight),
                _infoRow('Teléfono', _phone!),
              ],
              if (_document != null && _document!.isNotEmpty) ...[
                const Divider(height: 20, color: AppColors.borderLight),
                _infoRow('Documento', _document!),
              ],
              const Divider(height: 20, color: AppColors.borderLight),
              _infoRow('Rol', _roleName),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.semiBold14,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(
      BuildContext context, String title, List<_MenuItem> items) {
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
                  GestureDetector(
                    onTap: item.onTap,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Icon(item.icon,
                              size: 20, color: AppColors.textSecondary),
                          const SizedBox(width: 16),
                          Expanded(
                            child:
                                Text(item.title, style: AppTextStyles.medium14),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: _logout,
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
  final VoidCallback? onTap;
  const _MenuItem(this.icon, this.title, {this.onTap});
}
