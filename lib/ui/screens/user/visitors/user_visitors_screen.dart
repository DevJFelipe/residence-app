import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:residence_app/core/api_client.dart';
import 'package:residence_app/core/session_manager.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_decorations.dart';
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
    return Container(
      color: AppColors.surfaceWarm,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _loading
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary))
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
                            padding:
                                const EdgeInsets.fromLTRB(20, 24, 20, 32),
                            children: [
                              _buildRegisterForm(),
                              if (_pendingVisitors.isNotEmpty) ...[
                                const SizedBox(height: 28),
                                _buildPendingSection(),
                              ],
                              const SizedBox(height: 28),
                              _buildActiveSection(),
                              const SizedBox(height: 32),
                              _buildLogSection(),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.surfaceWarm,
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/visitor_active_list.svg',
            width: 24,
            height: 14,
            colorFilter:
                const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
          ),
          const SizedBox(width: 10),
          Text(
            'Visitantes',
            style: GoogleFonts.publicSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
              color: AppColors.textDarkWarm,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppDecorations.premiumCard(radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: AppDecorations.iconTile(tint: AppColors.primary),
                child: const Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Registrar Visitante',
                style: GoogleFonts.publicSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: AppColors.textDarkWarm,
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
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.surfaceWarmElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.publicSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textDarkWarm,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.publicSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textMutedWarm,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildPendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Pendientes de entrada',
          count: _pendingVisitors.length,
          accent: AppColors.warning,
        ),
        const SizedBox(height: 14),
        ...List.generate(_pendingVisitors.length, (i) {
          final v = _pendingVisitors[i];
          return Container(
            margin: EdgeInsets.only(
                bottom: i < _pendingVisitors.length - 1 ? 10 : 0),
            padding: const EdgeInsets.all(16),
            decoration: AppDecorations.premiumCard(radius: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: AppDecorations.iconTile(tint: AppColors.warning),
                  child: const Icon(
                    Icons.schedule_rounded,
                    size: 20,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v['visitor_name'] ?? '',
                        style: GoogleFonts.publicSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDarkWarm,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Esperando confirmación en portería',
                        style: GoogleFonts.publicSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.warning,
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

  Widget _buildSectionHeader(String title,
      {required int count, required Color accent}) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.publicSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: AppColors.textDarkWarm,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$count',
            style: GoogleFonts.publicSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Visitantes Activos',
          count: _activeVisitors.length,
          accent: AppColors.success,
        ),
        const SizedBox(height: 14),
        if (_activeVisitors.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: AppDecorations.premiumCard(radius: 16),
            child: Column(
              children: [
                Icon(
                  Icons.people_outline_rounded,
                  size: 36,
                  color: AppColors.textMutedWarm.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 10),
                Text(
                  'No hay visitantes activos',
                  style: GoogleFonts.publicSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMutedWarm,
                  ),
                ),
              ],
            ),
          )
        else
          ...List.generate(_activeVisitors.length, (i) {
            final v = _activeVisitors[i];
            return Container(
              margin: EdgeInsets.only(
                  bottom: i < _activeVisitors.length - 1 ? 10 : 0),
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.premiumCard(radius: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration:
                        AppDecorations.iconTile(tint: AppColors.success),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 20,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          v['visitor_name'] ?? '',
                          style: GoogleFonts.publicSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDarkWarm,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          v['property_number'] != null
                              ? 'Apto ${v['property_number']}'
                              : '--',
                          style: GoogleFonts.publicSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMutedWarm,
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
                          color: AppColors.textDarkWarm,
                        ),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => _confirmExit(v['id']?.toString() ?? ''),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Marcar salida',
                            style: GoogleFonts.publicSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                              color: AppColors.error,
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
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                  AppColors.textMutedWarm, BlendMode.srcIn),
            ),
            const SizedBox(width: 10),
            Text(
              'Historial Reciente',
              style: GoogleFonts.publicSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: AppColors.textDarkWarm,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (_recentLog.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: AppDecorations.premiumCard(radius: 16),
            child: Text(
              'Sin registros recientes',
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textMutedWarm,
              ),
            ),
          )
        else
          Container(
            decoration: AppDecorations.premiumCard(radius: 16),
            child: Column(
              children: List.generate(_recentLog.length, (i) {
                final v = _recentLog[i];
                return Column(
                  children: [
                    if (i > 0)
                      const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: AppColors.borderSubtle),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: AppDecorations.iconTile(
                                tint: AppColors.textMutedWarm),
                            child: const Icon(
                              Icons.person_outline_rounded,
                              size: 18,
                              color: AppColors.textMutedWarm,
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
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDarkWarm,
                                  ),
                                ),
                                Text(
                                  v['property_number'] != null
                                      ? 'Apto ${v['property_number']}'
                                      : '--',
                                  style: GoogleFonts.publicSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textMutedWarm,
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
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDarkWarm,
                                ),
                              ),
                              Text(
                                '→ ${_formatTime(v['exit_time']?.toString())}',
                                style: GoogleFonts.publicSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textMutedWarm,
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
