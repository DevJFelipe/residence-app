class DashboardStats {
  final int totalUnits;
  final int activeResidents;
  final double pendingPayments;
  final int openPqrs;

  DashboardStats({
    required this.totalUnits,
    required this.activeResidents,
    required this.pendingPayments,
    required this.openPqrs,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalUnits: json['total_units'] ?? 0,
      activeResidents: json['active_residents'] ?? 0,
      pendingPayments: (json['pending_payments'] ?? 0).toDouble(),
      openPqrs: json['open_pqrs'] ?? 0,
    );
  }
}

class ActiveVisitor {
  final String id;
  final String visitorName;
  final String? propertyNumber;
  final DateTime? entryTime;
  final bool isGuest;
  final String? vehiclePlate;
  final String? notes;

  ActiveVisitor({
    required this.id,
    required this.visitorName,
    this.propertyNumber,
    this.entryTime,
    this.isGuest = false,
    this.vehiclePlate,
    this.notes,
  });

  factory ActiveVisitor.fromJson(Map<String, dynamic> json) {
    return ActiveVisitor(
      id: json['id'],
      visitorName: json['visitor_name'],
      propertyNumber: json['property_number'],
      entryTime: json['entry_time'] != null
          ? DateTime.parse(json['entry_time'])
          : null,
      isGuest: json['is_guest'] ?? false,
      vehiclePlate: json['vehicle_plate'],
      notes: json['notes'],
    );
  }

  String get typeLabel => notes ?? (isGuest ? 'VISITANTE' : 'DOMICILIO');
}

class MonthlyCollection {
  final int year;
  final int month;
  final double total;

  MonthlyCollection({
    required this.year,
    required this.month,
    required this.total,
  });

  factory MonthlyCollection.fromJson(Map<String, dynamic> json) {
    return MonthlyCollection(
      year: json['year'],
      month: json['month'],
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}

class DashboardSummary {
  final DashboardStats stats;
  final List<ActiveVisitor> activeVisitors;
  final List<MonthlyCollection> monthlyCollections;

  DashboardSummary({
    required this.stats,
    required this.activeVisitors,
    required this.monthlyCollections,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      stats: DashboardStats.fromJson(json['stats']),
      activeVisitors: (json['active_visitors'] as List)
          .map((v) => ActiveVisitor.fromJson(v))
          .toList(),
      monthlyCollections: (json['monthly_collections'] as List)
          .map((m) => MonthlyCollection.fromJson(m))
          .toList(),
    );
  }
}
