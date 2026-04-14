import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/api_client.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  static const Color _bg = Color(0xFFF7F4EF);
  static const Color _dark = Color(0xFF0F1B2D);
  static const Color _accent = Color(0xFFEC5B13);

  final _dio = ApiClient().dio;
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
      final resp = await _dio.get('/api/v1/news/');
      if (!mounted) return;
      setState(() {
        _news = List<Map<String, dynamic>>.from(resp.data['data']);
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
            style: GoogleFonts.publicSans(
                fontSize: 18, fontWeight: FontWeight.w700, color: _dark)),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        color: _accent,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!, style: GoogleFonts.publicSans(color: Colors.grey)))
                : _news.isEmpty
                    ? Center(child: Text('No hay anuncios', style: GoogleFonts.publicSans(color: Colors.grey)))
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _news.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => _buildCard(_news[i]),
                      ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item) {
    final title = item['title'] ?? '';
    final body = item['body'] ?? item['content'] ?? '';
    final date = item['created_at'] != null
        ? DateTime.tryParse(item['created_at'])
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _dark.withValues(alpha: 0.06)),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.publicSans(
                  fontSize: 16, fontWeight: FontWeight.w700, color: _dark)),
          if (date != null) ...[
            const SizedBox(height: 4),
            Text('${date.day}/${date.month}/${date.year}',
                style: GoogleFonts.publicSans(fontSize: 12, color: Colors.grey)),
          ],
          if (body.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(body,
                style: GoogleFonts.publicSans(fontSize: 14, color: const Color(0xFF475569)),
                maxLines: 4,
                overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    );
  }
}
