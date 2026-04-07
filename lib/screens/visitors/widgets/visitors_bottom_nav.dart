import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class VisitorsBottomNav extends StatelessWidget {
  const VisitorsBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SizedBox(
        height: 73,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Nav items row
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    iconAsset: 'assets/icons/vnav_home.svg',
                    iconWidth: 16,
                    iconHeight: 18,
                    label: 'INICIO',
                    isActive: true,
                  ),
                  _NavItem(
                    iconAsset: 'assets/icons/vnav_personal.svg',
                    iconWidth: 20,
                    iconHeight: 20,
                    label: 'PERSONAL',
                    isActive: false,
                  ),
                  // Spacer for FAB
                  const SizedBox(width: 56),
                  _NavItem(
                    iconAsset: 'assets/icons/vnav_alerts.svg',
                    iconWidth: 16,
                    iconHeight: 20,
                    label: 'ALERTAS',
                    isActive: false,
                  ),
                  _NavItem(
                    iconAsset: 'assets/icons/vnav_settings.svg',
                    iconWidth: 20.1,
                    iconHeight: 20,
                    label: 'AJUSTES',
                    isActive: false,
                  ),
                ],
              ),
            ),
            // Centered FAB
            Positioned(
              left: 0,
              right: 0,
              top: -24,
              child: Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.background,
                      width: 4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66EC5B13),
                        blurRadius: 15,
                        offset: Offset(0, 10),
                        spreadRadius: -3,
                      ),
                      BoxShadow(
                        color: Color(0x66EC5B13),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/vnav_plus.svg',
                      width: 14,
                      height: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String iconAsset;
  final double iconWidth;
  final double iconHeight;
  final String label;
  final bool isActive;

  const _NavItem({
    required this.iconAsset,
    required this.iconWidth,
    required this.iconHeight,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : const Color(0xFF94A3B8);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
          child: Center(
            child: SvgPicture.asset(
              iconAsset,
              width: iconWidth,
              height: iconHeight,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.publicSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            height: 15 / 10,
            letterSpacing: 0.5,
            color: color,
          ),
        ),
      ],
    );
  }
}
