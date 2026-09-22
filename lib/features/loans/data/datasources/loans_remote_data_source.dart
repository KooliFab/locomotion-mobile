import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/loan_creation_request.dart';
import '../../domain/entities/loans_dashboard.dart';

abstract class LoansRemoteDataSource {
  Future<LoansDashboard> getDashboard();
  Future<Loan> createLoan(LoanCreationRequest request);
  Future<List<Loan>> getMyLoans();
}

class LoansRemoteDataSourceImpl implements LoansRemoteDataSource {
  final ApiClient _apiClient;

  const LoansRemoteDataSourceImpl(this._apiClient);

  @override
  Future<LoansDashboard> getDashboard() async {
    final response = await _apiClient.get(ApiEndpoints.loansDashboard);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return LoansDashboard.fromJson(data);
    }
    throw const FormatException(
      'Format de réponse invalide pour le tableau de bord des réservations',
    );
  }

  @override
  Future<Loan> createLoan(LoanCreationRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.loans,
      data: request.toJson(),
    );

    final data = response.data;
    final item =
        data is Map<String, dynamic> && data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : (data is Map<String, dynamic> && data['loan'] is Map<String, dynamic>
              ? data['loan'] as Map<String, dynamic>
              : data as Map<String, dynamic>);

    return Loan.fromJson(item);
  }

  @override
  Future<List<Loan>> getMyLoans() async {
    final response = await _apiClient.get(ApiEndpoints.loans);
    final data = response.data;
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().map(Loan.fromJson).toList();
    } else if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(Loan.fromJson)
          .toList();
    }
    return [];
  }
}
