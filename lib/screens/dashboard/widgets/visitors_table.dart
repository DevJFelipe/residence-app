import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../models/dashboard_models.dart';

class VisitorsTable extends StatelessWidget {
  final List<ActiveVisitor> visitors;

  const VisitorsTable({super.key, required this.visitors});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
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
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 25),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.borderLight),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Visitantes en Sitio', style: AppTextStyles.heading3),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    '${visitors.length} Activos',
                    style:
                        AppTextStyles.bold12.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          if (visitors.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'No hay visitantes en sitio',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            // Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 572,
                child: Column(
                  children: [
                    // Table header
                    Container(
                      color: AppColors.surfaceLight,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Row(
                        children: [
                          _headerCell('NOMBRE', flex: 3),
                          _headerCell('DESTINO', flex: 2),
                          _headerCell('ENTRADA', flex: 2),
                          _headerCell('TIPO', flex: 2),
                          _headerCell('ACCIÓN', flex: 2),
                        ],
                      ),
                    ),
                    // Rows
                    ...visitors.asMap().entries.map((entry) {
                      final visitor = entry.value;
                      final isFirst = entry.key == 0;
                      return _buildVisitorRow(
                        visitor: visitor,
                        showBorder: !isFirst,
                      );
                    }),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _headerCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: AppTextStyles.tableHeader.copyWith(
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _typeBg(String type) {
    final t = type.toUpperCase();
    if (t.contains('FAMILIAR') || t.contains('VISITANTE')) {
      return AppColors.badgeFamiliar;
    }
    return AppColors.badgeDomicilio;
  }

  Color _typeColor(String type) {
    final t = type.toUpperCase();
    if (t.contains('FAMILIAR') || t.contains('VISITANTE')) {
      return AppColors.badgeFamiliarText;
    }
    return AppColors.badgeDomicilioText;
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '--';
    final local = dt.toLocal();
    final hour = local.hour > 12 ? local.hour - 12 : (local.hour == 0 ? 12 : local.hour);
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute\n$period';
  }

  Widget _buildVisitorRow({
    required ActiveVisitor visitor,
    required bool showBorder,
  }) {
    final type = visitor.typeLabel.toUpperCase();
    return Container(
      decoration: showBorder
          ? const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.borderLight),
              ),
            )
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Name with avatar
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 27,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.avatarPlaceholder,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    visitor.visitorName,
                    style: AppTextStyles.medium14,
                  ),
                ),
              ],
            ),
          ),
          // Destination
          Expanded(
            flex: 2,
            child: Text(
              visitor.propertyNumber ?? '--',
              style: AppTextStyles.bodyMedium,
            ),
          ),
          // Time
          Expanded(
            flex: 2,
            child: Text(
              _formatTime(visitor.entryTime),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          // Type
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _typeBg(type),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  type,
                  style: AppTextStyles.bold10.copyWith(color: _typeColor(type)),
                ),
              ),
            ),
          ),
          // Action
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Marcar\nSalida',
                style: AppTextStyles.bold14.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
