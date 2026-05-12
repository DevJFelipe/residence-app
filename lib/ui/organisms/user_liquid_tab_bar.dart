import 'dart:io' show Platform;

import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class UserLiquidTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const UserLiquidTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color _accent = Color(0xFFC2783A);
  static const Color _inactive = Color(0xFF4A5568);

  static const List<_TabDef> _tabs = [
    _TabDef(
      label: 'Inicio',
      sfSymbol: 'house.fill',
      svg: 'assets/icons/area_nav_home.svg',
      svgW: 16,
      svgH: 18,
    ),
    _TabDef(
      label: 'Áreas',
      sfSymbol: 'square.grid.2x2.fill',
      svg: 'assets/icons/area_nav_areas.svg',
      svgW: 19.3,
      svgH: 19.3,
    ),
    _TabDef(
      label: 'Reservas',
      sfSymbol: 'calendar',
      svg: 'assets/icons/area_nav_reservas.svg',
      svgW: 18,
      svgH: 20,
    ),
    _TabDef(
      label: 'Visitantes',
      sfSymbol: 'person.2.fill',
      svg: 'assets/icons/visitor_active_list.svg',
      svgW: 20,
      svgH: 12,
    ),
    _TabDef(
      label: 'Perfil',
      sfSymbol: 'person.crop.circle.fill',
      svg: 'assets/icons/area_nav_perfil.svg',
      svgW: 16,
      svgH: 16,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CNTabBar(
        items: [
          for (final t in _tabs)
            CNTabBarItem(label: t.label, icon: CNSymbol(t.sfSymbol)),
        ],
        currentIndex: currentIndex,
        onTap: onTap,
        tint: _accent,
      );
    }
    return _buildFallback(context);
  }

  Widget _buildFallback(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0x1A0F1B2D)),
        ),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 9,
        bottom: 24 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_tabs.length, (index) {
          final t = _tabs[index];
          final isActive = index == currentIndex;
          final color = isActive ? _accent : _inactive;
          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  t.svg,
                  width: t.svgW,
                  height: t.svgH,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
                const SizedBox(height: 4),
                Text(
                  t.label,
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

class _TabDef {
  final String label;
  final String sfSymbol;
  final String svg;
  final double svgW;
  final double svgH;

  const _TabDef({
    required this.label,
    required this.sfSymbol,
    required this.svg,
    required this.svgW,
    required this.svgH,
  });
}
