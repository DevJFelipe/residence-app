import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';

/// Data class for a user navigation item.
class _UserNavItem {
  final String iconAsset;
  final double iconWidth;
  final double iconHeight;
  final String label;

  const _UserNavItem({
    required this.iconAsset,
    required this.iconWidth,
    required this.iconHeight,
    required this.label,
  });
}

/// The bottom navigation bar for the resident user
/// shell.
///
/// Displays four tabs: Inicio, Areas, Reservas, and
/// Perfil. Highlights the active tab with the app's
/// primary color.
class UserBottomNav extends StatelessWidget {
  /// Index of the currently active tab (0-based).
  final int currentIndex;

  /// Callback invoked with the tapped tab index.
  final ValueChanged<int>? onTap;

  const UserBottomNav({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  static const List<_UserNavItem> _items = [
    _UserNavItem(
      iconAsset: 'assets/icons/area_nav_home.svg',
      iconWidth: 16,
      iconHeight: 18,
      label: 'Inicio',
    ),
    _UserNavItem(
      iconAsset: 'assets/icons/area_nav_areas.svg',
      iconWidth: 19.3,
      iconHeight: 19.3,
      label: 'Areas',
    ),
    _UserNavItem(
      iconAsset:
          'assets/icons/area_nav_reservas.svg',
      iconWidth: 18,
      iconHeight: 20,
      label: 'Reservas',
    ),
    _UserNavItem(
      iconAsset: 'assets/icons/area_nav_perfil.svg',
      iconWidth: 16,
      iconHeight: 16,
      label: 'Perfil',
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
        left: AppSpacing.xxl,
        right: AppSpacing.xxl,
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
          SvgPicture.asset(
            item.iconAsset,
            width: item.iconWidth,
            height: item.iconHeight,
            colorFilter: ColorFilter.mode(
              color,
              BlendMode.srcIn,
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
