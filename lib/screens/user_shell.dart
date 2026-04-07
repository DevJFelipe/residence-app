import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'amenities/amenities_screen.dart';
import 'amenities/my_reservations_screen.dart';

class UserShell extends StatefulWidget {
  const UserShell({super.key});

  @override
  State<UserShell> createState() => _UserShellState();
}

class _UserShellState extends State<UserShell> {
  static const Color _accent = Color(0xFFC2783A);
  static const Color _inactive = Color(0xFF4A5568);

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _UserHomeScreen(),
          AmenitiesScreen(embedded: true),
          MyReservationsScreen(embedded: true),
          _UserProfilePlaceholder(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final items = [
      _NavItem(icon: 'assets/icons/area_nav_home.svg', label: 'Inicio', w: 16, h: 18),
      _NavItem(icon: 'assets/icons/area_nav_areas.svg', label: 'Áreas', w: 19.3, h: 19.3),
      _NavItem(icon: 'assets/icons/area_nav_reservas.svg', label: 'Reservas', w: 18, h: 20),
      _NavItem(icon: 'assets/icons/area_nav_perfil.svg', label: 'Perfil', w: 16, h: 16),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFF0F1B2D).withValues(alpha: 0.1)),
        ),
      ),
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 9,
        bottom: 24 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isActive = index == _currentIndex;
          final color = isActive ? _accent : _inactive;
          return GestureDetector(
            onTap: () => setState(() => _currentIndex = index),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  item.icon,
                  width: item.w,
                  height: item.h,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: GoogleFonts.publicSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 15 / 10,
                    color: color,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final String icon;
  final String label;
  final double w;
  final double h;
  const _NavItem({required this.icon, required this.label, required this.w, required this.h});
}

// ── Placeholder screens for tabs that don't have dedicated screens yet ──

class _UserHomeScreen extends StatelessWidget {
  const _UserHomeScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.home_rounded, size: 64, color: Color(0xFFC2783A)),
              const SizedBox(height: 16),
              Text(
                'Bienvenido, Residente',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F1B2D),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Conjunto Residencial El Nogal',
                style: GoogleFonts.publicSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.6,
                  color: const Color(0xFFC2783A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'Explora las áreas comunes, revisa tus reservas y gestiona tu perfil desde la barra de navegación.',
                style: GoogleFonts.publicSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 22 / 14,
                  color: const Color(0xFF64748B),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserProfilePlaceholder extends StatelessWidget {
  const _UserProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'Perfil',
          style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold,
            color: Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
