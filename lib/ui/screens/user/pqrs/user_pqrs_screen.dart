import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_text_styles.dart';
import 'package:residence_app/services/pqrs_service.dart';

class UserPqrsScreen extends StatefulWidget {
  const UserPqrsScreen({super.key});

  @override
  State<UserPqrsScreen> createState() => _UserPqrsScreenState();
}

class _UserPqrsScreenState extends State<UserPqrsScreen> {
  final _service = PqrsService();
  List<Map<String, dynamic>> _pqrs = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _service.getPqrs(limit: 50);
      if (!mounted) return;
      setState(() {
        _pqrs = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error al cargar PQRS';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
                          child: _pqrs.isEmpty
                              ? ListView(
                                  children: [
                                    const SizedBox(height: 80),
                                    Center(
                                      child: Column(
                                        children: [
                                          Icon(Icons.inbox_rounded,
                                              size: 48,
                                              color: AppColors.textSecondary
                                                  .withValues(alpha: 0.4)),
                                          const SizedBox(height: 12),
                                          Text(
                                            'No tienes PQRS',
                                            style: GoogleFonts.publicSans(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Crea una petición, queja o sugerencia',
                                            style: GoogleFonts.publicSans(
                                              fontSize: 13,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 16, 16, 32),
                                  itemCount: _pqrs.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 10),
                                  itemBuilder: (_, i) =>
                                      _buildPqrCard(_pqrs[i]),
                                ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateSheet(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.opaque,
            child: const Icon(Icons.arrow_back_rounded,
                size: 24, color: AppColors.textDark),
          ),
          const SizedBox(width: 12),
          Text(
            'Mis PQRS',
            style: GoogleFonts.publicSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPqrCard(Map<String, dynamic> pqr) {
    final statusName = pqr['pqr_status_name'] ?? '';
    final typeName = pqr['pqr_type_name'] ?? '';
    final statusColor = _statusColor(statusName);

    return GestureDetector(
      onTap: () => _showDetail(pqr),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusName,
                    style: GoogleFonts.publicSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: statusColor),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    typeName,
                    style: GoogleFonts.publicSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(pqr['created_at']?.toString()),
                  style: GoogleFonts.publicSans(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              pqr['subject'] ?? '',
              style: GoogleFonts.publicSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              pqr['description'] ?? '',
              style: GoogleFonts.publicSans(
                  fontSize: 12, color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(Map<String, dynamic> pqr) {
    final statusName = pqr['pqr_status_name'] ?? '';
    final statusColor = _statusColor(statusName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (ctx, scroll) => ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(statusName,
                      style: GoogleFonts.publicSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: statusColor)),
                ),
                const SizedBox(width: 8),
                Text(pqr['pqr_type_name'] ?? '',
                    style: GoogleFonts.publicSans(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 16),
            Text(pqr['subject'] ?? '',
                style: GoogleFonts.publicSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            const SizedBox(height: 12),
            Text(pqr['description'] ?? '',
                style: GoogleFonts.publicSans(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondary)),
            if ((pqr['resolution'] ?? '').isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color:
                          const Color(0xFF22C55E).withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Resolución',
                        style: GoogleFonts.publicSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF22C55E))),
                    const SizedBox(height: 6),
                    Text(pqr['resolution'],
                        style: GoogleFonts.publicSans(
                            fontSize: 13, color: AppColors.textDark)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'Creada: ${_formatDate(pqr['created_at']?.toString())}',
              style: GoogleFonts.publicSans(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateSheet() async {
    // Show loading while fetching types
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    List<Map<String, dynamic>> types = [];
    try {
      types = await _service.getPqrTypes();
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // dismiss loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar tipos: $e')),
      );
      return;
    }

    if (!mounted) return;
    Navigator.pop(context); // dismiss loading

    if (types.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontraron tipos de PQRS')),
      );
      return;
    }

    final subjectCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    int? selectedTypeId = types.first['id'];
    bool submitting = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Nueva PQRS',
                  style: GoogleFonts.publicSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              const SizedBox(height: 16),
              Text('Tipo',
                  style: GoogleFonts.publicSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: types.map((t) {
                  final isSelected = t['id'] == selectedTypeId;
                  return GestureDetector(
                    onTap: () =>
                        setSheetState(() => selectedTypeId = t['id']),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.borderLight),
                      ),
                      child: Text(
                        t['name'] ?? '',
                        style: GoogleFonts.publicSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textDark,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              _sheetField(subjectCtrl, 'Asunto'),
              const SizedBox(height: 10),
              _sheetField(descCtrl, 'Descripción', maxLines: 4),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: submitting
                      ? null
                      : () async {
                          if (subjectCtrl.text.trim().isEmpty ||
                              descCtrl.text.trim().isEmpty) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Completa asunto y descripción')),
                            );
                            return;
                          }
                          setSheetState(() => submitting = true);
                          try {
                            await _service.createPqr(
                              pqrTypeId: selectedTypeId!,
                              priorityId: 2, // medium default
                              subject: subjectCtrl.text.trim(),
                              description: descCtrl.text.trim(),
                            );
                            if (ctx.mounted) Navigator.pop(ctx);
                            _load();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('PQRS creada exitosamente')),
                              );
                            }
                          } catch (e) {
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          } finally {
                            if (ctx.mounted) {
                              setSheetState(() => submitting = false);
                            }
                          }
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: submitting
                          ? AppColors.primary.withValues(alpha: 0.5)
                          : AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : Text('Enviar PQRS',
                              style: GoogleFonts.publicSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetField(TextEditingController ctrl, String hint,
      {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        style: GoogleFonts.publicSans(fontSize: 14, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.publicSans(
              fontSize: 14, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'abierto':
        return const Color(0xFFF59E0B);
      case 'en proceso':
        return const Color(0xFF3B82F6);
      case 'resuelto':
        return const Color(0xFF22C55E);
      case 'cerrado':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }
}
