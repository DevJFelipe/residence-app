import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'condo_profile_screen.dart';

class AllCondosScreen extends StatefulWidget {
  final List<Map<String, dynamic>> condos;
  final bool searchMode;

  const AllCondosScreen({super.key, required this.condos, this.searchMode = false});

  @override
  State<AllCondosScreen> createState() => _AllCondosScreenState();
}

class _AllCondosScreenState extends State<AllCondosScreen> {
  static const Color _dark = Color(0xFF0F172A);

  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.condos;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final lower = query.toLowerCase();
    setState(() {
      if (lower.isEmpty) {
        _filtered = widget.condos;
      } else {
        _filtered = widget.condos.where((c) {
          final name = (c['name'] as String? ?? '').toLowerCase();
          final location = (c['location'] as String? ?? '').toLowerCase();
          return name.contains(lower) || location.contains(lower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: MediaQuery.of(context).padding.top + (widget.searchMode ? 120 : 64)),
                ),
                if (_filtered.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'No se encontraron conjuntos',
                        style: GoogleFonts.publicSans(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList.separated(
                      itemCount: _filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final condo = _filtered[index];
                        return _CondoListCard(
                          condo: condo,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CondoProfileScreen(condo: condo),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
                ),
              ],
            ),
            _buildTopBar(context),
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
              border: const Border(bottom: BorderSide(color: Color(0x1AEC5B13))),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: SizedBox(width: 40, height: 40, child: Center(
                          child: SvgPicture.asset('assets/icons/prof_back.svg', width: 16, height: 16),
                        )),
                      ),
                      const SizedBox(width: 8),
                      Text('Conjuntos destacados', style: GoogleFonts.publicSans(
                        fontSize: 18, fontWeight: FontWeight.w700, height: 28/18, letterSpacing: -0.45, color: _dark,
                      )),
                    ],
                  ),
                  if (widget.searchMode) ...[
                    const SizedBox(height: 12),
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.borderLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: _onSearchChanged,
                        style: GoogleFonts.publicSans(fontSize: 15, color: _dark),
                        decoration: InputDecoration(
                          hintText: 'Buscar por nombre o ciudad...',
                          hintStyle: GoogleFonts.publicSans(fontSize: 15, color: const Color(0xFF94A3B8)),
                          prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF94A3B8)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CondoListCard extends StatelessWidget {
  final Map<String, dynamic> condo;
  final VoidCallback onTap;

  const _CondoListCard({required this.condo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCondoImage(condo['image'], double.infinity, 180),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    condo['name'] as String,
                    style: GoogleFonts.publicSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 24 / 18,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
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
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _statChip('${condo['towers']} Torres'),
                      const SizedBox(width: 8),
                      _statChip('${condo['units']} Uds'),
                      const SizedBox(width: 8),
                      _statChip('Estrato ${condo['estrato']}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x0DEC5B13),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.publicSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
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
