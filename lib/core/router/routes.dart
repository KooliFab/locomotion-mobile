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
  static const String loanFactors = '/loans/:id/factors';
  static const String loansList = '/loans/all';
  static const String fleet = '/fleet';
  static const String fleetCreate = '/fleet/new';
  static const String fleetDetail = '/fleet/:id';
  static const String fleetEdit = '/fleet/:id/edit';
  static const String fleetPreview = '/fleet/:id/preview';
  static const String fleetAvailability = '/fleet/:id/availability';
  static const String incidents = '/incidents';
  static const String incidentDetail = '/incidents/:id';
  static const String incidentReport = '/incidents/report';

  static String loanableDetailPath(int id) => '/loanables/$id';
  static String loanReservationPath(int id) => '/loanables/$id/reserve';
  static String loanSuccessPath(int id) => '/loans/$id/success';
  static String loanDetailPath(int id) => '/loans/$id';
  static String loanFactorsPath(int id) => '/loans/$id/factors';
  static String loansListPath({String? status}) =>
      status != null ? '/loans/all?status=$status' : '/loans/all';
  static String fleetDetailPath(int id) => '/fleet/$id';
  static String fleetEditPath(int id) => '/fleet/$id/edit';
  static String fleetPreviewPath(int id) => '/fleet/$id/preview';
  static String fleetAvailabilityPath(int id) => '/fleet/$id/availability';
  static String incidentDetailPath(int id) => '/incidents/$id';
  static String incidentReportPath({
    required int loanableId,
    String? vehicleName,
    int? loanId,
    String? ownerName,
    String? ownerPhone,
    String? ownerEmail,
  }) {
    final query = <String, String>{'loanable_id': loanableId.toString()};
    if (vehicleName != null) query['vehicle_name'] = vehicleName;
    if (loanId != null) query['loan_id'] = loanId.toString();
    if (ownerName != null) query['owner_name'] = ownerName;
    if (ownerPhone != null) query['owner_phone'] = ownerPhone;
    if (ownerEmail != null) query['owner_email'] = ownerEmail;
    return Uri(path: '/incidents/report', queryParameters: query).toString();
  }
}

class Routes {
  static const String incidents = AppRoutes.incidents;
  static const String incidentReport = AppRoutes.incidentReport;
  static String incidentDetail(int id) => AppRoutes.incidentDetailPath(id);
  static String incidentReportPath({
    required int loanableId,
    String? vehicleName,
    int? loanId,
    String? ownerName,
    String? ownerPhone,
    String? ownerEmail,
  }) => AppRoutes.incidentReportPath(
    loanableId: loanableId,
    vehicleName: vehicleName,
    loanId: loanId,
    ownerName: ownerName,
    ownerPhone: ownerPhone,
    ownerEmail: ownerEmail,
  );
}
