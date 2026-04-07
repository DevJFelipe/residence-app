import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';

/// Data class for a single navigation item.
class _NavItem {
  final String iconAsset;
  final double iconWidth;
  final double iconHeight;
  final String label;

  const _NavItem({
    required this.iconAsset,
    required this.iconWidth,
    required this.iconHeight,
    required this.label,
  });
}

/// The bottom navigation bar for the admin shell.
///
/// Displays five tabs: Inicio, Residentes, Pagos,
/// PQRS, and Mas. Highlights the active tab in the
/// app's primary color.
class AdminBottomNav extends StatelessWidget {
  /// Index of the currently active tab (0-based).
  final int currentIndex;

  /// Callback invoked with the tapped tab index.
  final ValueChanged<int>? onTap;

  const AdminBottomNav({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  static const List<_NavItem> _items = [
    _NavItem(
      iconAsset: 'assets/icons/nav_home.svg',
      iconWidth: 18,
      iconHeight: 18,
      label: 'Inicio',
    ),
    _NavItem(
      iconAsset: 'assets/icons/nav_residents.svg',
      iconWidth: 22,
      iconHeight: 16,
      label: 'Residentes',
    ),
    _NavItem(
      iconAsset: 'assets/icons/nav_payments.svg',
      iconWidth: 22,
      iconHeight: 16,
      label: 'Pagos',
    ),
    _NavItem(
      iconAsset: 'assets/icons/nav_pqrs.svg',
      iconWidth: 20,
      iconHeight: 16.075,
      label: 'PQRS',
    ),
    _NavItem(
      iconAsset: 'assets/icons/nav_more.svg',
      iconWidth: 16,
      iconHeight: 4,
      label: 'Mas',
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
        left: AppSpacing.lg,
        right: AppSpacing.lg,
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
          SizedBox(
            height: 18,
            child: Center(
              child: SvgPicture.asset(
                item.iconAsset,
                width: item.iconWidth,
                height: item.iconHeight,
                colorFilter: ColorFilter.mode(
                  color,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
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
