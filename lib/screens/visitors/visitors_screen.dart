import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'widgets/visitor_form_card.dart';
import 'widgets/occupancy_card.dart';
import 'widgets/pending_visitors_section.dart';
import 'widgets/active_visitors_section.dart';
import 'widgets/visitor_log_section.dart';

class VisitorsScreen extends StatelessWidget {
  final bool embedded;
  const VisitorsScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  const VisitorFormCard(),
                  const SizedBox(height: 24),
                  const PendingVisitorsSection(),
                  const SizedBox(height: 24),
                  const OccupancyCard(),
                  const SizedBox(height: 32),
                  const ActiveVisitorsSection(),
                  const SizedBox(height: 32),
                  const VisitorLogSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    if (embedded) return body;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: body,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          bottom: BorderSide(color: Color(0x1AEC5B13)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 25),
        child: Row(
          children: [
            if (!embedded) ...[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 24,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 12),
            ],
            SvgPicture.asset(
              'assets/icons/visitor_header_logo.svg',
              width: 36,
              height: 34,
            ),
            const SizedBox(width: 12),
            Text(
              'Visitantes',
              style: AppTextStyles.heading2.copyWith(
                letterSpacing: -0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
