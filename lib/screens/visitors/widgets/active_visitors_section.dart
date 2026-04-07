import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class _VisitorData {
  final String name;
  final String location;
  final String time;
  final String iconAsset;
  final double iconWidth;
  final double iconHeight;

  const _VisitorData({
    required this.name,
    required this.location,
    required this.time,
    required this.iconAsset,
    this.iconWidth = 18,
    this.iconHeight = 16,
  });
}

class ActiveVisitorsSection extends StatelessWidget {
  const ActiveVisitorsSection({super.key});

  static const List<_VisitorData> _visitors = [
    _VisitorData(
      name: 'Ricardo Montaner',
      location: 'Torre A - 402',
      time: '12:15 PM',
      iconAsset: 'assets/icons/visitor_person.svg',
      iconWidth: 18,
      iconHeight: 16,
    ),
    _VisitorData(
      name: 'Elena Martínez',
      location: 'Casa 15',
      time: '01:45 PM',
      iconAsset: 'assets/icons/visitor_person_female.svg',
      iconWidth: 16,
      iconHeight: 16,
    ),
    _VisitorData(
      name: 'Carlos Vives',
      location: 'Torre C - 105',
      time: '02:05 PM',
      iconAsset: 'assets/icons/visitor_person.svg',
      iconWidth: 18,
      iconHeight: 16,
    ),
    _VisitorData(
      name: 'Rappi #4421',
      location: 'Torre B - 901',
      time: '02:22 PM',
      iconAsset: 'assets/icons/visitor_delivery.svg',
      iconWidth: 20,
      iconHeight: 14,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
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
                '4 en el recinto',
                style: AppTextStyles.bold12.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Visitor cards
        ...List.generate(_visitors.length, (index) {
          final visitor = _visitors[index];
          return Padding(
            padding: EdgeInsets.only(bottom: index < _visitors.length - 1 ? 16 : 0),
            child: _buildVisitorCard(visitor),
          );
        }),
      ],
    );
  }

  Widget _buildVisitorCard(_VisitorData visitor) {
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
          Row(
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
                    visitor.iconAsset,
                    width: visitor.iconWidth,
                    height: visitor.iconHeight,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name + info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    visitor.name,
                    style: AppTextStyles.bold14.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    '${visitor.location} • ${visitor.time}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          // SALIDA button
          Container(
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
        ],
      ),
    );
  }
}
