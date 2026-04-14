import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../login/login_screen.dart';

class PerfilTab extends StatelessWidget {
  const PerfilTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 64),
          const SizedBox(height: 40),
          _buildAvatar(),
          const SizedBox(height: 24),
          _buildLoginPrompt(context),
          const SizedBox(height: 40),
          _buildFeaturesList(),
          const SizedBox(height: 32),
          _buildAppInfo(),
          SizedBox(height: 80 + MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.borderLight,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.divider, width: 2),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            size: 40,
            color: Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Bienvenido',
          style: GoogleFonts.publicSans(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 32 / 24,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Inicia sesión para acceder a tu perfil',
          style: GoogleFonts.publicSans(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.primary,
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
                child: Text(
                  'Iniciar sesión',
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
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      {'icon': Icons.home_rounded, 'title': 'Mi unidad', 'desc': 'Información de tu apartamento'},
      {'icon': Icons.receipt_long_rounded, 'title': 'Historial de pagos', 'desc': 'Consulta tus recibos y facturas'},
      {'icon': Icons.calendar_today_rounded, 'title': 'Mis reservas', 'desc': 'Gestiona tus reservas de áreas comunes'},
      {'icon': Icons.support_agent_rounded, 'title': 'Mis PQRS', 'desc': 'Seguimiento a tus solicitudes'},
      {'icon': Icons.settings_rounded, 'title': 'Configuración', 'desc': 'Notificaciones y preferencias'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Al iniciar sesión podrás acceder a',
            style: GoogleFonts.publicSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0x0DEC5B13),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      f['icon'] as IconData,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f['title'] as String,
                          style: GoogleFonts.publicSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          f['desc'] as String,
                          style: GoogleFonts.publicSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 16,
                    color: Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAppInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Divider(color: AppColors.borderLight),
          const SizedBox(height: 16),
          Text(
            'Residence App v1.0.0',
            style: GoogleFonts.publicSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Términos de servicio  •  Política de privacidad',
            style: GoogleFonts.publicSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
