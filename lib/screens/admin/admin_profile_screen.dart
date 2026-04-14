import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/api_client.dart';
import 'package:residence_app/core/session_manager.dart';
import 'package:residence_app/screens/profile/change_password_screen.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  static const Color _bg = Color(0xFFF7F4EF);
  static const Color _dark = Color(0xFF0F1B2D);
  static const Color _accent = Color(0xFFEC5B13);

  final _dio = ApiClient().dio;
  Map<String, dynamic>? _user;
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
      final resp = await _dio.get('/api/v1/auth/me');
      if (!mounted) return;
      setState(() {
        _user = resp.data['data'];
        _isLoading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      // Fallback to cached session data
      final cached = await SessionManager().getUser();
      if (!mounted) return;
      if (cached != null) {
        setState(() {
          _user = cached;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = e.response?.data is Map
              ? (e.response!.data['detail'] ?? 'Error al cargar')
              : 'No se pudo conectar al servidor';
          _isLoading = false;
        });
      }
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
        title: Text('Mi perfil',
            style: GoogleFonts.publicSans(
                fontSize: 18, fontWeight: FontWeight.w700, color: _dark)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: GoogleFonts.publicSans(color: Colors.grey)))
              : _user == null
                  ? const Center(child: Text('Sin datos'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildContent(),
                    ),
    );
  }

  Widget _buildContent() {
    final u = _user!;
    final String name = (u['full_name'] ?? '${u['first_name'] ?? ''} ${u['last_name'] ?? ''}').toString().trim();
    final initials = name.isNotEmpty
        ? name.split(' ').where((w) => w.isNotEmpty).take(2).map((w) => w[0].toUpperCase()).join()
        : '?';

    return Column(
      children: [
        // Avatar
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(initials,
                style: GoogleFonts.publicSans(
                    fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 12),
        Text(name,
            style: GoogleFonts.publicSans(
                fontSize: 20, fontWeight: FontWeight.w700, color: _dark)),
        if (u['email'] != null) ...[
          const SizedBox(height: 4),
          Text(u['email'],
              style: GoogleFonts.publicSans(fontSize: 14, color: Colors.grey)),
        ],
        const SizedBox(height: 24),

        // Info card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _dark.withValues(alpha: 0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Información personal',
                  style: GoogleFonts.publicSans(
                      fontSize: 14, fontWeight: FontWeight.w700, color: _dark)),
              const SizedBox(height: 16),
              _row('Nombre', name),
              _row('Email', u['email']),
              _row('Teléfono', u['phone']),
              _row('Documento', u['document_number']),
              if (u['condominiums'] is List && (u['condominiums'] as List).isNotEmpty)
                _row('Rol', _roleName(u['condominiums'])),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Change password button
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _dark.withValues(alpha: 0.06)),
            ),
            child: Row(
              children: [
                Icon(Icons.lock_outline_rounded, size: 20, color: _accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Cambiar contraseña',
                      style: GoogleFonts.publicSans(
                          fontSize: 15, fontWeight: FontWeight.w600, color: _dark)),
                ),
                Icon(Icons.chevron_right_rounded,
                    size: 20, color: _dark.withValues(alpha: 0.3)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _roleName(List condos) {
    final first = condos.first;
    if (first is Map) {
      final role = first['role_name'] ?? first['role'] ?? 'Administrador';
      return role.toString();
    }
    return first.toString();
  }

  Widget _row(String label, dynamic value) {
    if (value == null || value.toString().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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
