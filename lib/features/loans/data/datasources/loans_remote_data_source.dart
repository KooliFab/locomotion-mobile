import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/loan.dart';

abstract class LoansRemoteDataSource {
  Future<List<Loan>> getMyLoans();
  Future<Loan> createLoan({
    required int loanableId,
    required DateTime startAt,
    required DateTime endAt,
  });
  Future<void> cancelLoan(int loanId);
  Future<void> returnLoan(int loanId);
}

class LoansRemoteDataSourceImpl implements LoansRemoteDataSource {
  final ApiClient _apiClient;

  const LoansRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<Loan>> getMyLoans() async {
    final response = await _apiClient.get(ApiEndpoints.loans);
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(Loan.fromJson)
          .toList();
    } else if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(Loan.fromJson)
          .toList();
    }
    return [];
  }

  @override
  Future<Loan> createLoan({
    required int loanableId,
    required DateTime startAt,
    required DateTime endAt,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.loans,
      data: {
        'loanable_id': loanableId,
        'start_at': startAt.toIso8601String(),
        'end_at': endAt.toIso8601String(),
      },
    );

    final data = response.data;
    final item = data is Map<String, dynamic> && data['loan'] is Map<String, dynamic>
        ? data['loan'] as Map<String, dynamic>
        : data as Map<String, dynamic>;

    return Loan.fromJson(item);
  }

  @override
  Future<void> cancelLoan(int loanId) async {
    await _apiClient.put('${ApiEndpoints.loans}/$loanId/cancel');
  }

  @override
  Future<void> returnLoan(int loanId) async {
    await _apiClient.put('${ApiEndpoints.loans}/$loanId/return');
  }
}
