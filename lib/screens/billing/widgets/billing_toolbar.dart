import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class BillingToolbar extends StatelessWidget {
  const BillingToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.fromLTRB(41, 11, 17, 11),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: -26,
                  top: -1,
                  child: SvgPicture.asset(
                    'assets/icons/billing_search.svg',
                    width: 18,
                    height: 18,
                  ),
                ),
                Text(
                  'Buscar por unidad, residente o factura...',
                  style: GoogleFonts.publicSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Filter buttons row
          Row(
            children: [
              _buildFilterChip(
                'assets/icons/billing_filter.svg',
                'Filtrar',
                iconW: 10.5,
                iconH: 7,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                'assets/icons/billing_calendar.svg',
                'Octubre 2023',
                iconW: 10.5,
                iconH: 11.667,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Eliminar link
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/billing_trash.svg',
                width: 9.333,
                height: 10.5,
              ),
              const SizedBox(width: 8),
              Text(
                'Eliminar',
                style: AppTextStyles.bold14.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String iconAsset, String label,
      {required double iconW, required double iconH}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(iconAsset, width: iconW, height: iconH),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.medium14,
          ),
        ],
      ),
    );
  }
}
