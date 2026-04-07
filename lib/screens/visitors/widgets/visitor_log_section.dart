import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../providers/visitor_provider.dart';

class VisitorLogSection extends ConsumerWidget {
  const VisitorLogSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logAsync = ref.watch(visitorLogProvider);

    return Column(
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/visitor_history.svg',
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: 8),
                Text('Bitácora del Día', style: AppTextStyles.heading3),
              ],
            ),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/visitor_export.svg',
                  width: 9.333,
                  height: 9.333,
                ),
                const SizedBox(width: 4),
                Text(
                  'Exportar',
                  style: AppTextStyles.medium14.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Table card
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x0DEC5B13)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: logAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
            error: (_, __) => Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text('Error cargando bitácora',
                    style: AppTextStyles.bodyMedium),
              ),
            ),
            data: (entries) => Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Table header
                      Container(
                        color: AppColors.surfaceLight,
                        child: Row(
                          children: [
                            _headerCell('VISITANTE', 117),
                            _headerCell('UNIDAD', 109),
                            _headerCell('ENTRADA', 104),
                            _headerCell('SALIDA', 91),
                          ],
                        ),
                      ),
                      if (entries.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'Sin registros de salida hoy',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      else
                        ...List.generate(entries.length, (index) {
                          final entry = entries[index];
                          return Container(
                            decoration: index > 0
                                ? const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          color: AppColors.borderLight),
                                    ),
                                  )
                                : null,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 117,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 16, 24, 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          entry['name'] ?? '',
                                          style: AppTextStyles.medium14,
                                        ),
                                        Text(
                                          entry['subtitle'] ?? '',
                                          style: GoogleFonts.publicSans(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            height: 20 / 10,
                                            color: const Color(0xFF94A3B8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 109,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 36, 24, 36),
                                    child: Text(
                                      entry['unit'] ?? '',
                                      style: GoogleFonts.publicSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        height: 20 / 14,
                                        color: const Color(0xFF475569),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 104,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 36, 24, 36),
                                    child: Text(
                                      entry['entryTime'] ?? '',
                                      style: GoogleFonts.publicSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        height: 20 / 14,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 91,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 36, 24, 36),
                                    child: Text(
                                      entry['exitTime'] ?? '',
                                      style: GoogleFonts.publicSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        height: 20 / 14,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
                // Footer
                Container(
                  width: double.infinity,
                  color: AppColors.surfaceLight,
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Ver registro completo',
                      style: AppTextStyles.bold12.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerCell(String text, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Text(
          text,
          style: GoogleFonts.publicSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            height: 20 / 10,
            letterSpacing: 1.0,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
