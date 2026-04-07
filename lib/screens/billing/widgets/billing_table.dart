import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

enum InvoiceStatus { pagado, pendiente, vencido }

class _InvoiceRow {
  final String unit;
  final String residentName;
  final String initials;
  final String concept;
  final String amount;
  final String dueDate;
  final InvoiceStatus status;
  final bool isOverdueHighlight;

  const _InvoiceRow({
    required this.unit,
    required this.residentName,
    required this.initials,
    required this.concept,
    required this.amount,
    required this.dueDate,
    required this.status,
    this.isOverdueHighlight = false,
  });
}

class BillingTable extends StatelessWidget {
  const BillingTable({super.key});

  static const List<_InvoiceRow> _rows = [
    _InvoiceRow(
      unit: 'Apto\n201',
      residentName: 'Carlos\nMendoza',
      initials: 'CM',
      concept: 'Adm.\nOctubre',
      amount: '\$350.000',
      dueDate: '15 Oct 2023',
      status: InvoiceStatus.pagado,
    ),
    _InvoiceRow(
      unit: 'Casa\n12',
      residentName: 'Andrea\nDuarte',
      initials: 'AD',
      concept: 'Adm.\nOctubre',
      amount: '\$1.250.000',
      dueDate: '30 Oct 2023',
      status: InvoiceStatus.pendiente,
    ),
    _InvoiceRow(
      unit: 'Torre\n4 -\n802',
      residentName: 'Roberto\nRojas',
      initials: 'RR',
      concept: 'Extra.\nFachada',
      amount: '\$600.000',
      dueDate: '10 Oct 2023',
      status: InvoiceStatus.vencido,
      isOverdueHighlight: true,
    ),
    _InvoiceRow(
      unit: 'Apto\n505',
      residentName: 'Luis\nFernando\nP.',
      initials: 'LF',
      concept: 'Adm.\nOctubre',
      amount: '\$350.000',
      dueDate: '15 Oct 2023',
      status: InvoiceStatus.pagado,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table header
          Container(
            color: AppColors.surfaceLight,
            child: Row(
              children: [
                _checkboxCell(isHeader: true),
                _headerCell('UNIDAD\n#', 93),
                _headerCell('RESIDENTE', 154),
                _headerCell('CONCEPTO', 112),
                _headerCell('VALOR', 124),
                _headerCell('VENCIMIENTO', 131),
                _headerCell('ESTADO', 148),
                _headerCellRight('ACCIONES', 109),
              ],
            ),
          ),
          // Rows
          ...List.generate(_rows.length, (index) {
            final row = _rows[index];
            return Container(
              decoration: BoxDecoration(
                color: row.isOverdueHighlight
                    ? const Color(0x0DFFF1F2)
                    : null,
                border: index > 0
                    ? const Border(top: BorderSide(color: AppColors.borderLight))
                    : null,
              ),
              child: Row(
                children: [
                  _checkboxCell(),
                  // Unit
                  SizedBox(
                    width: 93,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      child: Text(
                        row.unit,
                        style: GoogleFonts.publicSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  // Resident
                  SizedBox(
                    width: 154,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.avatarPlaceholder,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Center(
                              child: Text(
                                row.initials,
                                style: GoogleFonts.publicSans(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            row.residentName,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Concept
                  SizedBox(
                    width: 112,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Text(
                        row.concept,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ),
                  // Amount
                  SizedBox(
                    width: 124,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
                      child: Text(
                        row.amount,
                        style: GoogleFonts.publicSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 20 / 14,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  // Due date
                  SizedBox(
                    width: 131,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
                      child: Text(
                        row.dueDate,
                        style: GoogleFonts.publicSans(
                          fontSize: 14,
                          fontWeight: row.isOverdueHighlight
                              ? FontWeight.w500
                              : FontWeight.w400,
                          height: 20 / 14,
                          color: row.isOverdueHighlight
                              ? const Color(0xFFE11D48)
                              : AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  // Status badge
                  SizedBox(
                    width: 148,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: _buildStatusBadge(row.status),
                    ),
                  ),
                  // Actions
                  SizedBox(
                    width: 109,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SvgPicture.asset(
                          'assets/icons/billing_dots.svg',
                          width: 4,
                          height: 16,
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
    );
  }

  Widget _checkboxCell({bool isHeader = false}) {
    return SizedBox(
      width: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
        ),
      ),
    );
  }

  Widget _headerCell(String text, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        child: Text(
          text,
          style: GoogleFonts.publicSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _headerCellRight(String text, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            text,
            style: GoogleFonts.publicSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(InvoiceStatus status) {
    late Color bgColor;
    late Color dotColor;
    late Color textColor;
    late String label;

    switch (status) {
      case InvoiceStatus.pagado:
        bgColor = const Color(0xFFD1FAE5);
        dotColor = const Color(0xFF10B981);
        textColor = const Color(0xFF047857);
        label = 'Pagado';
      case InvoiceStatus.pendiente:
        bgColor = const Color(0xFFFEF3C7);
        dotColor = const Color(0xFFF59E0B);
        textColor = const Color(0xFFB45309);
        label = 'Pendiente';
      case InvoiceStatus.vencido:
        bgColor = const Color(0xFFFFE4E6);
        dotColor = const Color(0xFFF43F5E);
        textColor = const Color(0xFFBE123C);
        label = 'Vencido';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.publicSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 16 / 12,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
