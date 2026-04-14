import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/condo_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../login/login_screen.dart';
import '../../profile/condo_profile_screen.dart';
import '../../profile/all_condos_screen.dart';

class ExplorarTab extends ConsumerWidget {
  const ExplorarTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 64),
          _buildHeroSection(),
          _buildSearchSection(context, ref),
          const SizedBox(height: 32),
          _buildFeaturedCondos(context, ref),
          const SizedBox(height: 32),
          _buildFeatureGrid(),
          const SizedBox(height: 32),
          _buildCtaSection(),
          SizedBox(height: 80 + MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return SizedBox(
      height: 450,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/welcome_hero.png', fit: BoxFit.cover),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00221610),
                  Color(0x33221610),
                  AppColors.background,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'La plataforma\ninteligente para tu\nconjunto\nresidencial',
                    style: GoogleFonts.publicSans(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      height: 45 / 36,
                      color: const Color(0xFFF8FAFC),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Opacity(
                    opacity: 0.9,
                    child: Text(
                      'Simplifica tu vida en comunidad con\ntecnología diseñada para tu hogar.',
                      style: GoogleFonts.publicSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        height: 28 / 18,
                        color: const Color(0xFFF0FDF4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context, WidgetRef ref) {
    return Transform.translate(
      offset: const Offset(0, -32),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x0DEC5B13)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 25,
                offset: Offset(0, 20),
                spreadRadius: -5,
              ),
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 10,
                offset: Offset(0, 8),
                spreadRadius: -6,
              ),
            ],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  final condos = ref.read(featuredCondosProvider).valueOrNull ?? [];
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AllCondosScreen(condos: condos, searchMode: true),
                    ),
                  );
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 17),
                        child: SvgPicture.asset(
                          'assets/icons/welcome_search.svg',
                          width: 30,
                          height: 18,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Busca tu conjunto por nombre...',
                            style: GoogleFonts.publicSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCondos(BuildContext context, WidgetRef ref) {
    final asyncCondos = ref.watch(featuredCondosProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Conjuntos destacados',
                style: GoogleFonts.publicSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 28 / 20,
                  color: AppColors.textDark,
                ),
              ),
              GestureDetector(
                onTap: () {
                  final condos = asyncCondos.valueOrNull ?? [];
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AllCondosScreen(condos: condos),
                    ),
                  );
                },
                child: Text(
                  'Ver todos',
                  style: GoogleFonts.publicSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 20 / 14,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          asyncCondos.when(
            data: (condos) => SizedBox(
              height: 208,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: condos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final condo = condos[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CondoProfileScreen(condo: condo),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 256,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildCondoImage(condo['image'], 256, 160),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            condo['name'] as String,
                            style: GoogleFonts.publicSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              height: 24 / 16,
                              color: AppColors.textDark,
                            ),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/welcome_pin.svg',
                                width: 9.333,
                                height: 11.667,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                condo['location'] as String,
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            loading: () => const SizedBox(
              height: 208,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
            error: (_, __) => const SizedBox(
              height: 208,
              child: Center(
                child: Text('Error al cargar conjuntos'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      {'icon': 'assets/icons/feat_payments.svg', 'label': 'Gestión de pagos', 'w': 22.0, 'h': 16.0},
      {'icon': 'assets/icons/feat_visitors.svg', 'label': 'Control visitantes', 'w': 16.0, 'h': 20.0},
      {'icon': 'assets/icons/feat_areas.svg', 'label': 'Áreas comunes', 'w': 18.0, 'h': 20.0},
      {'icon': 'assets/icons/feat_pqrs.svg', 'label': 'PQRS', 'w': 20.0, 'h': 20.0},
      {'icon': 'assets/icons/feat_news.svg', 'label': 'Noticias', 'w': 20.0, 'h': 18.0},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Todo lo que necesitas',
            style: GoogleFonts.publicSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 28 / 20,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              mainAxisExtent: 108,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final f = features[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0x0DEC5B13),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            f['icon'] as String,
                            width: f['w'] as double,
                            height: f['h'] as double,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        f['label'] as String,
                        style: GoogleFonts.publicSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 20 / 14,
                          color: AppColors.textDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCtaSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.textDark,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Text(
              '¿Llevas la\nadministración?',
              style: GoogleFonts.publicSans(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 32 / 24,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Empieza a digitalizar tu comunidad\nhoy mismo con nuestras\nherramientas avanzadas.',
                style: GoogleFonts.publicSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 24 / 16,
                  color: const Color(0xFF94A3B8),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () {
                final url = Uri.parse('https://wa.me/573123969747?text=${Uri.encodeComponent('Hola, quiero registrar mi conjunto en Residence App')}');
                launchUrl(url, mode: LaunchMode.externalApplication);
              },
              child: Text(
                'Registra tu conjunto aquí →',
                style: GoogleFonts.publicSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 24 / 16,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCondoImage(dynamic imagePath, double width, double height) {
    if (imagePath != null && imagePath.toString().startsWith('assets/')) {
      return Image.asset(imagePath as String, width: width, height: height, fit: BoxFit.cover);
    }
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFE2E8F0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apartment_rounded, size: 40, color: AppColors.primary.withValues(alpha: 0.6)),
          const SizedBox(height: 4),
          Text('Residence', style: GoogleFonts.publicSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary.withValues(alpha: 0.6))),
        ],
      ),
    );
  }
}
