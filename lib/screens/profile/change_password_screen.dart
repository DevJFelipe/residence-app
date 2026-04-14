import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/api_client.dart';
import 'package:residence_app/services/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  static const Color _bg = Color(0xFFF7F4EF);
  static const Color _dark = Color(0xFF0F1B2D);
  static const Color _primary = Color(0xFFEC5B13);

  final _dio = ApiClient().dio;
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final current = _currentController.text;
    final newPass = _newController.text;
    final confirm = _confirmController.text;

    if (current.isEmpty || newPass.isEmpty) {
      setState(() => _error = 'Completa todos los campos');
      return;
    }
    if (newPass.length < 6) {
      setState(() => _error = 'La nueva contraseña debe tener al menos 6 caracteres');
      return;
    }
    if (newPass != confirm) {
      setState(() => _error = 'Las contraseñas no coinciden');
      return;
    }

    setState(() { _loading = true; _error = null; });
    try {
      await _dio.post('/api/v1/auth/change-password', data: {
        'current_password': current,
        'new_password': newPass,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contraseña actualizada',
              style: GoogleFonts.publicSans(fontWeight: FontWeight.w500)),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      Navigator.of(context).pop();
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AuthService.parseError(e);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Cambiar contraseña',
            style: GoogleFonts.publicSans(
                fontSize: 18, fontWeight: FontWeight.w700, color: _dark)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('CONTRASEÑA ACTUAL'),
            _input(_currentController, '••••••••'),
            const SizedBox(height: 16),
            _label('NUEVA CONTRASEÑA'),
            _input(_newController, 'Mínimo 6 caracteres'),
            const SizedBox(height: 16),
            _label('CONFIRMAR NUEVA CONTRASEÑA'),
            _input(_confirmController, '••••••••'),

            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0x1AEF4444),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0x33EF4444)),
                ),
                child: Text(_error!,
                    style: GoogleFonts.publicSans(
                        fontSize: 13, color: const Color(0xFFEF4444))),
              ),
            ],

            const SizedBox(height: 32),
            GestureDetector(
              onTap: _loading ? null : _submit,
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: _primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: _loading
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                      : Text('Actualizar contraseña',
                          style: GoogleFonts.publicSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text,
          style: GoogleFonts.publicSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: _dark.withValues(alpha: 0.5))),
    );
  }

  Widget _input(TextEditingController controller, String hint) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _dark.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              GoogleFonts.publicSans(fontSize: 15, color: const Color(0xFF6B7280)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          isDense: true,
        ),
        style: GoogleFonts.publicSans(fontSize: 15, color: _dark),
      ),
    );
  }
}
