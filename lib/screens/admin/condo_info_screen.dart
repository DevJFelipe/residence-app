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
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Datos del conjunto',
            style: GoogleFonts.publicSans(
                fontSize: 18, fontWeight: FontWeight.w700, color: _dark)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: GoogleFonts.publicSans(color: Colors.grey)))
              : _data == null
                  ? const Center(child: Text('Sin datos'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildContent(),
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
          Text(d['name'] ?? '',
              style: GoogleFonts.publicSans(
                  fontSize: 20, fontWeight: FontWeight.w700, color: _dark)),
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

  Widget _row(String label, dynamic value) {
    if (value == null || value.toString().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: GoogleFonts.publicSans(
                    fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
          ),
          Expanded(
            child: Text(value.toString(),
                style: GoogleFonts.publicSans(fontSize: 14, color: _dark)),
          ),
        ],
      ),
    );
  }
}
