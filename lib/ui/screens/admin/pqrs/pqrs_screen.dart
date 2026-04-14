import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_text_styles.dart';
import 'package:residence_app/services/pqrs_service.dart';

class PqrsScreen extends StatefulWidget {
  const PqrsScreen({super.key});

  @override
  State<PqrsScreen> createState() => _PqrsScreenState();
}

class _PqrsScreenState extends State<PqrsScreen> {
  final _service = PqrsService();
  List<Map<String, dynamic>> _pqrs = [];
  List<Map<String, dynamic>> _statuses = [];
  bool _loading = true;
  String? _error;

  // null = todas, else status id
  int? _statusFilter;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        _service.getPqrs(statusId: _statusFilter),
        if (_statuses.isEmpty) _service.getPqrStatuses(),
      ]);
      if (!mounted) return;
      setState(() {
        _pqrs = results[0];
        if (_statuses.isEmpty && results.length > 1) {
          _statuses = results[1];
        }
        _loading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = PqrsService.parseError(e);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Error al cargar PQRS';
        _loading = false;
      });
    }
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final pqrs = await _service.getPqrs(statusId: _statusFilter);
      if (!mounted) return;
      setState(() {
        _pqrs = pqrs;
        _loading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = PqrsService.parseError(e);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Error al cargar PQRS';
        _loading = false;
      });
    }
  }

  void _onStatusChanged(int? statusId) {
    setState(() => _statusFilter = statusId);
    _reload();
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
                      onRefresh: _reload,
                      color: AppColors.primary,
                      child: Column(
                        children: [
                          _buildStatusTabs(),
                          _buildCountBadge(),
                          Expanded(
                            child: _pqrs.isEmpty
                                ? Center(
                                    child: Text('No hay PQRS',
                                        style: GoogleFonts.publicSans(
                                            color: Colors.grey)))
                                : ListView.separated(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 8, 16, 24),
                                    itemCount: _pqrs.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 10),
                                    itemBuilder: (_, i) =>
                                        _buildPqrsCard(_pqrs[i]),
                                  ),
                          ),
                        ],
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
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'PQRS',
              style: GoogleFonts.publicSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: AppColors.textDark,
              ),
            ),
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
            onPressed: _loadAll,
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child:
                const Text('Reintentar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTabs() {
    return Container(
      color: AppColors.cardBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _tabChip('Todas', null),
            ..._statuses.map((s) => _tabChip(
                  s['name']?.toString() ?? '',
                  s['id'] as int,
                )),
          ],
        ),
      ),
    );
  }

  Widget _tabChip(String label, int? statusId) {
    final isActive = _statusFilter == statusId;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => _onStatusChanged(statusId),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: GoogleFonts.publicSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountBadge() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '${_pqrs.length} resultado${_pqrs.length == 1 ? '' : 's'}',
          style: GoogleFonts.publicSans(
              fontSize: 12, color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildPqrsCard(Map<String, dynamic> pqr) {
    final subject = pqr['subject'] ?? '';
    final description = pqr['description'] ?? '';
    final typeName = pqr['pqr_type_name'] ?? '';
    final statusName = pqr['pqr_status_name'] ?? '';
    final priorityName = (pqr['priority_name'] ?? '').toString().toLowerCase();
    final reporterName = pqr['reporter_name'] ?? '';
    final createdAt = pqr['created_at'] != null
        ? DateTime.tryParse(pqr['created_at'])
        : null;

    return GestureDetector(
      onTap: () => _showDetail(pqr),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 2,
                offset: Offset(0, 1)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: type badge + priority + status
            Row(
              children: [
                _typeBadge(typeName),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: _priorityColor(priorityName),
                    shape: BoxShape.circle,
                  ),
                ),
                _statusBadge(statusName),
              ],
            ),
            const SizedBox(height: 10),
            Text(subject, style: AppTextStyles.semiBold14),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(description,
                  style: GoogleFonts.publicSans(
                      fontSize: 12, color: const Color(0xFF475569)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                if (reporterName.isNotEmpty)
                  Text(reporterName,
                      style: GoogleFonts.publicSans(
                          fontSize: 11, color: AppColors.textSecondary)),
                if (reporterName.isNotEmpty && createdAt != null)
                  Text(' · ',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                if (createdAt != null)
                  Text(
                      '${createdAt.day}/${createdAt.month}/${createdAt.year}',
                      style: GoogleFonts.publicSans(
                          fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeBadge(String type) {
    final color = _typeColor(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(type,
          style: GoogleFonts.publicSans(
              fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }

  Widget _statusBadge(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(status,
          style: GoogleFonts.publicSans(
              fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }

  void _showDetail(Map<String, dynamic> pqr) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _PqrDetailPage(
          pqr: pqr,
          service: _service,
          statuses: _statuses,
          onUpdated: _reload,
        ),
      ),
    );
  }

  Color _typeColor(String type) {
    final t = type.toLowerCase();
    if (t.contains('petici')) return AppColors.info;
    if (t.contains('queja')) return AppColors.error;
    if (t.contains('reclamo')) return AppColors.warning;
    if (t.contains('sugerencia')) return AppColors.success;
    return AppColors.textSecondary;
  }

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('abierto')) return AppColors.error;
    if (s.contains('proceso')) return AppColors.warning;
    if (s.contains('resuelto')) return AppColors.success;
    if (s.contains('cerrado')) return AppColors.textSecondary;
    return AppColors.textSecondary;
  }

  Color _priorityColor(String priority) {
    if (priority.contains('alt')) return AppColors.error;
    if (priority.contains('medi')) return AppColors.warning;
    if (priority.contains('baj')) return AppColors.success;
    return AppColors.textSecondary;
  }
}

// ─── Admin PQR Detail Page ─────────────────────────────────────────────

class _PqrDetailPage extends StatefulWidget {
  final Map<String, dynamic> pqr;
  final PqrsService service;
  final List<Map<String, dynamic>> statuses;
  final VoidCallback onUpdated;

  const _PqrDetailPage({
    required this.pqr,
    required this.service,
    required this.statuses,
    required this.onUpdated,
  });

  @override
  State<_PqrDetailPage> createState() => _PqrDetailPageState();
}

class _PqrDetailPageState extends State<_PqrDetailPage> {
  late Map<String, dynamic> _pqr;
  List<Map<String, dynamic>> _comments = [];
  List<Map<String, dynamic>> _priorities = [];
  bool _loadingComments = true;
  bool _submitting = false;
  final _commentCtrl = TextEditingController();
  final _resolutionCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pqr = Map.from(widget.pqr);
    _resolutionCtrl.text = _pqr['resolution']?.toString() ?? '';
    _loadExtras();
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    _resolutionCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadExtras() async {
    final pqrId = _pqr['id'].toString();
    try {
      final results = await Future.wait([
        widget.service.getComments(pqrId),
        widget.service.getPriorities(),
      ]);
      if (!mounted) return;
      setState(() {
        _comments = results[0];
        _priorities = results[1];
        _loadingComments = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingComments = false);
    }
  }

  Future<void> _updateStatus(int statusId) async {
    setState(() => _submitting = true);
    try {
      final updated = await widget.service.updatePqr(
        _pqr['id'].toString(),
        pqrStatusId: statusId,
      );
      if (!mounted) return;
      setState(() {
        _pqr = updated;
        _submitting = false;
      });
      widget.onUpdated();
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar estado: $e')),
      );
    }
  }

  Future<void> _updatePriority(int priorityId) async {
    setState(() => _submitting = true);
    try {
      final updated = await widget.service.updatePqr(
        _pqr['id'].toString(),
        priorityId: priorityId,
      );
      if (!mounted) return;
      setState(() {
        _pqr = updated;
        _submitting = false;
      });
      widget.onUpdated();
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar prioridad: $e')),
      );
    }
  }

  Future<void> _saveResolution() async {
    final text = _resolutionCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _submitting = true);
    try {
      final updated = await widget.service.updatePqr(
        _pqr['id'].toString(),
        resolution: text,
      );
      if (!mounted) return;
      setState(() {
        _pqr = updated;
        _submitting = false;
      });
      widget.onUpdated();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resolución guardada')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _addComment() async {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _submitting = true);
    try {
      await widget.service.addComment(_pqr['id'].toString(), text);
      _commentCtrl.clear();
      final comments =
          await widget.service.getComments(_pqr['id'].toString());
      if (!mounted) return;
      setState(() {
        _comments = comments;
        _submitting = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar comentario: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusName = _pqr['pqr_status_name']?.toString() ?? '';
    final typeName = _pqr['pqr_type_name']?.toString() ?? '';
    final priorityName =
        (_pqr['priority_name'] ?? '').toString().toLowerCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _submitting
                ? const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primary))
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    children: [
                      // Status & type badges
                      Row(
                        children: [
                          _badge(typeName, _typeColor(typeName)),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _priorityColor(priorityName),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _pqr['priority_name']?.toString() ?? '',
                            style: GoogleFonts.publicSans(
                                fontSize: 12,
                                color: AppColors.textSecondary),
                          ),
                          const Spacer(),
                          _badge(statusName, _statusColor(statusName)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Subject & description
                      Text(
                        _pqr['subject']?.toString() ?? '',
                        style: GoogleFonts.publicSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _pqr['description']?.toString() ?? '',
                        style: GoogleFonts.publicSans(
                          fontSize: 14,
                          height: 1.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Meta
                      _metaRow('Reportado por',
                          _pqr['reporter_name']?.toString() ?? ''),
                      _metaRow(
                          'Fecha', _formatDate(_pqr['created_at']?.toString())),
                      if ((_pqr['assignee_name'] ?? '').toString().isNotEmpty)
                        _metaRow('Asignado a',
                            _pqr['assignee_name'].toString()),

                      const SizedBox(height: 20),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 12),

                      // ─── Admin actions ───
                      Text('Gestionar',
                          style: GoogleFonts.publicSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                      const SizedBox(height: 14),

                      // Change status
                      _actionLabel('Cambiar estado'),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.statuses.map((s) {
                          final sid = s['id'] as int;
                          final sname = s['name']?.toString() ?? '';
                          final isActive =
                              sid == _pqr['pqr_status_id'];
                          final color = _statusColor(sname);
                          return GestureDetector(
                            onTap:
                                isActive ? null : () => _updateStatus(sid),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? color.withValues(alpha: 0.15)
                                    : AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: isActive
                                        ? color
                                        : AppColors.borderLight),
                              ),
                              child: Text(
                                sname,
                                style: GoogleFonts.publicSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isActive
                                      ? color
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Change priority
                      if (_priorities.isNotEmpty) ...[
                        _actionLabel('Cambiar prioridad'),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _priorities.map((p) {
                            final pid = p['id'] as int;
                            final pname = p['name']?.toString() ?? '';
                            final isActive =
                                pid == _pqr['priority_id'];
                            final color =
                                _priorityColor(pname.toLowerCase());
                            return GestureDetector(
                              onTap: isActive
                                  ? null
                                  : () => _updatePriority(pid),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? color.withValues(alpha: 0.15)
                                      : AppColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: isActive
                                          ? color
                                          : AppColors.borderLight),
                                ),
                                child: Text(
                                  pname,
                                  style: GoogleFonts.publicSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isActive
                                        ? color
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Resolution
                      _actionLabel('Resolución'),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: TextField(
                          controller: _resolutionCtrl,
                          maxLines: 3,
                          style: GoogleFonts.publicSans(
                              fontSize: 14, color: AppColors.textDark),
                          decoration: InputDecoration(
                            hintText: 'Escribir resolución...',
                            hintStyle: GoogleFonts.publicSans(
                                fontSize: 14,
                                color: AppColors.textSecondary),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: _saveResolution,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Guardar resolución',
                                style: GoogleFonts.publicSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 12),

                      // ─── Comments ───
                      Text('Comentarios',
                          style: GoogleFonts.publicSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                      const SizedBox(height: 12),

                      if (_loadingComments)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primary),
                          ),
                        )
                      else ...[
                        if (_comments.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text('Sin comentarios',
                                style: GoogleFonts.publicSans(
                                    fontSize: 13,
                                    color: AppColors.textSecondary)),
                          ),
                        ..._comments.map(_buildCommentCard),
                      ],

                      const SizedBox(height: 12),
                      // Add comment
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: AppColors.borderLight),
                              ),
                              child: TextField(
                                controller: _commentCtrl,
                                style: GoogleFonts.publicSans(
                                    fontSize: 14,
                                    color: AppColors.textDark),
                                decoration: InputDecoration(
                                  hintText: 'Agregar comentario...',
                                  hintStyle: GoogleFonts.publicSans(
                                      fontSize: 14,
                                      color: AppColors.textSecondary),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _addComment,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.send_rounded,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                behavior: HitTestBehavior.opaque,
                child: const Icon(Icons.arrow_back_rounded,
                    size: 24, color: AppColors.textDark),
              ),
              const SizedBox(width: 12),
              Text(
                'Detalle PQRS',
                style: GoogleFonts.publicSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentCard(Map<String, dynamic> comment) {
    final userName = comment['user_name']?.toString() ?? 'Usuario';
    final text = comment['comment']?.toString() ?? '';
    final date = _formatDate(comment['created_at']?.toString());

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                    style: GoogleFonts.publicSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(userName,
                    style: GoogleFonts.publicSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
              ),
              Text(date,
                  style: GoogleFonts.publicSans(
                      fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 8),
          Text(text,
              style: GoogleFonts.publicSans(
                  fontSize: 13, height: 1.4, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label,
          style: GoogleFonts.publicSans(
              fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }

  Widget _metaRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text('$label: ',
              style: GoogleFonts.publicSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          Expanded(
            child: Text(value,
                style: GoogleFonts.publicSans(
                    fontSize: 12, color: AppColors.textDark)),
          ),
        ],
      ),
    );
  }

  Widget _actionLabel(String text) {
    return Text(text,
        style: GoogleFonts.publicSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary));
  }

  String _formatDate(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  Color _typeColor(String type) {
    final t = type.toLowerCase();
    if (t.contains('petici')) return AppColors.info;
    if (t.contains('queja')) return AppColors.error;
    if (t.contains('reclamo')) return AppColors.warning;
    if (t.contains('sugerencia')) return AppColors.success;
    return AppColors.textSecondary;
  }

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('abierto')) return AppColors.error;
    if (s.contains('proceso')) return AppColors.warning;
    if (s.contains('resuelto')) return AppColors.success;
    if (s.contains('cerrado')) return AppColors.textSecondary;
    return AppColors.textSecondary;
  }

  Color _priorityColor(String priority) {
    if (priority.contains('alt')) return AppColors.error;
    if (priority.contains('medi')) return AppColors.warning;
    if (priority.contains('baj')) return AppColors.success;
    return AppColors.textSecondary;
  }
}
