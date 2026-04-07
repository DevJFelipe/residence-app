import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class VisitorsTable extends StatelessWidget {
  const VisitorsTable({super.key});

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
                    '8 Activos',
                    style:
                        AppTextStyles.bold12.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
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
                  // Row 1
                  _buildVisitorRow(
                    name: 'Carlos\nRuiz',
                    destination: 'Apto\n501-A',
                    time: '02:45\nPM',
                    type: 'DOMICILIO',
                    typeBg: AppColors.badgeDomicilio,
                    typeColor: AppColors.badgeDomicilioText,
                    showBorder: false,
                  ),
                  // Row 2
                  _buildVisitorRow(
                    name: 'Ana\nMartínez',
                    destination: 'Apto\n203-B',
                    time: '03:12\nPM',
                    type: 'FAMILIAR',
                    typeBg: AppColors.badgeFamiliar,
                    typeColor: AppColors.badgeFamiliarText,
                    showBorder: true,
                  ),
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

  Widget _buildVisitorRow({
    required String name,
    required String destination,
    required String time,
    required String type,
    required Color typeBg,
    required Color typeColor,
    required bool showBorder,
  }) {
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
                    name,
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
              destination,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          // Time
          Expanded(
            flex: 2,
            child: Text(
              time,
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
                  color: typeBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  type,
                  style: AppTextStyles.bold10.copyWith(color: typeColor),
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
