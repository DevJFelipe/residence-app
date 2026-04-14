import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/api_client.dart';

class CondoInfoScreen extends StatefulWidget {
  const CondoInfoScreen({super.key});

  @override
  State<CondoInfoScreen> createState() => _CondoInfoScreenState();
}

class _CondoInfoScreenState extends State<CondoInfoScreen> {
  static const Color _bg = Color(0xFFF7F4EF);
  static const Color _dark = Color(0xFF0F1B2D);
  static const Color _accent = Color(0xFFEC5B13);

  final _dio = ApiClient().dio;
  Map<String, dynamic>? _data;
  bool _isLoading = true;
  bool _saving = false;
  bool _editing = false;
  String? _error;

  // Edit controllers
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _departmentCtrl = TextEditingController();
  final _taxIdCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _departmentCtrl.dispose();
    _taxIdCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final resp = await _dio.get('/api/v1/condominiums/current');
      if (!mounted) return;
      setState(() {
        _data = resp.data['data'];
        _isLoading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.response?.data is Map
            ? (e.response!.data['detail'] ?? 'Error al cargar')
            : 'No se pudo conectar al servidor';
        _isLoading = false;
      });
    }
  }

  void _enterEditMode() {
    final d = _data!;
    _nameCtrl.text = d['name'] ?? '';
    _addressCtrl.text = d['address'] ?? '';
    _cityCtrl.text = d['city'] ?? '';
    _departmentCtrl.text = d['department'] ?? '';
    _taxIdCtrl.text = d['tax_id'] ?? '';
    _phoneCtrl.text = d['phone'] ?? '';
    _emailCtrl.text = d['email'] ?? '';
    setState(() => _editing = true);
  }

  void _cancelEdit() {
    setState(() => _editing = false);
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre es requerido')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final body = <String, dynamic>{
        'name': _nameCtrl.text.trim(),
        'address': _addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim(),
        'city': _cityCtrl.text.trim().isEmpty ? null : _cityCtrl.text.trim(),
        'department': _departmentCtrl.text.trim().isEmpty ? null : _departmentCtrl.text.trim(),
        'tax_id': _taxIdCtrl.text.trim().isEmpty ? null : _taxIdCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        'email': _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      };
      await _dio.patch('/api/v1/condominiums/current', data: body);
      if (!mounted) return;
      setState(() { _editing = false; _saving = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Información actualizada')),
      );
      _load();
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          e.response?.data is Map ? (e.response!.data['detail'] ?? 'Error al guardar') : 'Error al guardar',
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _dark),
          onPressed: () {
            if (_editing) { _cancelEdit(); return; }
            Navigator.pop(context);
          },
        ),
        title: Text('Datos del conjunto',
            style: GoogleFonts.publicSans(fontSize: 18, fontWeight: FontWeight.w700, color: _dark)),
        centerTitle: true,
        actions: [
          if (!_isLoading && _data != null && !_editing)
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: _accent),
              onPressed: _enterEditMode,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: GoogleFonts.publicSans(color: Colors.grey)))
              : _data == null
                  ? const Center(child: Text('Sin datos'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _editing ? _buildEditForm() : _buildContent(),
                    ),
    );
  }

  Widget _buildContent() {
    final d = _data!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _dark.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(d['name'] ?? '', style: GoogleFonts.publicSans(fontSize: 20, fontWeight: FontWeight.w700, color: _dark)),
          const SizedBox(height: 16),
          _row('Dirección', d['address']),
          _row('Ciudad', d['city']),
          _row('Departamento', d['department']),
          _row('País', d['country']),
          _row('NIT', d['tax_id']),
          _row('Teléfono', d['phone']),
          _row('Email', d['email']),
          _row('Zona horaria', d['timezone']),
          _row('Moneda', d['currency']),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Editar información', style: GoogleFonts.publicSans(fontSize: 18, fontWeight: FontWeight.w700, color: _dark)),
          const SizedBox(height: 20),
          _editField('Nombre *', _nameCtrl),
          _editField('Dirección', _addressCtrl),
          _editField('Ciudad', _cityCtrl),
          _editField('Departamento', _departmentCtrl),
          _editField('NIT', _taxIdCtrl),
          _editField('Teléfono', _phoneCtrl, keyboardType: TextInputType.phone),
          _editField('Email', _emailCtrl, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _cancelEdit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text('Cancelar', style: GoogleFonts.publicSans(fontSize: 15, fontWeight: FontWeight.w600, color: _dark)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _saving ? null : _save,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _saving ? _accent.withValues(alpha: 0.5) : _accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: _saving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('Guardar', style: GoogleFonts.publicSans(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _editField(String label, TextEditingController ctrl, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.publicSans(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: ctrl,
              keyboardType: keyboardType,
              style: GoogleFonts.publicSans(fontSize: 14, color: _dark),
              decoration: InputDecoration(
                hintText: label.replaceAll(' *', ''),
                hintStyle: GoogleFonts.publicSans(fontSize: 14, color: const Color(0xFF94A3B8)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, dynamic value) {
    if (value == null || value.toString().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: GoogleFonts.publicSans(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
          ),
          Expanded(
            child: Text(value.toString(), style: GoogleFonts.publicSans(fontSize: 14, color: _dark)),
          ),
        ],
      ),
    );
  }
}
