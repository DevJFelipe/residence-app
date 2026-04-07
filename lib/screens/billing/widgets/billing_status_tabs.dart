import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class _TabData {
  final String label;
  final String count;
  final Color? countBg;
  final Color? countColor;

  const _TabData({
    required this.label,
    required this.count,
    this.countBg,
    this.countColor,
  });
}

class BillingStatusTabs extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int>? onTap;

  const BillingStatusTabs({
    super.key,
    this.activeIndex = 0,
    this.onTap,
  });

  static const List<_TabData> _tabs = [
    _TabData(label: 'Todos', count: '154'),
    _TabData(
      label: 'Pagado',
      count: '98',
      countBg: Color(0x1A10B981),
      countColor: Color(0xFF059669),
    ),
    _TabData(
      label: 'Pendiente',
      count: '42',
      countBg: Color(0x1AF59E0B),
      countColor: Color(0xFFD97706),
    ),
    _TabData(
      label: 'Vencido',
      count: '14',
      countBg: Color(0x1AF43F5E),
      countColor: Color(0xFFE11D48),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 69,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final tab = _tabs[index];
            final isActive = index == activeIndex;
            return Padding(
              padding: EdgeInsets.only(right: index < _tabs.length - 1 ? 8 : 0),
              child: GestureDetector(
                onTap: () => onTap?.call(index),
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tab.label,
                        style: GoogleFonts.publicSans(
                          fontSize: 14,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                          height: 20 / 14,
                          color: isActive
                              ? Colors.white
                              : const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.white.withValues(alpha: 0.2)
                              : (tab.countBg ?? AppColors.borderLight),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          tab.count,
                          style: GoogleFonts.publicSans(
                            fontSize: 12,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                            height: 16 / 12,
                            color: isActive
                                ? Colors.white
                                : (tab.countColor ?? const Color(0xFF475569)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
