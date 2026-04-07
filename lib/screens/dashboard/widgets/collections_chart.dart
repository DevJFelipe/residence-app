import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class CollectionsChart extends StatelessWidget {
  const CollectionsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recaudos\nMensuales', style: AppTextStyles.heading3),
              _buildDropdown(),
            ],
          ),
          const SizedBox(height: 24),
          // Chart area
          SizedBox(
            height: 256,
            child: _buildChartArea(),
          ),
          const SizedBox(height: 24),
          // Legend
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      height: 36,
      padding: const EdgeInsets.only(left: 16, right: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Últimos 6 meses',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 14,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(width: 4),
          SvgPicture.asset(
            'assets/icons/chevron_down.svg',
            width: 21,
            height: 21,
          ),
        ],
      ),
    );
  }

  Widget _buildChartArea() {
    final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
    final barHeights = [0.55, 0.70, 0.60, 0.75, 0.85, 0.0];
    final projectedHeights = [0.65, 0.80, 0.70, 0.85, 0.95, 0.0];

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(months.length, (index) {
              if (index == months.length - 1) {
                // Jun - dashed line with no bar
                return Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 2,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: CustomPaint(
                          painter: _DashedLinePainter(),
                          size: const Size(double.infinity, 2),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                );
              }
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Projected bar
                      Flexible(
                        child: FractionallySizedBox(
                          heightFactor: projectedHeights[index],
                          child: Container(
                            width: 14,
                            decoration: BoxDecoration(
                              color: AppColors.primaryBorder,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 3),
                      // Collected bar
                      Flexible(
                        child: FractionallySizedBox(
                          heightFactor: barHeights[index],
                          child: Container(
                            width: 14,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        // Month labels
        Row(
          children: months.asMap().entries.map((entry) {
            final month = entry.value;
            final isCurrent = month == 'May';
            return Expanded(
              child: Center(
                child: Text(
                  month,
                  style: isCurrent
                      ? AppTextStyles.bold12.copyWith(color: AppColors.textDark)
                      : AppTextStyles.bodySmall,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(AppColors.primary, 'Recaudado'),
        const SizedBox(width: 32),
        _legendItem(AppColors.primaryBorder, 'Proyectado'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 4.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 1),
        Offset(startX + dashWidth, 1),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
