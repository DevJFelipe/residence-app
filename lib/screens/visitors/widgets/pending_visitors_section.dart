import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../providers/visitor_provider.dart';

class PendingVisitorsSection extends ConsumerWidget {
  const PendingVisitorsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingVisitorsProvider);

    return pendingAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (visitors) {
        if (visitors.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF59E0B),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text('Pre-registrados', style: AppTextStyles.heading3),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0x1AF59E0B),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    '${visitors.length} pendientes',
                    style: AppTextStyles.bold12.copyWith(
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...List.generate(visitors.length, (index) {
              final v = visitors[index];
              return Padding(
                padding:
                    EdgeInsets.only(bottom: index < visitors.length - 1 ? 12 : 0),
                child: _buildCard(context, ref, v),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildCard(
      BuildContext context, WidgetRef ref, Map<String, dynamic> visitor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x33F59E0B)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0x1AF59E0B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.schedule_rounded,
                  size: 20,
                  color: Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visitor['name'] ?? '',
                      style: AppTextStyles.bold14
                          .copyWith(color: AppColors.textDark),
                    ),
                    Text(
                      '${visitor['location']}${visitor['authorized_by'] != '' ? ' • Aut: ${visitor['authorized_by']}' : ''}',
                      style: AppTextStyles.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if ((visitor['document'] ?? '').isNotEmpty ||
              (visitor['vehicle'] ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 52),
                if ((visitor['document'] ?? '').isNotEmpty)
                  Text(
                    'Doc: ${visitor['document']}',
                    style: GoogleFonts.publicSans(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                if ((visitor['document'] ?? '').isNotEmpty &&
                    (visitor['vehicle'] ?? '').isNotEmpty)
                  const Text('  •  ',
                      style: TextStyle(color: AppColors.textSecondary)),
                if ((visitor['vehicle'] ?? '').isNotEmpty)
                  Text(
                    'Placa: ${visitor['vehicle']}',
                    style: GoogleFonts.publicSans(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () => _confirmEntry(context, ref, visitor['id']),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'CONFIRMAR ENTRADA',
                    style: GoogleFonts.publicSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmEntry(
      BuildContext context, WidgetRef ref, dynamic visitorId) async {
    if (visitorId == null) return;
    try {
      final repo = ref.read(visitorRepositoryProvider);
      await repo.confirmEntry(visitorId.toString());
      ref.invalidate(pendingVisitorsProvider);
      ref.invalidate(activeVisitorsProvider);
      ref.invalidate(occupancyProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entrada confirmada')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al confirmar entrada')),
        );
      }
    }
  }
}
