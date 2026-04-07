import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';
import 'package:residence_app/ui/atoms/app_avatar.dart';
import 'package:residence_app/ui/atoms/app_badge.dart';

/// Defines the payment status of an invoice.
enum InvoiceStatus {
  /// The invoice has been paid.
  paid,

  /// The invoice is awaiting payment.
  pending,

  /// The invoice is past due.
  overdue,
}

/// A simplified invoice row extracted from the billing
/// table for use as a standalone list item.
///
/// Displays the resident avatar, name, unit, concept,
/// amount, and a status badge. Optionally tappable.
class InvoiceRow extends StatelessWidget {
  /// Initials for the avatar.
  final String initials;

  /// Background color for the initials avatar.
  final Color initialsColor;

  /// The resident's name.
  final String name;

  /// The unit identifier, e.g. "Apto 201".
  final String unit;

  /// The billing concept, e.g. "Adm. Octubre".
  final String concept;

  /// The formatted amount string.
  final String amount;

  /// The payment status.
  final InvoiceStatus status;

  /// Optional callback when the row is tapped.
  final VoidCallback? onTap;

  const InvoiceRow({
    super.key,
    required this.initials,
    this.initialsColor = AppColors.avatarPlaceholder,
    required this.name,
    required this.unit,
    required this.concept,
    required this.amount,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: status == InvoiceStatus.overdue
              ? const Color(0x08FFF1F2)
              : null,
          border: const Border(
            bottom: BorderSide(
              color: AppColors.borderLight,
            ),
          ),
        ),
        child: Row(
          children: [
            AppAvatar(
              initials: initials,
              size: 32,
              backgroundColor: initialsColor,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.publicSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 20 / 14,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    '$unit - $concept',
                    style: GoogleFonts.publicSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: GoogleFonts.publicSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 20 / 14,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.xs,
                ),
                _buildBadge(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge() {
    switch (status) {
      case InvoiceStatus.paid:
        return const AppBadge(
          label: 'Pagado',
          variant: AppBadgeVariant.success,
        );
      case InvoiceStatus.pending:
        return const AppBadge(
          label: 'Pendiente',
          variant: AppBadgeVariant.warning,
        );
      case InvoiceStatus.overdue:
        return const AppBadge(
          label: 'Vencido',
          variant: AppBadgeVariant.error,
        );
    }
  }
}
