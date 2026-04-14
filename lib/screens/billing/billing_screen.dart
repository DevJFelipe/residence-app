import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../services/billing_service.dart';
import '../../services/residents_service.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final _service = BillingService();
  List<Map<String, dynamic>> _invoices = [];
  bool _loading = true;
  String? _error;

  // null = todos, else filter code
  String? _statusFilter;

  static const _tabs = [
    _Tab('Todos', null),
    _Tab('Pendiente', 'pendiente'),
    _Tab('Pagado', 'pagado'),
    _Tab('Vencido', 'vencido'),
  ];

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
      final invoices =
          await _service.getInvoices(paymentStatusCode: _statusFilter);
      if (!mounted) return;
      setState(() {
        _invoices = invoices;
        _loading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = BillingService.parseError(e);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Error al cargar facturas';
        _loading = false;
      });
    }
  }

  void _onTabChanged(String? statusCode) {
    setState(() => _statusFilter = statusCode);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary))
                  : _error != null
                      ? _buildError()
                      : RefreshIndicator(
                          onRefresh: _load,
                          color: AppColors.primary,
                          child: Column(
                            children: [
                              _buildTabs(),
                              _buildSummaryRow(),
                              Expanded(
                                child: _invoices.isEmpty
                                    ? Center(
                                        child: Text('No hay facturas',
                                            style: GoogleFonts.publicSans(
                                                color: Colors.grey)))
                                    : ListView.separated(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 8, 16, 80),
                                        itemCount: _invoices.length,
                                        separatorBuilder: (_, _) =>
                                            const SizedBox(height: 10),
                                        itemBuilder: (_, i) =>
                                            _buildInvoiceCard(_invoices[i]),
                                      ),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: () => _showCreateInvoiceSheet(),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: Colors.white),
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
              'Facturación',
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
            onPressed: _load,
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child:
                const Text('Reintentar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: AppColors.cardBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _tabs.map((tab) {
          final isActive = _statusFilter == tab.code;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _onTabChanged(tab.code),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tab.label,
                  style: GoogleFonts.publicSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryRow() {
    double totalAmount = 0;
    double totalBalance = 0;
    for (final inv in _invoices) {
      totalAmount += (inv['amount'] ?? 0).toDouble();
      totalBalance += (inv['balance'] ?? 0).toDouble();
    }
    final totalPaid = totalAmount - totalBalance;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          _summaryItem('Facturado', totalAmount, AppColors.textDark),
          _divider(),
          _summaryItem('Recaudado', totalPaid, AppColors.success),
          _divider(),
          _summaryItem('Pendiente', totalBalance, const Color(0xFFEF4444)),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, double value, Color valueColor) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: GoogleFonts.publicSans(
                  fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(
            _formatCurrency(value),
            style: GoogleFonts.publicSans(
                fontSize: 15, fontWeight: FontWeight.w700, color: valueColor),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 36, color: AppColors.borderLight);
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(0)}K';
    }
    return '\$${amount.toStringAsFixed(0)}';
  }

  Widget _buildInvoiceCard(Map<String, dynamic> inv) {
    final status = (inv['payment_status_name'] ?? inv['payment_status'] ?? '')
        .toString()
        .toLowerCase();
    final amount = (inv['amount'] ?? 0).toDouble();
    final balance = (inv['balance'] ?? 0).toDouble();
    final property =
        '${inv['property_block'] ?? ''} ${inv['property_number'] ?? ''}'.trim();
    final chargeType = inv['charge_type_name'] ?? '';
    final description = inv['description'] ?? '';
    final billingPeriod = inv['billing_period'] ?? '';
    final dueDate = inv['due_date'] != null
        ? DateTime.tryParse(inv['due_date'].toString())
        : null;

    Color statusColor;
    Color statusBg;
    String statusLabel;
    switch (status) {
      case 'pagado':
        statusColor = AppColors.success;
        statusBg = AppColors.successBackground;
        statusLabel = 'PAGADO';
        break;
      case 'vencido':
        statusColor = const Color(0xFFEF4444);
        statusBg = AppColors.errorBackground;
        statusLabel = 'VENCIDO';
        break;
      default:
        statusColor = const Color(0xFFD97706);
        statusBg = const Color(0xFFFEF3C7);
        statusLabel = 'PENDIENTE';
    }

    return GestureDetector(
      onTap: () => _showInvoiceDetail(inv),
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
            // Top row: property + status
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.receipt_long_rounded,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.isNotEmpty ? property : 'Sin unidad',
                        style: AppTextStyles.bold14
                            .copyWith(color: AppColors.textDark),
                      ),
                      if (chargeType.isNotEmpty)
                        Text(chargeType, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(statusLabel,
                      style: AppTextStyles.bold10.copyWith(color: statusColor)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Amount row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Monto',
                        style: GoogleFonts.publicSans(
                            fontSize: 11, color: AppColors.textSecondary)),
                    Text('\$${amount.toStringAsFixed(0)}',
                        style: GoogleFonts.publicSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                  ],
                ),
                if (balance > 0 && balance < amount)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Saldo',
                          style: GoogleFonts.publicSans(
                              fontSize: 11, color: AppColors.textSecondary)),
                      Text('\$${balance.toStringAsFixed(0)}',
                          style: GoogleFonts.publicSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFEF4444))),
                    ],
                  ),
              ],
            ),
            // Bottom info
            if (billingPeriod.isNotEmpty || dueDate != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  if (billingPeriod.isNotEmpty)
                    Text('Periodo: $billingPeriod',
                        style: GoogleFonts.publicSans(
                            fontSize: 11, color: Colors.grey)),
                  if (billingPeriod.isNotEmpty && dueDate != null)
                    const Text('  •  ',
                        style: TextStyle(fontSize: 11, color: Colors.grey)),
                  if (dueDate != null)
                    Text(
                        'Vence: ${dueDate.day}/${dueDate.month}/${dueDate.year}',
                        style: GoogleFonts.publicSans(
                            fontSize: 11, color: Colors.grey)),
                ],
              ),
            ],
            if (description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(description,
                  style: GoogleFonts.publicSans(
                      fontSize: 12, color: const Color(0xFF475569)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ],
        ),
      ),
    );
  }

  void _showInvoiceDetail(Map<String, dynamic> inv) {
    final amount = (inv['amount'] ?? 0).toDouble();
    final balance = (inv['balance'] ?? 0).toDouble();
    final paid = amount - balance;
    final property =
        '${inv['property_block'] ?? ''} ${inv['property_number'] ?? ''}'.trim();
    final status = (inv['payment_status_name'] ?? inv['payment_status'] ?? '')
        .toString().toLowerCase();
    final canPay = status == 'pendiente' || status == 'vencido';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Detalle de Factura',
                style: GoogleFonts.publicSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            const SizedBox(height: 16),
            _detailRow('Unidad', property),
            _detailRow('Tipo de cargo', inv['charge_type_name']?.toString() ?? ''),
            _detailRow('Descripción', inv['description']?.toString() ?? ''),
            _detailRow('Periodo', inv['billing_period']?.toString() ?? ''),
            _detailRow('Monto', '\$${amount.toStringAsFixed(0)}'),
            _detailRow('Pagado', '\$${paid.toStringAsFixed(0)}'),
            _detailRow('Saldo', '\$${balance.toStringAsFixed(0)}'),
            _detailRow('Estado',
                (inv['payment_status_name'] ?? inv['payment_status'] ?? '').toString()),
            if (inv['due_date'] != null)
              _detailRow('Fecha vencimiento', inv['due_date'].toString()),
            if (canPay && balance > 0) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    _showPaymentSheet(inv);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text('Registrar pago',
                          style: GoogleFonts.publicSans(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateInvoiceSheet() async {
    // Load required catalogs
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );

    List<Map<String, dynamic>> properties = [];
    List<Map<String, dynamic>> chargeTypes = [];
    try {
      final results = await Future.wait([
        ResidentsService().getProperties(),
        _service.getChargeTypes(),
      ]);
      properties = results[0];
      chargeTypes = results[1];
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando datos: $e')),
      );
      return;
    }

    if (!mounted) return;
    Navigator.pop(context);

    if (properties.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay propiedades disponibles')),
      );
      return;
    }

    final amountCtrl = TextEditingController();
    final periodCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String? selectedPropertyId = properties.first['id']?.toString();
    int? selectedChargeTypeId = chargeTypes.isNotEmpty ? chargeTypes.first['id'] : null;
    DateTime dueDate = DateTime.now().add(const Duration(days: 30));
    bool submitting = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                Text('Nueva factura', style: GoogleFonts.publicSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                const SizedBox(height: 16),
                // Property dropdown
                Text('Propiedad', style: GoogleFonts.publicSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                _sheetDropdown<String>(
                  value: selectedPropertyId,
                  items: properties.map((p) => DropdownMenuItem(
                    value: p['id']?.toString(),
                    child: Text('${p['block'] ?? ''} ${p['number'] ?? ''}'.trim()),
                  )).toList(),
                  onChanged: (v) => setSheetState(() => selectedPropertyId = v),
                ),
                const SizedBox(height: 12),
                // Charge type dropdown
                if (chargeTypes.isNotEmpty) ...[
                  Text('Tipo de cargo', style: GoogleFonts.publicSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  _sheetDropdown<int>(
                    value: selectedChargeTypeId,
                    items: chargeTypes.map((ct) => DropdownMenuItem(
                      value: ct['id'] as int,
                      child: Text(ct['name'] ?? ''),
                    )).toList(),
                    onChanged: (v) => setSheetState(() => selectedChargeTypeId = v),
                  ),
                  const SizedBox(height: 12),
                ],
                // Amount
                _sheetTextField(amountCtrl, 'Monto', keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                // Due date
                Text('Fecha de vencimiento', style: GoogleFonts.publicSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: dueDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (c, child) => Theme(data: Theme.of(c).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primary)), child: child!),
                    );
                    if (picked != null) setSheetState(() => dueDate = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Row(
                      children: [
                        Expanded(child: Text('${dueDate.day}/${dueDate.month}/${dueDate.year}', style: GoogleFonts.publicSans(fontSize: 14, color: AppColors.textDark))),
                        const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF94A3B8)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _sheetTextField(periodCtrl, 'Periodo (opcional)', hint: 'Ej: Abril 2026'),
                const SizedBox(height: 12),
                _sheetTextField(descCtrl, 'Descripción (opcional)', maxLines: 2),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: submitting ? null : () async {
                      final amount = double.tryParse(amountCtrl.text.trim());
                      if (amount == null || amount <= 0) {
                        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Ingresa un monto válido')));
                        return;
                      }
                      setSheetState(() => submitting = true);
                      try {
                        await _service.createInvoice(
                          propertyId: selectedPropertyId!,
                          chargeTypeId: selectedChargeTypeId ?? 1,
                          amount: amount,
                          dueDate: '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}',
                          billingPeriod: periodCtrl.text.trim().isEmpty ? null : periodCtrl.text.trim(),
                          description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                        );
                        if (ctx.mounted) Navigator.pop(ctx);
                        _load();
                        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Factura creada')));
                      } on DioException catch (e) {
                        if (ctx.mounted) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(BillingService.parseError(e))));
                      } finally {
                        if (ctx.mounted) setSheetState(() => submitting = false);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(color: submitting ? AppColors.primary.withValues(alpha: 0.5) : AppColors.primary, borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: submitting
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text('Crear factura', style: GoogleFonts.publicSans(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showPaymentSheet(Map<String, dynamic> inv) async {
    final balance = (inv['balance'] ?? 0).toDouble();
    final invoiceId = inv['id']?.toString() ?? '';

    // Load payment methods
    List<Map<String, dynamic>> methods = [];
    try {
      methods = await _service.getPaymentMethods();
    } catch (_) {
      // Fallback with a default
      methods = [{'id': 1, 'name': 'Transferencia'}];
    }

    if (!mounted) return;

    final amountCtrl = TextEditingController(text: balance.toStringAsFixed(0));
    final refCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    int selectedMethodId = methods.isNotEmpty ? methods.first['id'] as int : 1;
    bool submitting = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text('Registrar pago', style: GoogleFonts.publicSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              Text('Saldo pendiente: \$${balance.toStringAsFixed(0)}', style: GoogleFonts.publicSans(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              _sheetTextField(amountCtrl, 'Monto', keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              Text('Método de pago', style: GoogleFonts.publicSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              _sheetDropdown<int>(
                value: selectedMethodId,
                items: methods.map((m) => DropdownMenuItem(value: m['id'] as int, child: Text(m['name'] ?? ''))).toList(),
                onChanged: (v) { if (v != null) setSheetState(() => selectedMethodId = v); },
              ),
              const SizedBox(height: 12),
              _sheetTextField(refCtrl, 'Referencia (opcional)', hint: 'Ej: #12345'),
              const SizedBox(height: 12),
              _sheetTextField(notesCtrl, 'Notas (opcional)'),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: submitting ? null : () async {
                    final amount = double.tryParse(amountCtrl.text.trim());
                    if (amount == null || amount <= 0) {
                      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Ingresa un monto válido')));
                      return;
                    }
                    setSheetState(() => submitting = true);
                    try {
                      await _service.registerPayment(
                        invoiceId: invoiceId,
                        amountPaid: amount,
                        paymentMethodId: selectedMethodId,
                        reference: refCtrl.text.trim().isEmpty ? null : refCtrl.text.trim(),
                        notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
                      );
                      if (ctx.mounted) Navigator.pop(ctx);
                      _load();
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pago registrado')));
                    } on DioException catch (e) {
                      if (ctx.mounted) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(BillingService.parseError(e))));
                    } finally {
                      if (ctx.mounted) setSheetState(() => submitting = false);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(color: submitting ? AppColors.primary.withValues(alpha: 0.5) : AppColors.primary, borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: submitting
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('Confirmar pago', style: GoogleFonts.publicSans(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
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

  Widget _sheetTextField(TextEditingController ctrl, String label, {String? hint, int maxLines = 1, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.publicSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: TextField(
            controller: ctrl,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: GoogleFonts.publicSans(fontSize: 14, color: AppColors.textDark),
            decoration: InputDecoration(
              hintText: hint ?? label,
              hintStyle: GoogleFonts.publicSans(fontSize: 14, color: const Color(0xFF94A3B8)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sheetDropdown<T>({required T? value, required List<DropdownMenuItem<T>> items, required ValueChanged<T?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF94A3B8)),
          style: GoogleFonts.publicSans(fontSize: 14, color: AppColors.textDark),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style: GoogleFonts.publicSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey)),
          ),
          Expanded(
            child: Text(value,
                style: GoogleFonts.publicSans(
                    fontSize: 14, color: AppColors.textDark)),
          ),
        ],
      ),
    );
  }
}

class _Tab {
  final String label;
  final String? code;
  const _Tab(this.label, this.code);
}
