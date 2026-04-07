import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../providers/visitor_provider.dart';

class VisitorFormCard extends ConsumerStatefulWidget {
  const VisitorFormCard({super.key});

  @override
  ConsumerState<VisitorFormCard> createState() => _VisitorFormCardState();
}

class _VisitorFormCardState extends ConsumerState<VisitorFormCard> {
  final _nameController = TextEditingController();
  final _docController = TextEditingController();
  final _unitController = TextEditingController();
  final _plateController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _docController.dispose();
    _unitController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final unit = _unitController.text.trim();
    if (name.isEmpty || unit.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nombre y unidad son obligatorios')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final repo = ref.read(visitorRepositoryProvider);
      await repo.registerEntry({
        'name': name,
        'property_id': unit, // The backend needs property_id, but we send the unit text for now
        'document_number': _docController.text.trim().isNotEmpty
            ? _docController.text.trim()
            : null,
        'vehicle_plate': _plateController.text.trim().isNotEmpty
            ? _plateController.text.trim()
            : null,
        'notes': 'Ingreso manual',
      });
      ref.invalidate(activeVisitorsProvider);
      ref.invalidate(occupancyProvider);
      ref.invalidate(visitorLogProvider);
      _nameController.clear();
      _docController.clear();
      _unitController.clear();
      _plateController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visitante registrado exitosamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error registrando visitante')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 25, 25, 41),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/visitor_new_entry.svg',
                width: 22,
                height: 16,
              ),
              const SizedBox(width: 8),
              Text('Nuevo Ingreso', style: AppTextStyles.heading3),
            ],
          ),
          const SizedBox(height: 24),
          _buildField('Nombre completo', 'Ej. Juan Pérez', _nameController),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child:
                      _buildField('ID / Cédula', 'Documento', _docController)),
              const SizedBox(width: 16),
              Expanded(
                  child:
                      _buildField('Unidad', 'Apto/Casa', _unitController)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildField(
                      'Placa (Opcional)', 'ABC-123', _plateController)),
              const SizedBox(width: 16),
              Expanded(child: _buildTimeField()),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/visitor_register.svg',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Registrar Entrada',
                          style: GoogleFonts.publicSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 24 / 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
      String label, String placeholder, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.publicSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
            color: const Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: GoogleFonts.publicSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6B7280),
            ),
            filled: true,
            fillColor: AppColors.surfaceLight,
            contentPadding: const EdgeInsets.fromLTRB(13, 11, 13, 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            isDense: true,
          ),
          style: GoogleFonts.publicSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.period == DayPeriod.am ? 'AM' : 'PM';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hora Entrada',
          style: GoogleFonts.publicSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
            color: const Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(13, 9, 13, 9),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$hour:$minute $period',
                  style: GoogleFonts.publicSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 24 / 16,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const Icon(
                Icons.access_time,
                size: 16.8,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
