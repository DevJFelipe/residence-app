import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'amenities/amenities_screen.dart';
import 'amenities/my_reservations_screen.dart';
import 'package:residence_app/ui/screens/user/home/user_home_screen.dart';
import 'package:residence_app/ui/screens/user/profile/user_profile_screen.dart';

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
          UserHomeScreen(),
          AmenitiesScreen(embedded: true),
          MyReservationsScreen(embedded: true),
          UserProfileScreen(),
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

