import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../providers/visitor_provider.dart';

class ActiveVisitorsSection extends ConsumerWidget {
  const ActiveVisitorsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitorsAsync = ref.watch(activeVisitorsProvider);

    return visitorsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Error cargando visitantes', style: AppTextStyles.bodyMedium),
      ),
      data: (visitors) => Column(
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/visitor_active_list.svg',
                    width: 24,
                    height: 12,
                  ),
                  const SizedBox(width: 8),
                  Text('Visitantes Activos', style: AppTextStyles.heading3),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0x1AEC5B13),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  '${visitors.length} en el recinto',
                  style: AppTextStyles.bold12.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (visitors.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No hay visitantes activos',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            ...List.generate(visitors.length, (index) {
              final visitor = visitors[index];
              return Padding(
                padding: EdgeInsets.only(bottom: index < visitors.length - 1 ? 16 : 0),
                child: _buildVisitorCard(context, ref, visitor),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildVisitorCard(
      BuildContext context, WidgetRef ref, Map<String, dynamic> visitor) {
    return Container(
      height: 74,
      padding: const EdgeInsets.all(17),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      visitor['iconAsset'] ?? 'assets/icons/visitor_person.svg',
                      width: (visitor['iconWidth'] ?? 18.0).toDouble(),
                      height: (visitor['iconHeight'] ?? 16.0).toDouble(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Name + info
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        visitor['name'] ?? '',
                        style: AppTextStyles.bold14.copyWith(
                          color: AppColors.textDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${visitor['location']} • ${visitor['time']}',
                        style: AppTextStyles.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // SALIDA button
          GestureDetector(
            onTap: () async {
              final visitorId = visitor['id'];
              if (visitorId == null) return;
              try {
                final repo = ref.read(visitorRepositoryProvider);
                await repo.registerExit(visitorId);
                ref.invalidate(activeVisitorsProvider);
                ref.invalidate(occupancyProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Salida registrada')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error registrando salida')),
                  );
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0x33EC5B13)),
              ),
              child: Text(
                'SALIDA',
                style: AppTextStyles.bold12.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
