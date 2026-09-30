class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String explore = '/explore';
  static const String loans = '/loans';
  static const String communities = '/communities';
  static const String profile = '/profile';
  static const String borrower = '/profile/borrower';
  static const String borrowerForm = '/profile/borrower/form';
  static const String loanableDetail = '/loanables/:id';
  static const String loanReservation = '/loanables/:id/reserve';
  static const String loanSuccess = '/loans/:id/success';
  static const String loanDetail = '/loans/:id';
  static const String loansList = '/loans/all';

  static String loanableDetailPath(int id) => '/loanables/$id';
  static String loanReservationPath(int id) => '/loanables/$id/reserve';
  static String loanSuccessPath(int id) => '/loans/$id/success';
  static String loanDetailPath(int id) => '/loans/$id';
  static String loansListPath({String? status}) =>
      status != null ? '/loans/all?status=$status' : '/loans/all';
}
