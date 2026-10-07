class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/token/refresh';
  static const String logout = '/logout';
  static const String currentUser = '/auth/user';
  static const String userBalance = '/auth/user/balance';

  // Loanables (vehicles, bikes, trailers)
  static const String loanables = '/loanables';
  static const String loanablesSearch = '/loanables/search';
  static const String loanablesListByType = '/loanables/listByType';
  static const String loanableTypes = '/loanableTypes';
  static const String loanablesAvailability = '/loanables/availability';
  static const String loanablesDashboard = '/loanables/dashboard';
  static String loanableAvailability(int id) => '/loanables/$id/availability';
  static String loanableDetail(int id) => '/loanables/$id';

  // Loans (reservations)
  static const String loans = '/loans';
  static const String loansDashboard = '/loans/dashboard';
  static String loanDetail(int id) => '/loans/$id';
  static String loanEstimate(int id) => '/loans/$id/estimate';
  static String loanFactors(int id) => '/loans/$id/factors';
  static String loanEarlyReturn(int id) => '/loans/$id/return';

  // Images
  static const String images = '/images';
  static String image(int id, {String? size}) =>
      '/images/$id${size != null ? '?size=$size' : ''}';

  // Communities
  static const String communities = '/communities';
  static const String communitiesOverview = '/communities/overview';
  static const String communityFriends = '/communityFriends';

  // Borrower
  static const String files = '/files';
  static String borrowerSubmit(int userId) => '/users/$userId/borrower/submit';

  // Payments & Invoices
  static const String paymentMethods = '/payment_methods';
  static String paymentMethodDetail(int id) => '/payment_methods/$id';
  static String loanPrepay(int loanId) => '/loans/$loanId/prepay';
  static String loanPay(int loanId) => '/loans/$loanId/pay';
  static const String invoices = '/invoices';
  static const String pricings = '/pricings';

  // Incidents
  static const String incidents = '/incidents';
  static String incidentDetail(int id) => '/incidents/$id';
  static String incidentComplete(int id) => '/incidents/$id/complete';
  static String incidentReopen(int id) => '/incidents/$id/reopen';
  static String incidentNotes(int id) => '/incidents/$id/note';
  static String incidentBlock(int id) => '/incidents/$id/block';

  // Status & GBFS
  static const String status = '/status';
  static const String stats = '/stats';
  static const String gbfsDatasets = '/gbfs_datasets';
}

class StorageKeys {
  static const String accessToken = 'locomotion_access_token';
  static const String refreshToken = 'locomotion_refresh_token';
  static const String tokenExpiresAt = 'locomotion_token_expires_at';
  static const String cachedUser = 'locomotion_cached_user';
  static const String activeCommunityId = 'locomotion_active_community_id';
  static String pendingPhotoCapture(int userId) =>
      'locomotion_pending_photo_capture_$userId';
}
