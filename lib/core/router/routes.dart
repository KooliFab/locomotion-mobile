class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String explore = '/explore';
  static const String loans = '/loans';
  static const String communities = '/communities';
  static const String profile = '/profile';
  static const String borrower = '/profile/borrower';
  static const String borrowerForm = '/profile/borrower/form';
  static const String paymentMethods = '/profile/payment-methods';
  static const String loanableDetail = '/loanables/:id';
  static const String loanReservation = '/loanables/:id/reserve';
  static const String loanSuccess = '/loans/:id/success';
  static const String loanDetail = '/loans/:id';
  static const String loanDeparture = '/loans/:id/departure';
  static const String loanReturn = '/loans/:id/return';
  static const String loansList = '/loans/all';
  static const String fleet = '/fleet';
  static const String fleetCreate = '/fleet/new';
  static const String fleetDetail = '/fleet/:id';
  static const String fleetEdit = '/fleet/:id/edit';
  static const String fleetPreview = '/fleet/:id/preview';
  static const String fleetAvailability = '/fleet/:id/availability';

  static String loanableDetailPath(int id) => '/loanables/$id';
  static String loanReservationPath(int id) => '/loanables/$id/reserve';
  static String loanSuccessPath(int id) => '/loans/$id/success';
  static String loanDetailPath(int id) => '/loans/$id';
  static String loanDeparturePath(int id) => '/loans/$id/departure';
  static String loanReturnPath(int id) => '/loans/$id/return';
  static String loansListPath({String? status}) =>
      status != null ? '/loans/all?status=$status' : '/loans/all';
  static String fleetDetailPath(int id) => '/fleet/$id';
  static String fleetEditPath(int id) => '/fleet/$id/edit';
  static String fleetPreviewPath(int id) => '/fleet/$id/preview';
  static String fleetAvailabilityPath(int id) => '/fleet/$id/availability';
}
