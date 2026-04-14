import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/models/amenity_models.dart';
import 'package:residence_app/services/amenities_service.dart';
import 'reservation_screen.dart';

class AmenitiesScreen extends StatefulWidget {
  final bool embedded;
  const AmenitiesScreen({super.key, this.embedded = false});

  @override
  State<AmenitiesScreen> createState() => _AmenitiesScreenState();
}

class _AmenitiesScreenState extends State<AmenitiesScreen> {
  static const Color _bg = Color(0xFFF7F4EF);
  static const Color _darkText = Color(0xFF0F1B2D);
  static const Color _bodyText = Color(0xFF4A5568);
  static const Color _accent = Color(0xFFC2783A);

  final _service = AmenitiesService();
  List<Amenity> _amenities = [];
  bool _isLoading = true;
  String? _error;

  // Map amenity names to local asset images as fallback
  static const _imageMap = {
    'piscina': 'assets/images/area_pool.png',
    'salon': 'assets/images/area_salon.png',
    'salón': 'assets/images/area_salon.png',
    'tenis': 'assets/images/area_tennis.png',
    'cancha': 'assets/images/area_tennis.png',
    'bbq': 'assets/images/area_bbq.png',
    'parrilla': 'assets/images/area_bbq.png',
    'gimnasio': 'assets/images/area_gym.png',
    'gym': 'assets/images/area_gym.png',
  };

  String _getImageForAmenity(String name) {
    final lower = name.toLowerCase();
    for (final entry in _imageMap.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return 'assets/images/area_salon.png';
  }

  @override
  void initState() {
    super.initState();
    _loadAmenities();
  }

  Future<void> _loadAmenities() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final amenities = await _service.getAmenities();
      if (!mounted) return;
      setState(() {
        _amenities = amenities;
        _isLoading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AmenitiesService.parseError(e);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: _bg,
        body: Stack(
          children: [
            // Scrollable content
            RefreshIndicator(
              onRefresh: _loadAmenities,
              color: _accent,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).padding.top + 58,
                    ),
                  ),
                  if (_isLoading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_error != null)
                    SliverFillRemaining(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline,
                                  size: 48,
                                  color: _darkText.withValues(alpha: 0.3)),
                              const SizedBox(height: 16),
                              Text(_error!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.publicSans(
                                      color: _bodyText)),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: _loadAmenities,
                                child: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else if (_amenities.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No hay áreas comunes disponibles',
                          style: GoogleFonts.publicSans(color: _bodyText),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    index < _amenities.length - 1 ? 24 : 80,
                              ),
                              child:
                                  _buildCard(context, _amenities[index]),
                            );
                          },
                          childCount: _amenities.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _buildHeader(context),
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
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: _bg.withValues(alpha: 0.8),
              border: Border(
                bottom:
                    BorderSide(color: _darkText.withValues(alpha: 0.1)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
              child: Row(
                children: [
                  if (!widget.embedded)
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
                  if (!widget.embedded) const SizedBox(width: 16),
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

  Widget _buildCard(BuildContext context, Amenity amenity) {
    final isAvailable = amenity.isActive;
    final image = _getImageForAmenity(amenity.name);
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
                Image.asset(image, fit: BoxFit.cover),
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
                  Text(
                    amenity.name,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 32 / 24,
                      color: _darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (amenity.capacity != null)
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/area_capacity.svg',
                          width: 14,
                          height: 7,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Capacidad: ${amenity.capacity} personas',
                          style: GoogleFonts.publicSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 20 / 14,
                            color: _bodyText,
                          ),
                        ),
                      ],
                    ),
                  if (amenity.description != null)
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 7.25, bottom: 16),
                      child: Text(
                        amenity.description!,
                        style: GoogleFonts.publicSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 22.75 / 14,
                          color: _bodyText,
                        ),
                      ),
                    ),
                  if (amenity.description == null)
                    const SizedBox(height: 16),
                  // Pricing info
                  if (amenity.hourlyCost > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        '\$${amenity.hourlyCost.toStringAsFixed(0)}/hora',
                        style: GoogleFonts.publicSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _accent,
                        ),
                      ),
                    ),
                  // Button
                  GestureDetector(
                    onTap: isAvailable
                        ? () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ReservationScreen(amenity: amenity),
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
                            isAvailable
                                ? 'Reservar ahora'
                                : 'No disponible',
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
}
