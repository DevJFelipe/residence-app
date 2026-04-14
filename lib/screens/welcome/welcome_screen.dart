import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../login/login_screen.dart';
import 'tabs/explorar_tab.dart';
import 'tabs/perfil_tab.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentIndex = 0;

  final _tabs = [
    const ExplorarTab(),
    const PerfilTab(),
  ];

  void _goToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // Tab content
            IndexedStack(
              index: _currentIndex,
              children: _tabs,
            ),
            // Fixed header
            _buildHeader(),
            // Fixed bottom nav
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.8),
              border: const Border(
                bottom: BorderSide(color: Color(0x1AEC5B13)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/welcome_logo.svg',
                            width: 15,
                            height: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Residence',
                        style: GoogleFonts.publicSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 28 / 20,
                          letterSpacing: -0.5,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  // Login button
                  GestureDetector(
                    onTap: _goToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(9999),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33EC5B13),
                            blurRadius: 15,
                            offset: Offset(0, 10),
                            spreadRadius: -3,
                          ),
                        ],
                      ),
                      child: Text(
                        'Iniciar sesión',
                        style: GoogleFonts.publicSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 20 / 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final navItems = [
      {'icon': 'assets/icons/wnav_explore.svg', 'label': 'EXPLORAR', 'w': 20.0, 'h': 20.0},
      {'icon': 'assets/icons/wnav_profile.svg', 'label': 'PERFIL', 'w': 20.0, 'h': 20.0},
    ];

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              border: const Border(
                top: BorderSide(color: AppColors.divider),
              ),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(navItems.length, (index) {
                  final item = navItems[index];
                  final isActive = index == _currentIndex;
                  final color = isActive
                      ? AppColors.primary
                      : const Color(0xFF94A3B8);
                  return GestureDetector(
                    onTap: () => setState(() => _currentIndex = index),
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            item['icon'] as String,
                            width: item['w'] as double,
                            height: item['h'] as double,
                            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['label'] as String,
                            style: GoogleFonts.publicSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              height: 15 / 10,
                              letterSpacing: 0.5,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
