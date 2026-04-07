import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class CondoProfileScreen extends StatelessWidget {
  const CondoProfileScreen({super.key});

  static const Color _dark = Color(0xFF0F172A);
  static const Color _body = Color(0xFF64748B);
  static const Color _sectionBorder = Color(0x1AEC5B13);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 64),
                  _buildHero(),
                  _buildStats(),
                  _buildInfoSection(),
                  _buildAmenities(),
                  _buildNews(),
                  _buildContact(),
                  // Space for footer
                  const SizedBox(height: 140),
                ],
              ),
            ),
            _buildTopBar(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.8),
              border: const Border(bottom: BorderSide(color: _sectionBorder)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: SizedBox(width: 40, height: 40, child: Center(
                      child: SvgPicture.asset('assets/icons/prof_back.svg', width: 16, height: 16),
                    )),
                  ),
                  Text('Residence', style: GoogleFonts.publicSans(
                    fontSize: 18, fontWeight: FontWeight.w700, height: 28/18, letterSpacing: -0.45, color: _dark,
                  )),
                  Row(children: [
                    SizedBox(width: 40, height: 40, child: Center(
                      child: SvgPicture.asset('assets/icons/prof_share.svg', width: 18, height: 20),
                    )),
                    const SizedBox(width: 8),
                    SizedBox(width: 40, height: 40, child: Center(
                      child: SvgPicture.asset('assets/icons/prof_heart.svg', width: 20, height: 18.35),
                    )),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/profile_hero.png', fit: BoxFit.cover),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter, end: Alignment.topCenter,
                colors: [Color(0x99000000), Color(0x00000000)],
              ),
            ),
          ),
          Positioned(
            left: 16, right: 16, bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary, borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    SvgPicture.asset('assets/icons/prof_badge.svg', width: 12.833, height: 12.25),
                    const SizedBox(width: 4),
                    Text('ACTIVO EN RESIDENCE', style: GoogleFonts.publicSans(
                      fontSize: 12, fontWeight: FontWeight.w700, height: 16/12, letterSpacing: 0.6, color: Colors.white,
                    )),
                  ]),
                ),
                const SizedBox(height: 8),
                Text('Conjunto Residencial El Nogal', style: GoogleFonts.publicSans(
                  fontSize: 24, fontWeight: FontWeight.w700, height: 30/24, color: Colors.white,
                )),
                const SizedBox(height: 4),
                Row(children: [
                  SvgPicture.asset('assets/icons/prof_pin.svg', width: 9.333, height: 11.667),
                  const SizedBox(width: 4),
                  Text('Bogotá, Colombia', style: GoogleFonts.publicSans(
                    fontSize: 14, fontWeight: FontWeight.w400, height: 20/14, color: Colors.white.withValues(alpha: 0.9),
                  )),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 25),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _sectionBorder))),
      child: Row(children: [
        Expanded(child: _statContent('5', 'Torres')),
        Expanded(child: Container(
          decoration: const BoxDecoration(border: Border(
            left: BorderSide(color: _sectionBorder), right: BorderSide(color: _sectionBorder),
          )),
          child: _statContent('240', 'Unidades'),
        )),
        Expanded(child: _statContent('5', 'Estrato')),
      ]),
    );
  }

  Widget _statContent(String value, String label) {
    return Column(children: [
      Text(value, style: GoogleFonts.publicSans(
        fontSize: 20, fontWeight: FontWeight.w700, height: 28/20, color: AppColors.primary,
      )),
      const SizedBox(height: 4),
      Text(label, style: GoogleFonts.publicSans(
        fontSize: 12, fontWeight: FontWeight.w500, height: 16/12, color: _body,
      )),
    ]);
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _sectionBorder))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle('Información General'),
        const SizedBox(height: 16),
        Row(children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: const Color(0x1AEC5B13), borderRadius: BorderRadius.circular(12)),
            child: Center(child: SvgPicture.asset('assets/icons/prof_location.svg', width: 18, height: 18)),
          ),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Calle 100 #15-30', style: GoogleFonts.publicSans(fontSize: 16, fontWeight: FontWeight.w700, height: 24/16, color: _dark)),
            Text('Localidad de Usaquén, Bogotá', style: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w400, height: 20/14, color: _body)),
          ]),
        ]),
        const SizedBox(height: 16),
        // Map placeholder
        Container(
          height: 160,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0x0DEC5B13), borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(children: [
            Opacity(opacity: 0.5, child: Image.asset('assets/images/profile_map.png', fit: BoxFit.cover, width: double.infinity, height: 160)),
            Center(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(9999),
                boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 15, offset: Offset(0, 10), spreadRadius: -3)],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                SvgPicture.asset('assets/icons/prof_mapbtn.svg', width: 10.5, height: 10.5),
                const SizedBox(width: 8),
                Text('Ver en Google Maps', style: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w700, height: 20/14, color: AppColors.primary)),
              ]),
            )),
          ]),
        ),
      ]),
    );
  }

  Widget _buildAmenities() {
    final amenities = [
      {'icon': 'assets/icons/prof_pool.svg', 'label': 'Piscina\nClimatizada', 'w': 20.0, 'h': 18.0, 'tall': true},
      {'icon': 'assets/icons/prof_gym.svg', 'label': 'Gimnasio', 'w': 19.8, 'h': 19.8, 'tall': true},
      {'icon': 'assets/icons/prof_bbq.svg', 'label': 'Zona BBQ', 'w': 20.0, 'h': 20.0, 'tall': false},
      {'icon': 'assets/icons/prof_playground.svg', 'label': 'Parque Infantil', 'w': 18.0, 'h': 18.0, 'tall': false},
      {'icon': 'assets/icons/prof_visitors.svg', 'label': 'Visitantes', 'w': 13.0, 'h': 18.0, 'tall': false},
      {'icon': 'assets/icons/prof_security.svg', 'label': 'Vigilancia 24/7', 'w': 16.0, 'h': 20.0, 'tall': false},
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _sectionBorder))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle('Amenidades'),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, mainAxisExtent: 50,
          ),
          itemCount: amenities.length,
          itemBuilder: (_, i) {
            final a = amenities[i];
            final isTall = (a['tall'] as bool?) ?? false;
            return Container(
              height: isTall ? 66 : 50,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x0DEC5B13)),
                boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))],
              ),
              child: Row(children: [
                SvgPicture.asset(a['icon'] as String, width: a['w'] as double, height: a['h'] as double),
                const SizedBox(width: 12),
                Text(a['label'] as String, style: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w500, height: 20/14, color: _dark)),
              ]),
            );
          },
        ),
        const SizedBox(height: 16),
        Center(child: Text('Mostrar las 12 amenidades', style: GoogleFonts.publicSans(
          fontSize: 14, fontWeight: FontWeight.w700, height: 20/14, color: AppColors.primary,
          decoration: TextDecoration.underline, decorationColor: AppColors.primary,
        ))),
      ]),
    );
  }

  Widget _buildNews() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _sectionBorder))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle('Noticias y Anuncios'),
        const SizedBox(height: 16),
        // Maintenance card
        _newsCard(
          borderColor: AppColors.primary,
          bgColor: const Color(0x0DEC5B13),
          badgeBg: const Color(0x1AEC5B13),
          badgeText: AppColors.primary,
          badge: 'MANTENIMIENTO',
          time: 'Hoy',
          title: 'Cierre temporal de ascensores Torre 2',
          body: 'Se realizará mantenimiento preventivo desde las 10:00 AM hasta las 2:00 PM.',
        ),
        const SizedBox(height: 16),
        // Community card
        _newsCard(
          borderColor: Colors.transparent,
          bgColor: AppColors.borderLight,
          badgeBg: AppColors.divider,
          badgeText: _body,
          badge: 'COMUNIDAD',
          time: 'Ayer',
          title: 'Nueva jornada de reciclaje',
          body: 'Acompáñanos este sábado en el salón comunal para aprender sobre separación de residuos.',
        ),
      ]),
    );
  }

  Widget _newsCard({
    required Color borderColor, required Color bgColor,
    required Color badgeBg, required Color badgeText,
    required String badge, required String time,
    required String title, required String body,
  }) {
    final hasLeftBorder = borderColor != Colors.transparent;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          border: hasLeftBorder ? Border(left: BorderSide(color: borderColor, width: 4)) : null,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(4)),
            child: Text(badge, style: GoogleFonts.publicSans(fontSize: 10, fontWeight: FontWeight.w700, height: 15/10, letterSpacing: 1, color: badgeText)),
          ),
          Text(time, style: GoogleFonts.publicSans(fontSize: 12, fontWeight: FontWeight.w400, height: 16/12, color: _body)),
        ]),
        const SizedBox(height: 8),
        Text(title, style: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w700, height: 20/14, color: _dark)),
        const SizedBox(height: 4),
        Text(body, style: GoogleFonts.publicSans(fontSize: 12, fontWeight: FontWeight.w400, height: 16/12, color: const Color(0xFF475569)), maxLines: 2, overflow: TextOverflow.ellipsis),
      ]),
      ),
    );
  }

  Widget _buildContact() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle('Contacto'),
        const SizedBox(height: 16),
        _contactRow('assets/icons/prof_phone.svg', 18, 18, 'Portería Principal', '+57 601 234 5678'),
        const SizedBox(height: 16),
        _contactRow('assets/icons/prof_email.svg', 20, 16, 'Administración', 'elnogal@residence.com'),
        const SizedBox(height: 16),
        _contactRow('assets/icons/prof_clock.svg', 20, 20, 'Horarios de Oficina', 'Lun - Vie: 8:00 AM - 5:00 PM'),
      ]),
    );
  }

  Widget _contactRow(String icon, double w, double h, String title, String subtitle) {
    return Row(children: [
      Container(
        width: 40, height: 40,
        decoration: const BoxDecoration(color: AppColors.borderLight, shape: BoxShape.circle),
        child: Center(child: SvgPicture.asset(icon, width: w, height: h)),
      ),
      const SizedBox(width: 16),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w700, height: 20/14, color: _dark)),
        Text(subtitle, style: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w400, height: 20/14, color: _body)),
      ]),
    ]);
  }

  Widget _sectionTitle(String text) {
    return Text(text, style: GoogleFonts.publicSans(fontSize: 20, fontWeight: FontWeight.w700, height: 28/20, color: _dark));
  }

  Widget _buildFooter(BuildContext context) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 17, 16, 16 + MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: const Border(top: BorderSide(color: _sectionBorder)),
          boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 12, offset: Offset(0, -4))],
        ),
        child: Column(children: [
          // Soy residente
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Soy residente', style: GoogleFonts.publicSans(fontSize: 16, fontWeight: FontWeight.w700, height: 24/16, color: Colors.white)),
              Row(children: [
                Text('Iniciar sesión', style: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w700, height: 20/14, color: Colors.white)),
                const SizedBox(width: 4),
                SvgPicture.asset('assets/icons/prof_arrow.svg', width: 16, height: 16),
              ]),
            ]),
          ),
          const SizedBox(height: 8),
          // Voy a visitar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0x1AEC5B13), borderRadius: BorderRadius.circular(12),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Voy a visitar', style: GoogleFonts.publicSans(fontSize: 16, fontWeight: FontWeight.w700, height: 24/16, color: AppColors.primary)),
              Row(children: [
                Text('Pre-registrarme', style: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w500, height: 20/14, color: AppColors.primary)),
                const SizedBox(width: 4),
                SvgPicture.asset('assets/icons/prof_qr.svg', width: 18, height: 18),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
