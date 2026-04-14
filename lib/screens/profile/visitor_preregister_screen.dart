import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/api_client.dart';
import '../../theme/app_colors.dart';

class VisitorPreregisterScreen extends StatefulWidget {
  final String condoName;
  final String? condoId;

  const VisitorPreregisterScreen({super.key, this.condoName = 'Conjunto Residencial', this.condoId});

  @override
  State<VisitorPreregisterScreen> createState() => _VisitorPreregisterScreenState();
}

class _VisitorPreregisterScreenState extends State<VisitorPreregisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _phoneController = TextEditingController();
  final _unitController = TextEditingController();
  final _reasonController = TextEditingController();
  String _idType = 'Cédula de ciudadanía';
  String _vehicleType = 'Ninguno';
  final _plateController = TextEditingController();
  DateTime? _visitDate;
  TimeOfDay? _visitTime;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _phoneController.dispose();
    _unitController.dispose();
    _reasonController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (date != null) setState(() => _visitDate = date);
  }

  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (time != null) setState(() => _visitTime = time);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.condoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo identificar el conjunto')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final dio = ApiClient().dio;
      final date = _visitDate ?? DateTime.now();
      final body = <String, dynamic>{
        'condominium_id': widget.condoId,
        'visitor_name': _nameController.text.trim(),
        'property_number': _unitController.text.trim(),
        'expected_date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        if (_idController.text.trim().isNotEmpty)
          'document_number': _idController.text.trim(),
        if (_phoneController.text.trim().isNotEmpty)
          'phone': _phoneController.text.trim(),
        if (_reasonController.text.trim().isNotEmpty)
          'reason': _reasonController.text.trim(),
        if (_vehicleType != 'Ninguno')
          'vehicle_type': _vehicleType,
        if (_plateController.text.trim().isNotEmpty)
          'vehicle_plate': _plateController.text.trim(),
        if (_visitTime != null)
          'expected_time': '${_visitTime!.hour.toString().padLeft(2, '0')}:${_visitTime!.minute.toString().padLeft(2, '0')}',
      };

      final response = await dio.post('/api/v1/visitors/preregister', data: body);
      if (!mounted) return;

      final data = response.data['data'] as Map<String, dynamic>;
      final refCode = data['reference_code'] ?? '';

      setState(() => _submitting = false);
      _showSuccessDialog(refCode);
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      final msg = (e.response?.data is Map)
          ? (e.response!.data['detail'] ?? 'Error al registrar')
          : 'No se pudo conectar al servidor';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg.toString())));
    }
  }

  void _showSuccessDialog(String referenceCode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0x1A16A34A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Color(0xFF16A34A), size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                'Pre-registro exitoso',
                style: GoogleFonts.publicSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tu visita ha sido pre-registrada. Presenta tu código en portería al momento de llegar.',
                style: GoogleFonts.publicSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 22 / 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    Text(
                      'Tu código de visita',
                      style: GoogleFonts.publicSans(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      referenceCode,
                      style: GoogleFonts.publicSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Listo',
                      style: GoogleFonts.publicSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'Pre-registro de visita',
                        style: GoogleFonts.publicSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 32 / 24,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.condoName,
                        style: GoogleFonts.publicSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Info banner
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0x0D3B82F6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0x1A3B82F6)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFF3B82F6)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Completa el formulario para agilizar tu acceso. Recibirás un código QR que debes presentar en portería.',
                                style: GoogleFonts.publicSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  height: 20 / 13,
                                  color: const Color(0xFF1E40AF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Section: Datos personales
                      _sectionTitle('Datos personales'),
                      const SizedBox(height: 14),
                      _buildTextField('Nombre completo', _nameController, 'Ingresa tu nombre completo'),
                      const SizedBox(height: 14),
                      _buildDropdown('Tipo de documento', _idType, [
                        'Cédula de ciudadanía',
                        'Cédula de extranjería',
                        'Pasaporte',
                      ], (v) => setState(() => _idType = v!)),
                      const SizedBox(height: 14),
                      _buildTextField('Número de documento', _idController, 'Ej: 1234567890',
                        keyboardType: TextInputType.number),
                      const SizedBox(height: 14),
                      _buildTextField('Teléfono de contacto', _phoneController, '+57 300 123 4567',
                        keyboardType: TextInputType.phone),

                      const SizedBox(height: 28),

                      // Section: Detalles de visita
                      _sectionTitle('Detalles de la visita'),
                      const SizedBox(height: 14),
                      _buildTextField('Unidad a visitar', _unitController, 'Ej: Torre 2 - Apto 301'),
                      const SizedBox(height: 14),
                      _buildTextField('Motivo de la visita', _reasonController, 'Ej: Visita familiar',
                        maxLines: 2),
                      const SizedBox(height: 14),

                      // Date and time
                      Row(
                        children: [
                          Expanded(child: _buildDateField()),
                          const SizedBox(width: 12),
                          Expanded(child: _buildTimeField()),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Section: Vehículo
                      _sectionTitle('Vehículo (opcional)'),
                      const SizedBox(height: 14),
                      _buildDropdown('Tipo de vehículo', _vehicleType, [
                        'Ninguno',
                        'Carro',
                        'Moto',
                        'Bicicleta',
                      ], (v) => setState(() => _vehicleType = v!)),
                      if (_vehicleType != 'Ninguno') ...[
                        const SizedBox(height: 14),
                        _buildTextField('Placa del vehículo', _plateController, 'Ej: ABC 123'),
                      ],

                      const SizedBox(height: 32),

                      // Submit button
                      GestureDetector(
                        onTap: _submitting ? null : _submit,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: _submitting ? AppColors.primary.withValues(alpha: 0.5) : AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33EC5B13),
                                blurRadius: 15,
                                offset: Offset(0, 10),
                                spreadRadius: -3,
                              ),
                            ],
                          ),
                          child: _submitting
                              ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Generar pre-registro',
                                      style: GoogleFonts.publicSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: Color(0x1AEC5B13))),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 22, color: AppColors.textDark),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Pre-registro',
                  style: GoogleFonts.publicSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.publicSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.publicSans(
          fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark,
        )),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.publicSans(fontSize: 15, color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.publicSans(fontSize: 15, color: const Color(0xFF94A3B8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.publicSans(
          fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark,
        )),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF94A3B8)),
              style: GoogleFonts.publicSans(fontSize: 15, color: AppColors.textDark),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    final text = _visitDate != null
        ? '${_visitDate!.day}/${_visitDate!.month}/${_visitDate!.year}'
        : 'Fecha';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fecha de visita', style: GoogleFonts.publicSans(
          fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark,
        )),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.publicSans(
                      fontSize: 15,
                      color: _visitDate != null ? AppColors.textDark : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    final text = _visitTime != null
        ? _visitTime!.format(context)
        : 'Hora';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hora estimada', style: GoogleFonts.publicSans(
          fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark,
        )),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _selectTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.publicSans(
                      fontSize: 15,
                      color: _visitTime != null ? AppColors.textDark : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
