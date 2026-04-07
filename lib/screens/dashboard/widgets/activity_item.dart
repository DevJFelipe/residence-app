import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/app_text_styles.dart';

class ActivityItem extends StatelessWidget {
  final Color iconBackground;
  final String iconAsset;
  final double iconSize;
  final String title;
  final String time;

  const ActivityItem({
    super.key,
    required this.iconBackground,
    required this.iconAsset,
    required this.iconSize,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                iconAsset,
                width: iconSize,
                height: iconSize,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.semiBold14),
              Text(time, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
