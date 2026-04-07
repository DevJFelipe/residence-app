import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../admin_shell.dart';
import '../user_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Design colors
  static const Color _bgColor = Color(0xFFF7F4EF);
  static const Color _darkText = Color(0xFF0F1B2D);
  static const Color _primary = Color(0xFFEC5B13);

  // ── Test credentials ──
  static const _testUsers = {
    'admin@residence.com': {'pin': '123456', 'role': 'admin'},
    'residente@residence.com': {'pin': '111111', 'role': 'user'},
  };

  // Controllers
  final _emailController = TextEditingController();
  final List<TextEditingController> _pinControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _pinFocusNodes = List.generate(6, (_) => FocusNode());

  // State
  bool _emailSubmitted = false;
  bool _isLoading = false;
  String? _emailError;
  String? _pinError;

  @override
  void dispose() {
    _emailController.dispose();
    for (final c in _pinControllers) {
      c.dispose();
    }
    for (final f in _pinFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String? _matchedRole;

  void _submitEmail() {
    final email = _emailController.text.trim().toLowerCase();
    setState(() => _emailError = null);

    if (email.isEmpty) {
      setState(() => _emailError = 'Ingrese su correo electrónico');
      return;
    }

    if (!_testUsers.containsKey(email)) {
      setState(() => _emailError = 'Correo no registrado. Pruebe:\n• admin@residence.com\n• residente@residence.com');
      return;
    }

    setState(() {
      _emailSubmitted = true;
      _emailError = null;
      _matchedRole = _testUsers[email]!['role'];
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinFocusNodes[0].requestFocus();
    });
  }

  Future<void> _verifyPin() async {
    final email = _emailController.text.trim().toLowerCase();
    final pin = _pinControllers.map((c) => c.text).join();
    setState(() => _pinError = null);

    if (pin.length < 6) {
      setState(() => _pinError = 'Ingrese los 6 dígitos');
      return;
    }

    final user = _testUsers[email];
    if (user == null || pin != user['pin']) {
      final correctPin = user?['pin'] ?? '???';
      setState(() => _pinError = 'Código incorrecto. Use: $correctPin');
      for (final c in _pinControllers) {
        c.clear();
      }
      _pinFocusNodes[0].requestFocus();
      return;
    }

    // Success — show loading then navigate based on role
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final isAdmin = user['role'] == 'admin';
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => isAdmin ? const AdminShell() : const UserShell(),
      ),
    );
  }

  void _resetToEmail() {
    setState(() {
      _emailSubmitted = false;
      _pinError = null;
      _matchedRole = null;
      for (final c in _pinControllers) {
        c.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _bgColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeroSection(context),
              _buildMainContent(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return SizedBox(
      height: 512.55,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/login_hero.png', fit: BoxFit.cover),
          Container(color: _darkText.withValues(alpha: 0.6)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: topPadding),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Residence',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 48, fontWeight: FontWeight.w700,
                      height: 1, letterSpacing: -1.2, color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  'Conjunto Residencial El Nogal',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 20, fontWeight: FontWeight.w400,
                    height: 28 / 20, letterSpacing: 0.5,
                    color: _bgColor.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Transform.translate(
      offset: const Offset(0, -40),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000), blurRadius: 50,
              offset: Offset(0, 25), spreadRadius: -12,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 48),
          child: Column(
            children: [
              _buildEmailSection(),
              _buildSecurityDivider(),
              _buildPinSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailSection() {
    return Column(
      children: [
        Text(
          'Bienvenido de nuevo',
          style: GoogleFonts.dmSans(
            fontSize: 18, fontWeight: FontWeight.w400,
            height: 28 / 18, color: _darkText.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Ingrese su correo electrónico para continuar',
          style: GoogleFonts.dmSans(
            fontSize: 16, fontWeight: FontWeight.w500,
            height: 24 / 16, color: _darkText,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        // Label
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'CORREO ELECTRÓNICO',
              style: GoogleFonts.dmSans(
                fontSize: 12, fontWeight: FontWeight.w700,
                height: 16 / 12, letterSpacing: 1.2,
                color: _darkText.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
        // Email input
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _emailError != null
                  ? const Color(0xFFEF4444)
                  : _emailSubmitted
                      ? const Color(0xFF22C55E)
                      : _darkText.withValues(alpha: 0.1),
              width: _emailError != null || _emailSubmitted ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 13),
                child: SvgPicture.asset('assets/icons/login_mail.svg', width: 20, height: 16),
              ),
              Expanded(
                child: TextField(
                  controller: _emailController,
                  enabled: !_emailSubmitted,
                  decoration: InputDecoration(
                    hintText: 'ejemplo@residence.com',
                    hintStyle: GoogleFonts.dmSans(
                      fontSize: 16, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: GoogleFonts.dmSans(
                    fontSize: 16, fontWeight: FontWeight.w400, color: _darkText,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSubmitted: (_) => _submitEmail(),
                ),
              ),
              if (_emailSubmitted)
                const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 20),
                ),
            ],
          ),
        ),
        // Error message
        if (_emailError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _emailError!,
                style: GoogleFonts.dmSans(
                  fontSize: 12, fontWeight: FontWeight.w500,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ),
          ),
        const SizedBox(height: 24),
        // "Siguiente →" button
        GestureDetector(
          onTap: _emailSubmitted ? _resetToEmail : _submitEmail,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: _emailSubmitted ? const Color(0xFF22C55E) : _darkText,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _emailSubmitted ? 'Correo verificado ✓' : 'Siguiente',
                  style: GoogleFonts.dmSans(
                    fontSize: 18, fontWeight: FontWeight.w700,
                    height: 28 / 18, color: _bgColor,
                  ),
                ),
                if (!_emailSubmitted) ...[
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/icons/login_arrow.svg', width: 16, height: 16),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        children: [
          Container(width: 48, height: 1, color: _darkText.withValues(alpha: 0.1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'SEGURIDAD',
              style: GoogleFonts.dmSans(
                fontSize: 10, fontWeight: FontWeight.w700,
                height: 15 / 10, letterSpacing: 2,
                color: _darkText.withValues(alpha: 0.3),
              ),
            ),
          ),
          Container(width: 48, height: 1, color: _darkText.withValues(alpha: 0.1)),
        ],
      ),
    );
  }

  Widget _buildPinSection() {
    final isEnabled = _emailSubmitted;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.4,
      child: IgnorePointer(
        ignoring: !isEnabled || _isLoading,
        child: Column(
          children: [
            Text(
              'Ingrese su código de acceso de 6 dígitos',
              style: GoogleFonts.dmSans(
                fontSize: 16, fontWeight: FontWeight.w500,
                height: 24 / 16, color: _darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _emailSubmitted
                  ? 'Código enviado a ${_emailController.text.trim()}'
                  : 'Enviamos un código de verificación a su correo',
              style: GoogleFonts.dmSans(
                fontSize: 14, fontWeight: FontWeight.w400,
                height: 20 / 14, color: _darkText.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // PIN boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Padding(
                  padding: EdgeInsets.only(left: index > 0 ? 8 : 0),
                  child: SizedBox(
                    width: 48,
                    height: 56,
                    child: TextField(
                      controller: _pinControllers[index],
                      focusNode: _pinFocusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: GoogleFonts.dmSans(
                        fontSize: 24, fontWeight: FontWeight.w700, color: _darkText,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: _pinError != null
                                ? const Color(0xFFEF4444)
                                : _darkText.withValues(alpha: 0.1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: _pinError != null
                                ? const Color(0xFFEF4444)
                                : _darkText.withValues(alpha: 0.1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: _primary, width: 2),
                        ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        setState(() => _pinError = null);
                        if (value.isNotEmpty && index < 5) {
                          _pinFocusNodes[index + 1].requestFocus();
                        }
                        if (value.isEmpty && index > 0) {
                          _pinFocusNodes[index - 1].requestFocus();
                        }
                        // Auto-verify when all 6 digits entered
                        final pin = _pinControllers.map((c) => c.text).join();
                        if (pin.length == 6) {
                          _verifyPin();
                        }
                      },
                    ),
                  ),
                );
              }),
            ),
            // Error message
            if (_pinError != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _pinError!,
                  style: GoogleFonts.dmSans(
                    fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFFEF4444),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 32),
            // "Verificar Acceso" button
            GestureDetector(
              onTap: _verifyPin,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: _primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Verificar Acceso',
                          style: GoogleFonts.dmSans(
                            fontSize: 18, fontWeight: FontWeight.w700,
                            height: 28 / 18, color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '¿No recibió el código? Reenviar',
              style: GoogleFonts.dmSans(
                fontSize: 14, fontWeight: FontWeight.w500,
                height: 20 / 14, color: _darkText.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            // Dev hint
            if (_emailSubmitted) ...[
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _darkText.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '🔑 PIN: ${_testUsers[_emailController.text.trim().toLowerCase()]?['pin'] ?? ''}',
                        style: GoogleFonts.dmSans(
                          fontSize: 12, fontWeight: FontWeight.w600,
                          color: _darkText.withValues(alpha: 0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _matchedRole == 'admin' ? '👤 Rol: Administrador' : '🏠 Rol: Residente',
                        style: GoogleFonts.dmSans(
                          fontSize: 11, fontWeight: FontWeight.w400,
                          color: _darkText.withValues(alpha: 0.35),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Transform.translate(
      offset: const Offset(0, -40),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
        child: Center(
          child: Text(
            '© 2024 Residence • Gestión Exclusiva',
            style: GoogleFonts.dmSans(
              fontSize: 12, fontWeight: FontWeight.w400,
              height: 16 / 12, letterSpacing: 1.2,
              color: _darkText.withValues(alpha: 0.4),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
