import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/loan_comment.dart';
import '../../domain/entities/loan_creation_request.dart';
import '../../domain/entities/loan_dates_update_request.dart';
import '../../domain/entities/loan_pagination.dart';
import '../../domain/entities/loans_dashboard.dart';

abstract class LoansRemoteDataSource {
  Future<LoansDashboard> getDashboard();
  Future<Loan> createLoan(LoanCreationRequest request);
  Future<List<Loan>> getMyLoans();
  Future<Loan> getLoanDetail(int id);
  Future<LoanPagination> getLoansPage({
    int page = 1,
    int perPage = 10,
    String? status,
    int? borrowerUserId,
  });
  Future<Loan> cancelLoan(int id);
  Future<Loan> acceptLoan(int id, {String? comment});
  Future<Loan> rejectLoan(int id, {String? comment});
  Future<Loan> updateLoanDates(int id, LoanDatesUpdateRequest request);
  Future<LoanComment> addComment(int id, String text);
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
    if (data is! Map<String, dynamic>) {
      throw const FormatException(
        'Format de réponse invalide pour la création de la réservation',
      );
    }
    final item = data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : (data['loan'] is Map<String, dynamic>
            ? data['loan'] as Map<String, dynamic>
            : data);

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
    throw const FormatException(
      'Format de réponse invalide pour la liste des prêts',
    );
  }

  @override
  Future<Loan> getLoanDetail(int id) async {
    final response = await _apiClient.get(ApiEndpoints.loanDetail(id));
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Format de réponse invalide pour le détail du prêt #$id',
      );
    }
    final item = data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : data;
    return Loan.fromJson(item);
  }

  @override
  Future<LoanPagination> getLoansPage({
    int page = 1,
    int perPage = 10,
    String? status,
    int? borrowerUserId,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }
    if (borrowerUserId != null) {
      queryParams['borrower_user.id'] = borrowerUserId;
    }

    final response = await _apiClient.get(
      ApiEndpoints.loans,
      queryParameters: queryParams,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException(
        'Format de réponse invalide pour la pagination des réservations',
      );
    }

    final rawList = data['data'] is List ? data['data'] as List : <dynamic>[];
    final loans = rawList
        .whereType<Map<String, dynamic>>()
        .map(Loan.fromJson)
        .toList();

    int currentPage = page;
    int lastPage = page;
    int total = loans.length;

    if (data['meta'] is Map<String, dynamic>) {
      final meta = data['meta'] as Map<String, dynamic>;
      currentPage = (meta['current_page'] as num?)?.toInt() ?? currentPage;
      lastPage = (meta['last_page'] as num?)?.toInt() ?? lastPage;
      total = (meta['total'] as num?)?.toInt() ?? total;
    }

    return LoanPagination(
      data: loans,
      currentPage: currentPage,
      lastPage: lastPage,
      total: total,
      perPage: perPage,
    );
  }

  @override
  Future<Loan> cancelLoan(int id) async {
    final response = await _apiClient.put('${ApiEndpoints.loanDetail(id)}/cancel');
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Format de réponse invalide pour l\'annulation du prêt #$id',
      );
    }
    final item = data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : data;
    return Loan.fromJson(item);
  }

  @override
  Future<Loan> acceptLoan(int id, {String? comment}) async {
    final body = <String, dynamic>{};
    if (comment != null && comment.trim().isNotEmpty) {
      body['comment'] = comment.trim();
    }
    final response = await _apiClient.put(
      '${ApiEndpoints.loanDetail(id)}/accept',
      data: body.isNotEmpty ? body : null,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Format de réponse invalide pour l\'acceptation du prêt #$id',
      );
    }
    final item = data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : data;
    return Loan.fromJson(item);
  }

  @override
  Future<Loan> rejectLoan(int id, {String? comment}) async {
    final body = <String, dynamic>{};
    if (comment != null && comment.trim().isNotEmpty) {
      body['comment'] = comment.trim();
    }
    final response = await _apiClient.put(
      '${ApiEndpoints.loanDetail(id)}/reject',
      data: body.isNotEmpty ? body : null,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Format de réponse invalide pour le refus du prêt #$id',
      );
    }
    final item = data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : data;
    return Loan.fromJson(item);
  }

  @override
  Future<Loan> updateLoanDates(int id, LoanDatesUpdateRequest request) async {
    final response = await _apiClient.put(
      '${ApiEndpoints.loanDetail(id)}/dates',
      data: request.toJson(),
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Format de réponse invalide pour la mise à jour des dates du prêt #$id',
      );
    }
    final item = data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : data;
    return Loan.fromJson(item);
  }

  @override
  Future<LoanComment> addComment(int id, String text) async {
    final response = await _apiClient.post(
      '${ApiEndpoints.loanDetail(id)}/comment',
      data: {'text': text},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Format de réponse invalide pour l\'ajout de commentaire au prêt #$id',
      );
    }
    final item = data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : data;
    return LoanComment.fromJson(item);
  }
}
