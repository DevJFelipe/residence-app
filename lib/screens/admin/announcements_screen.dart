import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/services/announcements_service.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  static const Color _bg = Color(0xFFF7F4EF);
  static const Color _dark = Color(0xFF0F1B2D);
  static const Color _accent = Color(0xFFEC5B13);

  final _service = AnnouncementsService();
  List<Map<String, dynamic>> _news = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final data = await _service.getAnnouncements();
      if (!mounted) return;
      setState(() {
        _news = data;
        _isLoading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AnnouncementsService.parseError(e);
        _isLoading = false;
      });
    }
  }

  Future<void> _showFormSheet({Map<String, dynamic>? announcement}) async {
    final titleCtrl = TextEditingController(text: announcement?['title'] ?? '');
    final contentCtrl = TextEditingController(text: announcement?['body'] ?? announcement?['content'] ?? '');
    bool isPinned = announcement?['is_pinned'] == true;
    bool submitting = false;
    final isEdit = announcement != null;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isEdit ? 'Editar anuncio' : 'Nuevo anuncio',
                style: GoogleFonts.publicSans(fontSize: 18, fontWeight: FontWeight.w700, color: _dark),
              ),
              const SizedBox(height: 16),
              _sheetField(titleCtrl, 'Título'),
              const SizedBox(height: 12),
              _sheetField(contentCtrl, 'Contenido', maxLines: 4),
              const SizedBox(height: 12),
              Row(
                children: [
                  Switch(
                    value: isPinned,
                    activeTrackColor: _accent.withValues(alpha: 0.4),
                    activeThumbColor: _accent,
                    onChanged: (v) => setSheetState(() => isPinned = v),
                  ),
                  const SizedBox(width: 8),
                  Text('Fijar anuncio', style: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w500, color: _dark)),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: submitting ? null : () async {
                    if (titleCtrl.text.trim().isEmpty || contentCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(content: Text('Completa título y contenido')),
                      );
                      return;
                    }
                    setSheetState(() => submitting = true);
                    try {
                      if (isEdit) {
                        await _service.updateAnnouncement(
                          announcement['id'].toString(),
                          title: titleCtrl.text.trim(),
                          content: contentCtrl.text.trim(),
                          isPinned: isPinned,
                        );
                      } else {
                        await _service.createAnnouncement(
                          title: titleCtrl.text.trim(),
                          content: contentCtrl.text.trim(),
                          isPinned: isPinned,
                        );
                      }
                      if (ctx.mounted) Navigator.pop(ctx);
                      _load();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(isEdit ? 'Anuncio actualizado' : 'Anuncio publicado')),
                        );
                      }
                    } on DioException catch (e) {
                      if (ctx.mounted) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          SnackBar(content: Text(AnnouncementsService.parseError(e))),
                        );
                      }
                    } finally {
                      if (ctx.mounted) setSheetState(() => submitting = false);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: submitting ? _accent.withValues(alpha: 0.5) : _accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: submitting
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(
                              isEdit ? 'Guardar cambios' : 'Publicar',
                              style: GoogleFonts.publicSans(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
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

  Future<void> _confirmDelete(Map<String, dynamic> item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar anuncio'),
        content: Text('¿Eliminar "${item['title']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await _service.deleteAnnouncement(item['id'].toString());
      _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anuncio eliminado')),
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AnnouncementsService.parseError(e))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Anuncios',
            style: GoogleFonts.publicSans(fontSize: 18, fontWeight: FontWeight.w700, color: _dark)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormSheet(),
        backgroundColor: _accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        color: _accent,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!, style: GoogleFonts.publicSans(color: Colors.grey)))
                : _news.isEmpty
                    ? ListView(children: [
                        const SizedBox(height: 120),
                        Center(child: Text('No hay anuncios', style: GoogleFonts.publicSans(color: Colors.grey))),
                        const SizedBox(height: 8),
                        Center(child: Text('Toca + para crear uno', style: GoogleFonts.publicSans(fontSize: 13, color: Colors.grey))),
                      ])
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _news.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => _buildCard(_news[i]),
                      ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item) {
    final title = item['title'] ?? '';
    final body = item['body'] ?? item['content'] ?? '';
    final isPinned = item['is_pinned'] == true;
    final date = item['created_at'] != null ? DateTime.tryParse(item['created_at']) : null;

    return GestureDetector(
      onTap: () => _showFormSheet(announcement: item),
      onLongPress: () => _confirmDelete(item),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _dark.withValues(alpha: 0.06)),
          boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isPinned) ...[
                  Icon(Icons.push_pin, size: 14, color: _accent),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(title, style: GoogleFonts.publicSans(fontSize: 16, fontWeight: FontWeight.w700, color: _dark)),
                ),
                const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF94A3B8)),
              ],
            ),
            if (date != null) ...[
              const SizedBox(height: 4),
              Text('${date.day}/${date.month}/${date.year}',
                  style: GoogleFonts.publicSans(fontSize: 12, color: Colors.grey)),
            ],
            if (body.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(body,
                  style: GoogleFonts.publicSans(fontSize: 14, color: const Color(0xFF475569)),
                  maxLines: 4, overflow: TextOverflow.ellipsis),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sheetField(TextEditingController ctrl, String hint, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        style: GoogleFonts.publicSans(fontSize: 14, color: _dark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.publicSans(fontSize: 14, color: const Color(0xFF94A3B8)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }
}
