import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

enum InvoiceStatus { paid, pending, overdue }

@freezed
class Invoice with _$Invoice {
  const factory Invoice({
    required String id,
    required String unitNumber,
    required String residentName,
    required String residentInitials,
    required String concept,
    required double amount,
    required DateTime dueDate,
    required InvoiceStatus status,
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);
}

@freezed
class BillingSummary with _$BillingSummary {
  const factory BillingSummary({
    required double totalBilled,
    required double totalCollected,
    required double totalPending,
    required double collectionRate,
    required String period,
  }) = _BillingSummary;

  factory BillingSummary.fromJson(Map<String, dynamic> json) =>
      _$BillingSummaryFromJson(json);
}
