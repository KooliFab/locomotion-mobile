import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/network_providers.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

part 'profile_controller.g.dart';

@Riverpod(keepAlive: true)
class UserBalanceController extends _$UserBalanceController {
  @override
  FutureOr<double> build() async {
    final authRepo = ref.watch(authRepositoryProvider);
    final isAuthenticated = await authRepo.isAuthenticated();
    if (!isAuthenticated) {
      return 0.0;
    }

    final apiClient = ref.watch(apiClientProvider);
    final response = await apiClient.get(ApiEndpoints.userBalance);
    return parseBalance(response.data);
  }

  /// Parses the user balance from server responses.
  /// Authoritative server returns a raw numeric scalar (e.g., 42.5 or 0),
  /// but numeric strings and legacy wrapped JSON maps are also supported.
  /// Throws [FormatException] if the payload cannot be parsed as a valid balance.
  static double parseBalance(dynamic data) {
    if (data is num) {
      return data.toDouble();
    }
    if (data is String) {
      final parsed = double.tryParse(data.trim());
      if (parsed != null) {
        return parsed;
      }
    }
    if (data is Map<String, dynamic>) {
      final balanceVal =
          data['balance'] ?? data['user_balance'] ?? data['amount'];
      if (balanceVal is num) {
        return balanceVal.toDouble();
      }
      if (balanceVal is String) {
        final parsed = double.tryParse(balanceVal.trim());
        if (parsed != null) {
          return parsed;
        }
      }
    }
    throw FormatException('Impossible de parser le solde utilisateur: $data');
  }
}
