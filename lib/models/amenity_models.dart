class Amenity {
  final int id;
  final String name;
  final String? description;
  final int? capacity;
  final double hourlyCost;
  final bool requiresApproval;
  final int minHours;
  final int maxHours;
  final String? availableFrom;
  final String? availableUntil;
  final bool isActive;

  Amenity({
    required this.id,
    required this.name,
    this.description,
    this.capacity,
    this.hourlyCost = 0,
    this.requiresApproval = false,
    this.minHours = 1,
    this.maxHours = 8,
    this.availableFrom,
    this.availableUntil,
    this.isActive = true,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      capacity: json['capacity'],
      hourlyCost: (json['hourly_cost'] ?? 0).toDouble(),
      requiresApproval: json['requires_approval'] ?? false,
      minHours: json['min_hours'] ?? 1,
      maxHours: json['max_hours'] ?? 8,
      availableFrom: json['available_from'],
      availableUntil: json['available_until'],
      isActive: json['is_active'] ?? true,
    );
  }
}

class Booking {
  final String id;
  final int amenityId;
  final String? amenityName;
  final String propertyId;
  final String bookedBy;
  final String? bookedByName;
  final int bookingStatusId;
  final String? bookingStatusName;
  final DateTime startTime;
  final DateTime endTime;
  final double totalCost;
  final String? notes;
  final DateTime? createdAt;

  Booking({
    required this.id,
    required this.amenityId,
    this.amenityName,
    required this.propertyId,
    required this.bookedBy,
    this.bookedByName,
    required this.bookingStatusId,
    this.bookingStatusName,
    required this.startTime,
    required this.endTime,
    this.totalCost = 0,
    this.notes,
    this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      amenityId: json['amenity_id'],
      amenityName: json['amenity_name'],
      propertyId: json['property_id'],
      bookedBy: json['booked_by'],
      bookedByName: json['booked_by_name'],
      bookingStatusId: json['booking_status_id'],
      bookingStatusName: json['booking_status_name'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      totalCost: (json['total_cost'] ?? 0).toDouble(),
      notes: json['notes'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  bool get isPendiente => bookingStatusId == 1;
  bool get isAprobada => bookingStatusId == 2;
  bool get isRechazada => bookingStatusId == 3;
  bool get isCancelada => bookingStatusId == 4;
  bool get isFinalizada => bookingStatusId == 5;

  bool get isUpcoming =>
      (isPendiente || isAprobada) && endTime.isAfter(DateTime.now());
}
