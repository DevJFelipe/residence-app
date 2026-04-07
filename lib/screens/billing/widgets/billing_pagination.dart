import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class BillingPagination extends StatelessWidget {
  const BillingPagination({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: record count
          Text(
            'Mostrando 1-10 de 154\nregistros',
            style: GoogleFonts.publicSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
              color: AppColors.textSecondary,
            ),
          ),
          // Right: page buttons
          Row(
            children: [
              _buildNavButton('assets/icons/billing_chevron_left.svg'),
              const SizedBox(width: 8),
              _buildPageButton('1', isActive: true),
              const SizedBox(width: 8),
              _buildPageButton('2'),
              const SizedBox(width: 8),
              _buildPageButton('3'),
              const SizedBox(width: 8),
              _buildNavButton('assets/icons/billing_chevron_right.svg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String iconAsset) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Center(
        child: SvgPicture.asset(
          iconAsset,
          width: 4.317,
          height: 7,
        ),
      ),
    );
  }

  Widget _buildPageButton(String label, {bool isActive = false}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: isActive ? null : Border.all(color: AppColors.divider),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.publicSans(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            height: 16 / 12,
            color: isActive ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
