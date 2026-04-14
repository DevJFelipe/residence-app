import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/providers/auth_provider.dart';
import 'package:residence_app/services/auth_service.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static const Color _bgColor = Color(0xFFF7F4EF);
  static const Color _darkText = Color(0xFF0F1B2D);
  static const Color _primary = Color(0xFFEC5B13);

  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;
  String? _generalError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;
    setState(() {
      _emailError = null;
      _passwordError = null;
      _generalError = null;
    });

    if (email.isEmpty) {
      setState(
        () => _emailError = 'Ingrese su correo electrónico',
      );
      return;
    }
    if (password.isEmpty) {
      setState(
        () => _passwordError = 'Ingrese su contraseña',
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _authService.login(
        email,
        password,
      );
      if (!mounted) return;

      // Update auth state — GoRouter's redirect will navigate automatically
      ref.read(authStateProvider.notifier).setAuthenticated(
        role: response.isAdmin ? 'admin' : 'user',
        email: response.email,
        name: response.fullName,
      );
      // No need for context.go — the router redirect handles navigation
      // when authStateProvider changes (via refreshListenable).
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _generalError = AuthService.parseError(e);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _generalError = '$e';
        _isLoading = false;
      });
    }
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
              _buildLoginForm(),
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
      height: 380,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/login_hero.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: _darkText.withValues(alpha: 0.6),
          ),
          // Back button
          Positioned(
            top: topPadding + 12,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
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
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      letterSpacing: -1.2,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  'Gestión exclusiva de tu comunidad',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    height: 28 / 20,
                    letterSpacing: 0.5,
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

  Widget _buildLoginForm() {
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
              color: Color(0x40000000),
              blurRadius: 50,
              offset: Offset(0, 25),
              spreadRadius: -12,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
          child: Column(
            children: [
              // Title
              Text(
                'Iniciar sesión',
                style: GoogleFonts.dmSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 32 / 24,
                  color: _darkText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Ingresa tus credenciales para continuar',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 24 / 16,
                  color: _darkText.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
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

              // Email field
              _buildLabel('CORREO ELECTRÓNICO'),
              _buildInput(
                controller: _emailController,
                hint: 'ejemplo@residence.com',
                error: _emailError,
                prefixIcon: SvgPicture.asset(
                  'assets/icons/login_mail.svg',
                  width: 20,
                  height: 16,
                ),
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (_) => _login(),
              ),
              if (_emailError != null)
                _buildErrorText(_emailError!),
              const SizedBox(height: 20),

              // Password field
              _buildLabel('CONTRASEÑA'),
              _buildInput(
                controller: _passwordController,
                hint: '••••••••',
                error: _passwordError,
                obscureText: _obscurePassword,
                prefixIcon: Icon(
                  Icons.lock_outline,
                  size: 20,
                  color: _darkText.withValues(alpha: 0.4),
                ),
                suffixIcon: GestureDetector(
                  onTap: () => setState(
                    () => _obscurePassword = !_obscurePassword,
                  ),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: _darkText.withValues(alpha: 0.4),
                  ),
                ),
                onSubmitted: (_) => _login(),
              ),
              if (_passwordError != null)
                _buildErrorText(_passwordError!),
              const SizedBox(height: 12),

              // Forgot password link
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  ),
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Login button
              GestureDetector(
                onTap: _isLoading ? null : _login,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: _primary,
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
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            'Iniciar sesión',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
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

  Widget _buildFooter() {
    return Transform.translate(
      offset: const Offset(0, -40),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
        child: Center(
          child: Text(
            '© ${DateTime.now().year} Residence • Gestión Exclusiva',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
              letterSpacing: 1.2,
              color: _darkText.withValues(alpha: 0.4),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
