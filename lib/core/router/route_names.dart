class RouteNames {
  RouteNames._();

  // Public
  static const String welcome = '/';
  static const String login = '/login';
  static const String condoProfile = '/condo/:id';
  static const String visitorPreregister = '/preregister';

  // Admin
  static const String adminDashboard = '/admin/dashboard';
  static const String adminVisitors = '/admin/visitors';
  static const String adminBilling = '/admin/billing';
  static const String adminPqrs = '/admin/pqrs';
  static const String adminMore = '/admin/more';

  // User
  static const String userHome = '/user/home';
  static const String userAmenities = '/user/amenities';
  static const String userReservations = '/user/reservations';
  static const String userProfile = '/user/profile';
  static const String userReserve = '/user/amenities/:id/reserve';
  static const String userConfirmation = '/user/confirmation';
}
