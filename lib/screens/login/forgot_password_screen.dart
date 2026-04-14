import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/api_client.dart';
import 'package:residence_app/services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static const Color _bg = Color(0xFFF7F4EF);
  static const Color _dark = Color(0xFF0F1B2D);
  static const Color _primary = Color(0xFFEC5B13);

  final _dio = ApiClient().dio;
  final _emailController = TextEditingController();
  final _pinController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _loading = false;
  String? _error;
  String? _success;
  bool _pinSent = false; // step 1 done → show PIN + password fields

  @override
  void dispose() {
    _emailController.dispose();
    _pinController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _requestPin() async {
    final email = _emailController.text.trim().toLowerCase();
    if (email.isEmpty) {
      setState(() => _error = 'Ingresa tu correo electrónico');
      return;
    }

    setState(() { _loading = true; _error = null; _success = null; });
    try {
      await _dio.post('/api/v1/auth/forgot-password', data: {'email': email});
      if (!mounted) return;
      setState(() {
        _pinSent = true;
        _loading = false;
        _success = 'Se envió un código a tu correo electrónico';
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AuthService.parseError(e);
        _loading = false;
      });
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim().toLowerCase();
    final pin = _pinController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (pin.isEmpty) {
      setState(() => _error = 'Ingresa el código');
      return;
    }
    if (password.isEmpty) {
      setState(() => _error = 'Ingresa tu nueva contraseña');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'La contraseña debe tener al menos 6 caracteres');
      return;
    }
    if (password != confirm) {
      setState(() => _error = 'Las contraseñas no coinciden');
      return;
    }

    setState(() { _loading = true; _error = null; _success = null; });
    try {
      await _dio.post('/api/v1/auth/reset-password', data: {
        'email': email,
        'pin': pin,
        'new_password': password,
      });
      if (!mounted) return;
      setState(() { _loading = false; });
      // Show success and go back to login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contraseña actualizada. Ya puedes iniciar sesión.',
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
        title: Text('Recuperar contraseña',
            style: GoogleFonts.publicSans(
                fontSize: 18, fontWeight: FontWeight.w700, color: _dark)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _pinSent
                  ? 'Ingresa el código que recibiste y tu nueva contraseña'
                  : 'Ingresa tu correo electrónico para recibir un código de recuperación',
              style: GoogleFonts.publicSans(
                  fontSize: 14, color: _dark.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 24),

            // Email (always visible)
            _label('CORREO ELECTRÓNICO'),
            _input(_emailController, 'correo@ejemplo.com',
                enabled: !_pinSent,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),

            if (_pinSent) ...[
              _label('CÓDIGO'),
              _input(_pinController, 'Código de 6 dígitos',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _label('NUEVA CONTRASEÑA'),
              _input(_passwordController, '••••••••', obscure: true),
              const SizedBox(height: 16),
              _label('CONFIRMAR CONTRASEÑA'),
              _input(_confirmController, '••••••••', obscure: true),
              const SizedBox(height: 8),
            ],

            if (_error != null) ...[
              const SizedBox(height: 8),
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

            if (_success != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0x1A10B981),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0x3310B981)),
                ),
                child: Text(_success!,
                    style: GoogleFonts.publicSans(
                        fontSize: 13, color: const Color(0xFF10B981))),
              ),
            ],

            const SizedBox(height: 24),

            // Action button
            GestureDetector(
              onTap: _loading
                  ? null
                  : (_pinSent ? _resetPassword : _requestPin),
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
                      : Text(
                          _pinSent ? 'Cambiar contraseña' : 'Enviar código',
                          style: GoogleFonts.publicSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                ),
              ),
            ),

            if (_pinSent) ...[
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: _loading ? null : _requestPin,
                  child: Text('Reenviar código',
                      style: GoogleFonts.publicSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _primary)),
                ),
              ),
            ],
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

  Widget _input(TextEditingController controller, String hint,
      {bool obscure = false,
      bool enabled = true,
      TextInputType? keyboardType}) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: enabled ? Colors.white : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _dark.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        enabled: enabled,
        keyboardType: keyboardType,
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
