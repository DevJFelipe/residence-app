import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color _bgColor = Color(0xFFF7F4EF);
  static const Color _darkText = Color(0xFF0F1B2D);
  static const Color _primary = Color(0xFFEC5B13);

  final _authService = AuthService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _generalError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmError = null;
      _generalError = null;
    });

    bool hasError = false;
    if (name.isEmpty) {
      _nameError = 'Ingrese su nombre completo';
      hasError = true;
    }
    if (email.isEmpty) {
      _emailError = 'Ingrese su correo electrónico';
      hasError = true;
    } else if (!email.contains('@')) {
      _emailError = 'Correo electrónico inválido';
      hasError = true;
    }
    if (password.isEmpty) {
      _passwordError = 'Ingrese una contraseña';
      hasError = true;
    } else if (password.length < 6) {
      _passwordError = 'Mínimo 6 caracteres';
      hasError = true;
    }
    if (confirm != password) {
      _confirmError = 'Las contraseñas no coinciden';
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    setState(() => _isLoading = true);
    try {
      final message = await _authService.register(
        fullName: name,
        email: email,
        password: password,
        phone: phone.isNotEmpty ? phone : null,
      );
      if (!mounted) return;

      _showSuccess(message);
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _generalError = AuthService.parseError(e);
        _isLoading = false;
      });
    }
  }

  void _showSuccess(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0x1A22C55E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF22C55E),
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Registro exitoso',
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _darkText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message.isNotEmpty
                    ? message
                    : 'Tu cuenta ha sido creada. '
                        'Ya puedes iniciar sesión.',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 22 / 14,
                  color: _darkText.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Ir a iniciar sesión',
                      style: GoogleFonts.dmSans(
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
        backgroundColor: _bgColor,
        body: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  24, 8, 24, 32,
                ),
                child: Column(
                  children: [
                    // Title
                    Text(
                      'Crear cuenta',
                      style: GoogleFonts.dmSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 32 / 24,
                        color: _darkText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Completa tus datos para registrarte',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: _darkText.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // General error
                    if (_generalError != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0x1AEF4444),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0x33EF4444),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              size: 18,
                              color: Color(0xFFEF4444),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _generalError!,
                                style: GoogleFonts.dmSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFEF4444),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Name
                    _buildLabel('NOMBRE COMPLETO'),
                    _buildInput(
                      controller: _nameController,
                      hint: 'Juan Pérez',
                      error: _nameError,
                      prefixIcon: Icon(
                        Icons.person_outline,
                        size: 20,
                        color: _darkText.withValues(alpha: 0.4),
                      ),
                      textCapitalization:
                          TextCapitalization.words,
                    ),
                    if (_nameError != null)
                      _buildErrorText(_nameError!),
                    const SizedBox(height: 16),

                    // Email
                    _buildLabel('CORREO ELECTRÓNICO'),
                    _buildInput(
                      controller: _emailController,
                      hint: 'ejemplo@residence.com',
                      error: _emailError,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: _darkText.withValues(alpha: 0.4),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    if (_emailError != null)
                      _buildErrorText(_emailError!),
                    const SizedBox(height: 16),

                    // Phone (optional)
                    _buildLabel('TELÉFONO (OPCIONAL)'),
                    _buildInput(
                      controller: _phoneController,
                      hint: '+57 300 123 4567',
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        size: 20,
                        color: _darkText.withValues(alpha: 0.4),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    // Password
                    _buildLabel('CONTRASEÑA'),
                    _buildInput(
                      controller: _passwordController,
                      hint: 'Mínimo 6 caracteres',
                      error: _passwordError,
                      obscureText: _obscurePassword,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        size: 20,
                        color: _darkText.withValues(alpha: 0.4),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                          () => _obscurePassword =
                              !_obscurePassword,
                        ),
                        child: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color:
                              _darkText.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    if (_passwordError != null)
                      _buildErrorText(_passwordError!),
                    const SizedBox(height: 16),

                    // Confirm password
                    _buildLabel('CONFIRMAR CONTRASEÑA'),
                    _buildInput(
                      controller: _confirmController,
                      hint: 'Repite tu contraseña',
                      error: _confirmError,
                      obscureText: _obscureConfirm,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        size: 20,
                        color: _darkText.withValues(alpha: 0.4),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                          () =>
                              _obscureConfirm = !_obscureConfirm,
                        ),
                        child: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color:
                              _darkText.withValues(alpha: 0.4),
                        ),
                      ),
                      onSubmitted: (_) => _register(),
                    ),
                    if (_confirmError != null)
                      _buildErrorText(_confirmError!),
                    const SizedBox(height: 32),

                    // Register button
                    GestureDetector(
                      onTap: _isLoading ? null : _register,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: _primary,
                          borderRadius:
                              BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33EC5B13),
                              blurRadius: 15,
                              offset: Offset(0, 10),
                              spreadRadius: -3,
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'Crear cuenta',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    height: 28 / 18,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Login link
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿Ya tienes cuenta? ',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: _darkText.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.of(context).pop(),
                          child: Text(
                            'Inicia sesión',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      decoration: BoxDecoration(
        color: _bgColor,
        border: Border(
          bottom: BorderSide(
            color: _darkText.withValues(alpha: 0.06),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 22,
                color: _darkText,
              ),
              onPressed: () =>
                  Navigator.of(context).pop(),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Registro',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _darkText,
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

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 4,
          bottom: 8,
        ),
        child: Text(
          text,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            height: 16 / 12,
            letterSpacing: 1.2,
            color: _darkText.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    String? error,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization =
        TextCapitalization.none,
    ValueChanged<String>? onSubmitted,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: error != null
              ? const Color(0xFFEF4444)
              : _darkText.withValues(alpha: 0.1),
          width: error != null ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          if (prefixIcon != null)
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 13,
              ),
              child: prefixIcon,
            ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                ),
                border: InputBorder.none,
                contentPadding: prefixIcon == null
                    ? const EdgeInsets.only(left: 16)
                    : EdgeInsets.zero,
                isDense: true,
              ),
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: _darkText,
              ),
              onSubmitted: onSubmitted,
            ),
          ),
          if (suffixIcon != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: suffixIcon,
            ),
        ],
      ),
    );
  }

  Widget _buildErrorText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFEF4444),
          ),
        ),
      ),
    );
  }
}
