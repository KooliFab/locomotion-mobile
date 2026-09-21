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

  // Loans (reservations)
  static const String loans = '/loans';
  static const String loansDashboard = '/loans/dashboard';

  // Communities
  static const String communities = '/communities';
  static const String communitiesOverview = '/communities/overview';
  static const String communityFriends = '/communityFriends';

  // Payments & Invoices
  static const String paymentMethods = '/payment_methods';
  static const String invoices = '/invoices';
  static const String pricings = '/pricings';

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
}
