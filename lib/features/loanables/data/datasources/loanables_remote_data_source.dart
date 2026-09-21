import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/loanable.dart';

abstract class LoanablesRemoteDataSource {
  Future<List<Loanable>> getLoanables({String? type, int? communityId});
  Future<Loanable> getLoanableDetails(int id);
}

class LoanablesRemoteDataSourceImpl implements LoanablesRemoteDataSource {
  final ApiClient _apiClient;

  const LoanablesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<Loanable>> getLoanables({String? type, int? communityId}) async {
    final queryParams = <String, dynamic>{};
    if (type != null) queryParams['type'] = type;
    if (communityId != null) queryParams['community_id'] = communityId;

    final response = await _apiClient.get(
      ApiEndpoints.loanables,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(Loanable.fromJson)
          .toList();
    } else if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(Loanable.fromJson)
          .toList();
    }
    return [];
  }

  @override
  Future<Loanable> getLoanableDetails(int id) async {
    final response = await _apiClient.get('${ApiEndpoints.loanables}/$id');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final item = data['loanable'] is Map<String, dynamic>
          ? data['loanable'] as Map<String, dynamic>
          : data;
      return Loanable.fromJson(item);
    }
    throw Exception('Détails du véhicule introuvables');
  }
}
