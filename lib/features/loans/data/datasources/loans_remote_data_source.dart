import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/extension_estimate.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/loan_comment.dart';
import '../../domain/entities/loan_creation_request.dart';
import '../../domain/entities/loan_dates_update_request.dart';
import '../../domain/entities/loan_factors_update.dart';
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
  Future<Loan> validateLoan(int id);
  Future<Loan> updateLoanDates(int id, LoanDatesUpdateRequest request);
  Future<LoanComment> addComment(int id, String text);
  Future<Loan> requestExtension(int id, int extensionDurationInMinutes);
  Future<Loan> acceptExtension(int id);
  Future<Loan> rejectExtension(int id);
  Future<Loan> cancelExtension(int id);
  Future<ExtensionEstimate> getExtensionEstimate(int id, int durationInMinutes);
  Future<Loan> updateFactors(int id, LoanFactorsUpdate update);
  Future<Loan> endLoanEarly(int id);

  /// Uploads a picture (`POST /images`) and returns the server image resource.
  Future<Map<String, dynamic>> uploadImage(File file, String field);
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
    final queryParams = <String, dynamic>{'page': page, 'per_page': perPage};
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
    final response = await _apiClient.put(
      '${ApiEndpoints.loanDetail(id)}/cancel',
    );
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
  Future<Loan> validateLoan(int id) async {
    final response = await _apiClient.put(
      '${ApiEndpoints.loanDetail(id)}/validate',
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Format de réponse invalide pour la validation du prêt #$id',
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

  @override
  Future<Loan> requestExtension(int id, int extensionDurationInMinutes) async {
    final response = await _apiClient.put(
      '${ApiEndpoints.loanDetail(id)}/extension',
      data: {'extension_duration_in_minutes': extensionDurationInMinutes},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Format de réponse invalide pour la demande de prolongation du prêt #$id',
      );
    }
    final item = data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : data;
    return Loan.fromJson(item);
  }

  @override
  Future<Loan> acceptExtension(int id) async {
    final response = await _apiClient.put(
      '${ApiEndpoints.loanDetail(id)}/extension/accept',
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Format de réponse invalide pour l\'acceptation de la prolongation du prêt #$id',
      );
    }
    final item = data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : data;
    return Loan.fromJson(item);
  }

  @override
  Future<Loan> rejectExtension(int id) async {
    final response = await _apiClient.put(
      '${ApiEndpoints.loanDetail(id)}/extension/reject',
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Format de réponse invalide pour le refus de la prolongation du prêt #$id',
      );
    }
    final item = data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : data;
    return Loan.fromJson(item);
  }

  @override
  Future<Loan> cancelExtension(int id) async {
    final response = await _apiClient.put(
      '${ApiEndpoints.loanDetail(id)}/extension/cancel',
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Format de réponse invalide pour l\'annulation de la prolongation du prêt #$id',
      );
    }
    final item = data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : data;
    return Loan.fromJson(item);
  }

  @override
  Future<ExtensionEstimate> getExtensionEstimate(
    int id,
    int durationInMinutes,
  ) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.loanDetail(id)}/estimate',
      queryParameters: {'duration_in_minutes': durationInMinutes},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Format de réponse invalide pour l\'estimation du prêt #$id',
      );
    }
    return ExtensionEstimate.fromJson(data);
  }

  @override
  Future<Loan> updateFactors(int id, LoanFactorsUpdate update) async {
    final response = await _apiClient.put(
      ApiEndpoints.loanFactors(id),
      data: update.toJson(),
    );
    return _parseLoan(
      response.data,
      'la mise à jour des informations du prêt #$id',
    );
  }

  @override
  Future<Loan> endLoanEarly(int id) async {
    final response = await _apiClient.put(ApiEndpoints.loanEarlyReturn(id));
    return _parseLoan(response.data, 'la fin anticipée du prêt #$id');
  }

  @override
  Future<Map<String, dynamic>> uploadImage(File file, String field) async {
    final filename = file.path.split('/').last;
    final formData = FormData.fromMap({
      'field': field,
      field: await MultipartFile.fromFile(file.path, filename: filename),
    });
    final response = await _apiClient.post(
      ApiEndpoints.images,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;
      if (inner['id'] != null) return inner;
    }
    throw const FormatException(
      'Format de réponse invalide lors du téléversement de la photo',
    );
  }

  Loan _parseLoan(dynamic data, String context) {
    if (data is! Map<String, dynamic>) {
      throw FormatException('Format de réponse invalide pour $context');
    }
    final item = data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : data;
    return Loan.fromJson(item);
  }
}
