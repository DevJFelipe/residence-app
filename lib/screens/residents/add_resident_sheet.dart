import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../services/residents_service.dart';

class AddResidentSheet extends StatefulWidget {
  final String propertyId;
  final String propertyLabel;
  final VoidCallback onAdded;

  const AddResidentSheet({
    super.key,
    required this.propertyId,
    required this.propertyLabel,
    required this.onAdded,
  });

  @override
  State<AddResidentSheet> createState() => _AddResidentSheetState();
}

class _AddResidentSheetState extends State<AddResidentSheet> {
  final _service = ResidentsService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _docController = TextEditingController();
  bool _submitting = false;
  String? _error;

  // Relation types: 1=propietario, 2=residente, 3=inquilino (loaded from API)
  List<Map<String, dynamic>> _relationTypes = [];
  int _selectedRelationType = 0;

  @override
  void initState() {
    super.initState();
    _loadRelationTypes();
  }

  Future<void> _loadRelationTypes() async {
    try {
      final types = await _service.getRelationTypes();
      if (!mounted) return;
      setState(() {
        _relationTypes = types;
        if (types.isNotEmpty) {
          _selectedRelationType = types[0]['id'] as int;
        }
      });
    } catch (_) {
      // Fallback defaults
      setState(() {
        _relationTypes = [
          {'id': 1, 'name': 'Propietario'},
          {'id': 2, 'name': 'Residente'},
          {'id': 3, 'name': 'Inquilino'},
        ];
        _selectedRelationType = 2;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _docController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    if (name.isEmpty || email.isEmpty) {
      setState(() => _error = 'Nombre y correo son obligatorios');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await _service.addResident(
        fullName: name,
        email: email,
        password: 'Residence2024!', // temp default password
        propertyId: widget.propertyId,
        relationTypeId: _selectedRelationType,
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        documentNumber: _docController.text.trim().isNotEmpty
            ? _docController.text.trim()
            : null,
      );
      widget.onAdded();
      if (mounted) Navigator.pop(context);
    } on DioException catch (e) {
      setState(() {
        _error = ResidentsService.parseError(e);
        _submitting = false;
      });
    } catch (_) {
      setState(() {
        _error = 'Error inesperado';
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              'Agregar Residente',
              style: GoogleFonts.publicSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Unidad: ${widget.propertyLabel}',
              style: GoogleFonts.publicSans(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            _buildField('Nombre completo *', 'Ej. Juan Pérez', _nameController),
            const SizedBox(height: 16),
            _buildField('Correo electrónico *', 'correo@ejemplo.com',
                _emailController,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _buildField(
                        'Teléfono', '300-000-0000', _phoneController,
                        keyboardType: TextInputType.phone)),
                const SizedBox(width: 16),
                Expanded(
                    child:
                        _buildField('Cédula', 'Documento', _docController)),
              ],
            ),
            const SizedBox(height: 16),
            // Relation type selector
            Text(
              'Tipo de relación',
              style: GoogleFonts.publicSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _relationTypes.map((type) {
                final isSelected = _selectedRelationType == type['id'];
                return ChoiceChip(
                  label: Text(type['name'] ?? ''),
                  selected: isSelected,
                  onSelected: (_) =>
                      setState(() => _selectedRelationType = type['id'] as int),
                  selectedColor: AppColors.primary,
                  labelStyle: GoogleFonts.publicSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textDark,
                  ),
                  backgroundColor: AppColors.surfaceLight,
                  side: BorderSide.none,
                );
              }).toList(),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: GoogleFonts.publicSans(
                  fontSize: 13,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ],
            const SizedBox(height: 24),
            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
                    : Text(
                        'Agregar Residente',
                        style: GoogleFonts.publicSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
      String label, String hint, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.publicSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.publicSans(
              fontSize: 15,
              color: const Color(0xFF6B7280),
            ),
            filled: true,
            fillColor: AppColors.surfaceLight,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
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
            fontSize: 15,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
