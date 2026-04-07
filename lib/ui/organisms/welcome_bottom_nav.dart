import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';

/// Data class for a welcome nav item.
class _WelcomeNavItem {
  final IconData icon;
  final String label;

  const _WelcomeNavItem({
    required this.icon,
    required this.label,
  });
}

/// The bottom navigation bar for the welcome/public
/// screen.
///
/// Displays three tabs: Explorar, Avisos, and Acceso.
/// Uses Material icons since the welcome flow has a
/// simpler icon set.
class WelcomeBottomNav extends StatelessWidget {
  /// Index of the currently active tab (0-based).
  final int currentIndex;

  /// Callback invoked with the tapped tab index.
  final ValueChanged<int>? onTap;

  const WelcomeBottomNav({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  static const List<_WelcomeNavItem> _items = [
    _WelcomeNavItem(
      icon: Icons.explore_outlined,
      label: 'Explorar',
    ),
    _WelcomeNavItem(
      icon: Icons.campaign_outlined,
      label: 'Avisos',
    ),
    _WelcomeNavItem(
      icon: Icons.qr_code_scanner_rounded,
      label: 'Acceso',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding =
        MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.xxxl,
        right: AppSpacing.xxxl,
        top: 9,
        bottom: AppSpacing.sm + bottomPadding,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: List.generate(
          _items.length,
          (index) => _buildItem(index),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final item = _items[index];
    final isActive = index == currentIndex;
    final color = isActive
        ? AppColors.primary
        : AppColors.textSecondary;

    return GestureDetector(
      onTap: () => onTap?.call(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 22, color: color),
          const SizedBox(height: AppSpacing.xs),
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
  }
}
