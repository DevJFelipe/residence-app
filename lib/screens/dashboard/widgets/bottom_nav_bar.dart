import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class BottomNavItem {
  final String iconAsset;
  final double iconWidth;
  final double iconHeight;
  final String label;

  const BottomNavItem({
    required this.iconAsset,
    required this.iconWidth,
    required this.iconHeight,
    required this.label,
  });
}

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const AppBottomNavBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  static const List<BottomNavItem> _items = [
    BottomNavItem(
      iconAsset: 'assets/icons/nav_home.svg',
      iconWidth: 18,
      iconHeight: 18,
      label: 'Inicio',
    ),
    BottomNavItem(
      iconAsset: 'assets/icons/nav_residents.svg',
      iconWidth: 22,
      iconHeight: 16,
      label: 'Residentes',
    ),
    BottomNavItem(
      iconAsset: 'assets/icons/nav_payments.svg',
      iconWidth: 22,
      iconHeight: 16,
      label: 'Pagos',
    ),
    BottomNavItem(
      iconAsset: 'assets/icons/nav_pqrs.svg',
      iconWidth: 20,
      iconHeight: 16.075,
      label: 'PQRS',
    ),
    BottomNavItem(
      iconAsset: 'assets/icons/nav_more.svg',
      iconWidth: 16,
      iconHeight: 4,
      label: 'Más',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 9,
        bottom: 8 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isActive = index == currentIndex;
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
                        isActive ? AppColors.primary : AppColors.textSecondary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: AppTextStyles.medium10.copyWith(
                    color: isActive ? AppColors.primary : AppColors.textSecondary,
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
