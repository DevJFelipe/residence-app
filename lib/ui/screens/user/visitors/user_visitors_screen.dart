import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:residence_app/core/api_client.dart';
import 'package:residence_app/core/session_manager.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_text_styles.dart';

class UserVisitorsScreen extends StatefulWidget {
  const UserVisitorsScreen({super.key});

  @override
  State<UserVisitorsScreen> createState() => _UserVisitorsScreenState();
}

class _UserVisitorsScreenState extends State<UserVisitorsScreen> {
  final _dio = ApiClient().dio;
  List<Map<String, dynamic>> _pendingVisitors = [];
  List<Map<String, dynamic>> _activeVisitors = [];
  List<Map<String, dynamic>> _recentLog = [];
  bool _loading = true;
  String? _error;

  // Form
  final _nameController = TextEditingController();
  final _docController = TextEditingController();
  final _plateController = TextEditingController();
  final _notesController = TextEditingController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _docController.dispose();
    _plateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _confirmExit(String visitorId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Marcar salida'),
        content: const Text('¿Confirmas que el visitante se retiró?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar', style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await _dio.post('/api/v1/visitors/me/$visitorId/exit');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Salida registrada')),
      );
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _registerVisitor() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el nombre del visitante')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await _dio.post('/api/v1/visitors/me', data: {
        'visitor_name': name,
        if (_docController.text.trim().isNotEmpty)
          'document_number': _docController.text.trim(),
        if (_plateController.text.trim().isNotEmpty)
          'vehicle_plate': _plateController.text.trim(),
        if (_notesController.text.trim().isNotEmpty)
          'notes': _notesController.text.trim(),
      });

      _nameController.clear();
      _docController.clear();
      _plateController.clear();
      _notesController.clear();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visitante registrado exitosamente')),
      );
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Get user's property_id to filter visitors
      String? propertyId;
      try {
        final meResp = await _dio.get('/api/v1/auth/me');
        final userData = meResp.data['data'];
        final props = userData?['properties'] as List?;
        if (props != null && props.isNotEmpty) {
          propertyId = props.first['property_id']?.toString();
        }
      } catch (_) {
        // Fallback: try SessionManager
        final user = await SessionManager().getUser();
        if (user != null) {
          final props = user['properties'] as List?;
          if (props != null && props.isNotEmpty) {
            propertyId = (props.first['property_id'] ?? props.first['id'])?.toString();
          }
        }
      }

      final qp = <String, dynamic>{'limit': 20};
      final activeQp = <String, dynamic>{};
      if (propertyId != null) {
        qp['property_id'] = propertyId;
        activeQp['property_id'] = propertyId;
      }

      final results = await Future.wait([
        _dio.get('/api/v1/visitors/active', queryParameters: activeQp),
        _dio.get('/api/v1/visitors/', queryParameters: qp),
      ]);

      final active = List<Map<String, dynamic>>.from(results[0].data['data'] ?? []);
      final all = List<Map<String, dynamic>>.from(results[1].data['data'] ?? []);
      final pending = all.where((v) => v['status'] == 'pre_registered').toList();
      final exited = all.where((v) => v['exit_time'] != null).toList();

      if (!mounted) return;
      setState(() {
        _pendingVisitors = pending;
        _activeVisitors = active;
        _recentLog = exited;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error al cargar visitantes';
        _loading = false;
      });
    }
  }

  String _formatTime(String? isoTime) {
    if (isoTime == null) return '--';
    var parsed = DateTime.parse(isoTime);
    if (parsed.isUtc == false && !isoTime.endsWith('Z')) {
      parsed = DateTime.utc(parsed.year, parsed.month, parsed.day,
          parsed.hour, parsed.minute, parsed.second);
    }
    final dt = parsed.toLocal();
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary))
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_error!, style: AppTextStyles.bodyMedium),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: _load,
                              child: Text('Reintentar',
                                  style: AppTextStyles.bold14
                                      .copyWith(color: AppColors.primary)),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: _load,
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                          children: [
                            _buildRegisterForm(),
                            if (_pendingVisitors.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              _buildPendingSection(),
                            ],
                            const SizedBox(height: 24),
                            _buildActiveSection(),
                            const SizedBox(height: 28),
                            _buildLogSection(),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/visitor_active_list.svg',
            width: 22,
            height: 12,
            colorFilter:
                const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
          ),
          const SizedBox(width: 10),
          Text(
            'Visitantes',
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
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
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
          Row(
            children: [
              const Icon(Icons.person_add_alt_1_rounded,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Registrar Visitante',
                style: GoogleFonts.publicSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _formField(_nameController, 'Nombre del visitante *'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _formField(_docController, 'Documento')),
              const SizedBox(width: 10),
              Expanded(child: _formField(_plateController, 'Placa vehículo')),
            ],
          ),
          const SizedBox(height: 10),
          _formField(_notesController, 'Notas (opcional)'),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: _submitting ? null : _registerVisitor,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _submitting
                      ? AppColors.primary.withValues(alpha: 0.5)
                      : AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Registrar entrada',
                          style: GoogleFonts.publicSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formField(TextEditingController controller, String hint) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.publicSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.publicSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildPendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFF59E0B),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Pendientes de entrada',
              style: GoogleFonts.publicSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${_pendingVisitors.length}',
                style: GoogleFonts.publicSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(_pendingVisitors.length, (i) {
          final v = _pendingVisitors[i];
          return Container(
            margin: EdgeInsets.only(
                bottom: i < _pendingVisitors.length - 1 ? 8 : 0),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.schedule_rounded,
                    size: 20,
                    color: Color(0xFFF59E0B),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v['visitor_name'] ?? '',
                        style: GoogleFonts.publicSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Esperando confirmación en portería',
                        style: GoogleFonts.publicSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildActiveSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF22C55E),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Visitantes Activos',
              style: GoogleFonts.publicSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${_activeVisitors.length}',
                style: GoogleFonts.publicSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_activeVisitors.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              children: [
                Icon(Icons.people_outline_rounded,
                    size: 36, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                const SizedBox(height: 8),
                Text(
                  'No hay visitantes activos',
                  style: GoogleFonts.publicSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          )
        else
          ...List.generate(_activeVisitors.length, (i) {
            final v = _activeVisitors[i];
            return Container(
              margin: EdgeInsets.only(bottom: i < _activeVisitors.length - 1 ? 8 : 0),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          v['visitor_name'] ?? '',
                          style: GoogleFonts.publicSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          v['property_number'] != null
                              ? 'Apto ${v['property_number']}'
                              : '--',
                          style: GoogleFonts.publicSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatTime(v['entry_time']?.toString()),
                        style: GoogleFonts.publicSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => _confirmExit(v['id']?.toString() ?? ''),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            'Marcar salida',
                            style: GoogleFonts.publicSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFEF4444),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildLogSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/visitor_history.svg',
              width: 16,
              height: 16,
              colorFilter:
                  const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            Text(
              'Historial Reciente',
              style: GoogleFonts.publicSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_recentLog.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Text(
              'Sin registros recientes',
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: List.generate(_recentLog.length, (i) {
                final v = _recentLog[i];
                return Column(
                  children: [
                    if (i > 0)
                      const Divider(
                          height: 1,
                          indent: 14,
                          endIndent: 14,
                          color: AppColors.borderLight),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.person_outline_rounded,
                              size: 18,
                              color: AppColors.textSecondary.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  v['visitor_name'] ?? '',
                                  style: GoogleFonts.publicSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                Text(
                                  v['property_number'] != null
                                      ? 'Apto ${v['property_number']}'
                                      : '--',
                                  style: GoogleFonts.publicSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatTime(v['entry_time']?.toString()),
                                style: GoogleFonts.publicSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDark,
                                ),
                              ),
                              Text(
                                '→ ${_formatTime(v['exit_time']?.toString())}',
                                style: GoogleFonts.publicSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
      ],
    );
  }
}
