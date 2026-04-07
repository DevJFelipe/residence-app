import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class OccupancyCard extends StatelessWidget {
  const OccupancyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0x0DEC5B13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x33EC5B13)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'OCUPACIÓN ACTUAL',
                style: GoogleFonts.publicSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 16 / 12,
                  letterSpacing: 1.2,
                  color: const Color(0xB3EC5B13), // 70% opacity
                ),
              ),
              Text(
                '12/30',
                style: GoogleFonts.publicSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 32 / 24,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0x1AEC5B13),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 12 / 30,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Caption
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'CAPACIDAD DE VISITANTES RECOMENDADA',
              style: GoogleFonts.publicSans(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                height: 15 / 10,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
