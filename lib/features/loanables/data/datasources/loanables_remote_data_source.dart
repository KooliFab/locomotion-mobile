import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/loanable.dart';
import '../../domain/entities/loanable_availability.dart';

abstract class LoanablesRemoteDataSource {
  Future<List<Loanable>> getLoanables({
    String? type,
    int? communityId,
    int? page,
  });
  Future<Loanable> getLoanableDetails(int id);
  Future<List<LoanableAvailabilityInterval>> getAvailability(
    int loanableId, {
    required String start,
    required String end,
  });
}

class LoanablesRemoteDataSourceImpl implements LoanablesRemoteDataSource {
  final ApiClient _apiClient;

  const LoanablesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<Loanable>> getLoanables({
    String? type,
    int? communityId,
    int? page,
  }) async {
    final queryParams = <String, dynamic>{};
    if (type != null) queryParams['type'] = type;
    if (communityId != null) queryParams['community_id'] = communityId;
    if (page != null) queryParams['page'] = page;

    final response = await _apiClient.get(
      ApiEndpoints.loanables,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final data = response.data;
    if (data is List) {
      return data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw FormatException('Élément de véhicule invalide: $item');
        }
        return Loanable.fromJson(item);
      }).toList();
    } else if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List).map((item) {
        if (item is! Map<String, dynamic>) {
          throw FormatException('Élément de véhicule invalide: $item');
        }
        return Loanable.fromJson(item);
      }).toList();
    }
    throw FormatException(
      'Format de réponse inattendu pour la liste des véhicules: ${data.runtimeType}',
    );
  }

  @override
  Future<Loanable> getLoanableDetails(int id) async {
    final response = await _apiClient.get(ApiEndpoints.loanableDetail(id));
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final item = data['loanable'] is Map<String, dynamic>
          ? data['loanable'] as Map<String, dynamic>
          : (data['data'] is Map<String, dynamic>
                ? data['data'] as Map<String, dynamic>
                : data);
      return Loanable.fromJson(item);
    }
    throw FormatException('Format de réponse invalide pour le véhicule #$id');
  }

  @override
  Future<List<LoanableAvailabilityInterval>> getAvailability(
    int loanableId, {
    required String start,
    required String end,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.loanableAvailability(loanableId),
      queryParameters: {
        'start': start,
        'end': end,
        'responseMode': 'available',
      },
    );

    final data = response.data;
    if (data is List) {
      return data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw FormatException(
            'Élément invalide dans la liste de disponibilité du véhicule #$loanableId: $item',
          );
        }
        return LoanableAvailabilityInterval.fromJson(item);
      }).toList();
    }
    throw FormatException(
      'Format de réponse inattendu pour la disponibilité du véhicule #$loanableId: attendu List, reçu ${data.runtimeType}',
    );
  }
}
