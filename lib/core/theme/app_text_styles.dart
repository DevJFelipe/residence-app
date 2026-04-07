import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Headings
  static TextStyle heading2 = GoogleFonts.publicSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    color: AppColors.textDark,
  );

  static TextStyle heading3 = GoogleFonts.publicSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 28 / 18,
    color: AppColors.textDark,
  );

  // Body
  static TextStyle bodyLarge = GoogleFonts.publicSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.textSecondary,
  );

  static TextStyle bodyMedium = GoogleFonts.publicSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.textDark,
  );

  static TextStyle bodySmall = GoogleFonts.publicSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    color: AppColors.textSecondary,
  );

  // Bold variants
  static TextStyle statValue = GoogleFonts.publicSans(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 36 / 30,
    color: AppColors.textDark,
  );

  static TextStyle statLabel = GoogleFonts.publicSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    color: AppColors.textSecondary,
  );

  static TextStyle badgeText = GoogleFonts.publicSans(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 16 / 12,
  );

  static TextStyle semiBold14 = GoogleFonts.publicSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    color: AppColors.textDark,
  );

  static TextStyle bold12 = GoogleFonts.publicSans(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 16 / 12,
  );

  static TextStyle medium14 = GoogleFonts.publicSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    color: AppColors.textDark,
  );

  static TextStyle bold14 = GoogleFonts.publicSans(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
  );

  static TextStyle medium10 = GoogleFonts.publicSans(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 15 / 10,
  );

  static TextStyle bold10 = GoogleFonts.publicSans(
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

  // Table
  static TextStyle tableHeader = GoogleFonts.publicSans(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 16 / 12,
    color: AppColors.textSecondary,
  );
}
