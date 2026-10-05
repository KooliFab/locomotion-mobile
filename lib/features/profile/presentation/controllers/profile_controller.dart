import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/network_providers.dart';

part 'profile_controller.g.dart';

@Riverpod(keepAlive: true)
class UserBalanceController extends _$UserBalanceController {
  @override
  FutureOr<double> build() async {
    final apiClient = ref.watch(apiClientProvider);
    try {
      final response = await apiClient.get(ApiEndpoints.userBalance);
      final data = response.data;
      if (data is Map<String, dynamic> && data['balance'] != null) {
        return (data['balance'] as num).toDouble();
      }
      return 0.0;
    } catch (_) {
      return 0.0;
    }
  }
}
