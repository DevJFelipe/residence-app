import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../providers/visitor_provider.dart';

class OccupancyCard extends ConsumerWidget {
  const OccupancyCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final occupancyAsync = ref.watch(occupancyProvider);

    return occupancyAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (data) {
        final current = data['current'] as int? ?? 0;
        final max = data['max'] as int? ?? 30;
        final factor = max > 0 ? (current / max).clamp(0.0, 1.0) : 0.0;

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
                      color: const Color(0xB3EC5B13),
                    ),
                  ),
                  Text(
                    '$current/$max',
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
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0x1AEC5B13),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: factor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
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
      },
    );
  }
}
