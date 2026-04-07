import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reservation_screen.dart';

enum AmenityStatus { disponible, mantenimiento }

class _AmenityData {
  final String image;
  final String title;
  final String capacity;
  final String description;
  final AmenityStatus status;

  const _AmenityData({
    required this.image,
    required this.title,
    required this.capacity,
    required this.description,
    required this.status,
  });
}

class AmenitiesScreen extends StatelessWidget {
  final bool embedded;
  const AmenitiesScreen({super.key, this.embedded = false});

  static const Color _bg = Color(0xFFF7F4EF);
  static const Color _darkText = Color(0xFF0F1B2D);
  static const Color _bodyText = Color(0xFF4A5568);
  static const Color _accent = Color(0xFFC2783A);

  static const List<_AmenityData> _amenities = [
    _AmenityData(
      image: 'assets/images/area_pool.png',
      title: 'Piscina climatizada',
      capacity: 'Capacidad: 20 personas',
      description:
          'Disfruta de una temperatura ideal todo el año en nuestra piscina cubierta con sistema de calefacción ecológico.',
      status: AmenityStatus.disponible,
    ),
    _AmenityData(
      image: 'assets/images/area_salon.png',
      title: 'Salón social',
      capacity: 'Capacidad: 50 personas',
      description:
          'Espacio amplio y elegante equipado con mobiliario moderno para tus eventos y celebraciones más especiales.',
      status: AmenityStatus.disponible,
    ),
    _AmenityData(
      image: 'assets/images/area_tennis.png',
      title: 'Cancha de tenis',
      capacity: 'Capacidad: 4 personas',
      description:
          'Cancha de polvo de ladrillo reglamentaria con iluminación nocturna. Actualmente en adecuación de drenaje.',
      status: AmenityStatus.mantenimiento,
    ),
    _AmenityData(
      image: 'assets/images/area_bbq.png',
      title: 'Zona BBQ',
      capacity: 'Capacidad: 12 personas',
      description:
          'Área campestre equipada con parrilla profesional y zona de comedor al aire libre rodeada de jardines.',
      status: AmenityStatus.disponible,
    ),
    _AmenityData(
      image: 'assets/images/area_gym.png',
      title: 'Gimnasio',
      capacity: 'Capacidad: 8 personas',
      description:
          'Equipamiento de última generación para cardio y fuerza, con aire acondicionado y vista al parque central.',
      status: AmenityStatus.disponible,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: _bg,
        body: Stack(
          children: [
            // Scrollable content
            CustomScrollView(
              slivers: [
                // Space for header
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).padding.top + 58,
                  ),
                ),
                // Cards list
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < _amenities.length - 1 ? 24 : 80,
                          ),
                          child: _buildCard(context, _amenities[index]),
                        );
                      },
                      childCount: _amenities.length,
                    ),
                  ),
                ),
              ],
            ),
            // Fixed header
            _buildHeader(context),
            // Fixed bottom nav (only when standalone)
            if (!embedded) _buildBottomNav(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              color: _bg.withValues(alpha: 0.8),
              border: Border(
                bottom: BorderSide(color: _darkText.withValues(alpha: 0.1)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/area_back.svg',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Áreas Comunes',
                        style: GoogleFonts.publicSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 25 / 20,
                          color: _darkText,
                        ),
                      ),
                      Text(
                        'CONJUNTO RESIDENCIAL EL NOGAL',
                        style: GoogleFonts.publicSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 16 / 12,
                          letterSpacing: 0.6,
                          color: _accent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, _AmenityData amenity) {
    final isAvailable = amenity.status == AmenityStatus.disponible;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _darkText.withValues(alpha: 0.05)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + badge
          SizedBox(
            height: 192,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(amenity.image, fit: BoxFit.cover),
                Positioned(
                  top: 9,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      isAvailable ? 'DISPONIBLE' : 'MANTENIMIENTO',
                      style: GoogleFonts.publicSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        height: 15 / 10,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Opacity(
            opacity: isAvailable ? 1.0 : 0.8,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    amenity.title,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 32 / 24,
                      color: _darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Capacity
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/area_capacity.svg',
                        width: 14,
                        height: 7,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        amenity.capacity,
                        style: GoogleFonts.publicSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 20 / 14,
                          color: _bodyText,
                        ),
                      ),
                    ],
                  ),
                  // Description
                  Padding(
                    padding: const EdgeInsets.only(top: 7.25, bottom: 16),
                    child: Text(
                      amenity.description,
                      style: GoogleFonts.publicSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 22.75 / 14,
                        color: _bodyText,
                      ),
                    ),
                  ),
                  // Button
                  GestureDetector(
                    onTap: isAvailable
                        ? () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ReservationScreen(),
                              ),
                            )
                        : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? _accent
                            : const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isAvailable ? 'Reservar ahora' : 'No disponible',
                            style: GoogleFonts.publicSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 24 / 16,
                              color: isAvailable
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SvgPicture.asset(
                            isAvailable
                                ? 'assets/icons/area_arrow_right.svg'
                                : 'assets/icons/area_lock.svg',
                            width: isAvailable ? 13.5 : 15,
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final navItems = [
      {'icon': 'assets/icons/area_nav_home.svg', 'label': 'Inicio', 'active': false, 'w': 16.0, 'h': 18.0},
      {'icon': 'assets/icons/area_nav_areas.svg', 'label': 'Áreas', 'active': true, 'w': 19.3, 'h': 19.3},
      {'icon': 'assets/icons/area_nav_reservas.svg', 'label': 'Reservas', 'active': false, 'w': 18.0, 'h': 20.0},
      {'icon': 'assets/icons/area_nav_perfil.svg', 'label': 'Perfil', 'active': false, 'w': 16.0, 'h': 16.0},
    ];

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: _darkText.withValues(alpha: 0.1)),
          ),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 9,
          bottom: 24 + MediaQuery.of(context).padding.bottom,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: navItems.map((item) {
            final isActive = item['active'] as bool;
            final color = isActive ? _accent : _bodyText;
            return Column(
              mainAxisSize: MainAxisSize.min,
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
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.w500,
                    height: 15 / 10,
                    color: color,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
