import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/api_client.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const Color _bg = Color(0xFFF7F4EF);
  static const Color _dark = Color(0xFF0F1B2D);
  static const Color _accent = Color(0xFFEC5B13);

  final _dio = ApiClient().dio;
  List<Map<String, dynamic>> _items = [];
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
      final resp = await _dio.get('/api/v1/notifications/me');
      if (!mounted) return;
      setState(() {
        _items = List<Map<String, dynamic>>.from(resp.data['data']);
        _isLoading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.response?.data is Map
            ? (e.response!.data['detail'] ?? 'Error al cargar')
            : 'No se pudo conectar al servidor';
        _isLoading = false;
      });
    }
  }

  Future<void> _markAllRead() async {
    try {
      await _dio.post('/api/v1/notifications/me/mark-all-read');
      _load();
    } catch (_) {}
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
        title: Text('Notificaciones',
            style: GoogleFonts.publicSans(
                fontSize: 18, fontWeight: FontWeight.w700, color: _dark)),
        centerTitle: true,
        actions: [
          if (_items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.done_all_rounded, color: _accent),
              onPressed: _markAllRead,
              tooltip: 'Marcar todas como leídas',
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        color: _accent,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!, style: GoogleFonts.publicSans(color: Colors.grey)))
                : _items.isEmpty
                    ? Center(child: Text('No hay notificaciones', style: GoogleFonts.publicSans(color: Colors.grey)))
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) => _buildCard(_items[i]),
                      ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item) {
    final title = item['title'] ?? '';
    final body = item['body'] ?? item['message'] ?? '';
    final isRead = item['is_read'] == true || item['read_at'] != null;
    final date = item['created_at'] != null
        ? DateTime.tryParse(item['created_at'])
        : null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : _accent.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRead ? _dark.withValues(alpha: 0.06) : _accent.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isRead ? Colors.transparent : _accent,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.publicSans(
                        fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
                if (body.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(body,
                      style: GoogleFonts.publicSans(fontSize: 13, color: const Color(0xFF475569)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
                if (date != null) ...[
                  const SizedBox(height: 4),
                  Text('${date.day}/${date.month}/${date.year}',
                      style: GoogleFonts.publicSans(fontSize: 11, color: Colors.grey)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
