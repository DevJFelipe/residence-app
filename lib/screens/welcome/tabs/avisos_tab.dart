import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class AvisosTab extends StatelessWidget {
  const AvisosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 64),
          const SizedBox(height: 24),
          _buildHeader(),
          const SizedBox(height: 24),
          _buildPublicNotices(),
          const SizedBox(height: 32),
          _buildNewsSection(),
          const SizedBox(height: 32),
          _buildTipsSection(),
          SizedBox(height: 80 + MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Avisos y noticias',
            style: GoogleFonts.publicSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 36 / 28,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mantente informado sobre lo que sucede en tu comunidad residencial.',
            style: GoogleFonts.publicSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 24 / 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicNotices() {
    final notices = [
      {
        'tag': 'MANTENIMIENTO',
        'tagColor': const Color(0xFFEF4444),
        'tagBg': const Color(0x1AEF4444),
        'title': 'Mantenimiento programado de ascensores',
        'desc': 'Se realizará mantenimiento preventivo en todos los ascensores del conjunto los días 15 y 16 de abril.',
        'date': 'Hace 2 horas',
      },
      {
        'tag': 'EVENTO',
        'tagColor': const Color(0xFF3B82F6),
        'tagBg': const Color(0x1A3B82F6),
        'title': 'Asamblea general de copropietarios',
        'desc': 'Se convoca a todos los propietarios a la asamblea ordinaria el próximo sábado 19 de abril a las 9:00 AM.',
        'date': 'Hace 1 día',
      },
      {
        'tag': 'SEGURIDAD',
        'tagColor': AppColors.primary,
        'tagBg': const Color(0x0DEC5B13),
        'title': 'Nuevas medidas de control de acceso',
        'desc': 'A partir del 1 de mayo se implementará un nuevo sistema de control de acceso con código QR para visitantes.',
        'date': 'Hace 3 días',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Avisos recientes',
            style: GoogleFonts.publicSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 28 / 18,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          ...notices.map((n) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: n['tagBg'] as Color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          n['tag'] as String,
                          style: GoogleFonts.publicSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: n['tagColor'] as Color,
                          ),
                        ),
                      ),
                      Text(
                        n['date'] as String,
                        style: GoogleFonts.publicSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    n['title'] as String,
                    style: GoogleFonts.publicSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 22 / 15,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    n['desc'] as String,
                    style: GoogleFonts.publicSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 20 / 13,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildNewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Noticias de la plataforma',
            style: GoogleFonts.publicSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 28 / 18,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0x0DEC5B13),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.campaign_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nueva versión disponible',
                        style: GoogleFonts.publicSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hemos mejorado la experiencia de pagos y añadido nuevas funcionalidades.',
                        style: GoogleFonts.publicSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 20 / 13,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSection() {
    final tips = [
      {'icon': Icons.notifications_active_rounded, 'text': 'Activa las notificaciones para no perderte avisos importantes'},
      {'icon': Icons.person_add_rounded, 'text': 'Registra tus visitantes con anticipación para agilizar el acceso'},
      {'icon': Icons.calendar_month_rounded, 'text': 'Reserva áreas comunes desde la app con hasta 7 días de anticipación'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consejos útiles',
            style: GoogleFonts.publicSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 28 / 18,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          ...tips.map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(t['icon'] as IconData, color: const Color(0xFF16A34A), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t['text'] as String,
                      style: GoogleFonts.publicSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 20 / 13,
                        color: const Color(0xFF15803D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
