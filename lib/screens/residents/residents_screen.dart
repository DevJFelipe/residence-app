import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../services/residents_service.dart';
import 'add_resident_sheet.dart';

class ResidentsScreen extends StatefulWidget {
  const ResidentsScreen({super.key});

  @override
  State<ResidentsScreen> createState() => _ResidentsScreenState();
}

class _ResidentsScreenState extends State<ResidentsScreen> {
  final _service = ResidentsService();
  List<Map<String, dynamic>> _properties = [];
  // propertyId → list of residents
  final Map<String, List<Map<String, dynamic>>> _residents = {};
  // propertyId → expanded state
  final Set<String> _expanded = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final properties = await _service.getProperties();
      if (!mounted) return;
      setState(() {
        _properties = properties;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudieron cargar las unidades';
        _loading = false;
      });
    }
  }

  Future<void> _loadResidents(String propertyId) async {
    try {
      final residents = await _service.getResidents(propertyId);
      if (!mounted) return;
      setState(() {
        _residents[propertyId] = residents;
      });
    } catch (_) {
      // silently fail, show empty
    }
  }

  void _toggleExpand(String propertyId) {
    setState(() {
      if (_expanded.contains(propertyId)) {
        _expanded.remove(propertyId);
      } else {
        _expanded.add(propertyId);
        if (!_residents.containsKey(propertyId)) {
          _loadResidents(propertyId);
        }
      }
    });
  }

  void _showAddResident(Map<String, dynamic> property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddResidentSheet(
        propertyId: property['id'],
        propertyLabel: '${property['block'] ?? ''} ${property['number']}'.trim(),
        onAdded: () {
          _loadResidents(property['id']);
          _loadProperties();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary))
              : _error != null
                  ? _buildError()
                  : RefreshIndicator(
                      onRefresh: _loadProperties,
                      color: AppColors.primary,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _properties.length,
                        itemBuilder: (_, i) =>
                            _buildPropertyCard(_properties[i]),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              SvgPicture.asset('assets/icons/stat_residents.svg',
                  width: 28, height: 28),
              const SizedBox(width: 12),
              Text('Residentes', style: AppTextStyles.heading2),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  '${_properties.length} unidades',
                  style:
                      AppTextStyles.bold12.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error!, style: AppTextStyles.bodyLarge),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadProperties,
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child:
                const Text('Reintentar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property) {
    final id = property['id'] as String;
    final number = property['number'] ?? '';
    final block = property['block'] ?? '';
    final floor = property['floor'];
    final isExpanded = _expanded.contains(id);
    final residents = _residents[id];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.borderLight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Property header
          InkWell(
            onTap: () => _toggleExpand(id),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/stat_units.svg',
                        width: 22,
                        height: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$block $number'.trim(),
                          style: AppTextStyles.bold14
                              .copyWith(color: AppColors.textDark),
                        ),
                        if (floor != null)
                          Text(
                            'Piso $floor',
                            style: AppTextStyles.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  // Add button
                  GestureDetector(
                    onTap: () => _showAddResident(property),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.person_add_outlined,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Expand icon
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          // Residents list (expanded)
          if (isExpanded) ...[
            const Divider(height: 1, color: AppColors.borderLight),
            if (residents == null)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: AppColors.primary, strokeWidth: 2),
                  ),
                ),
              )
            else if (residents.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Sin residentes asignados',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else
              ...residents.map((r) => _buildResidentRow(r)),
          ],
        ],
      ),
    );
  }

  Widget _buildResidentRow(Map<String, dynamic> resident) {
    final name = resident['user_full_name'] ?? 'Sin nombre';
    final relation = resident['relation_type_name'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: GoogleFonts.publicSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.medium14),
                if (relation.isNotEmpty)
                  Text(
                    relation,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.successBackground,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'ACTIVO',
              style: AppTextStyles.bold10
                  .copyWith(color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }
}
