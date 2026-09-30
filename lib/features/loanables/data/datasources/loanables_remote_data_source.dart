import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/loanable.dart';
import '../../domain/entities/loanable_availability.dart';
import '../../domain/entities/loanables_page.dart';

abstract class LoanablesRemoteDataSource {
  /// `GET /loanables` — paginated `ListLoanableResource`.
  ///
  /// Backend-supported filters (`Loanable::$filterTypes`):
  /// `id, name, type, deleted_at, is_deleted, library_id,
  /// min_loan_duration_in_minutes, max_loan_duration_in_minutes, sharing_mode`.
  /// Plus the scope parameter `shared_in_community=<id>`.
  /// There is NO text search on the backend.
  Future<LoanablesPage> getLoanables({
    String? type,
    int? communityId,
    int? page,
  });

  Future<Loanable> getLoanableDetails(int id);

  Future<List<LoanableAvailabilityInterval>> getAvailability(
    int loanableId, {
    required String start,
    required String end,
    String responseMode = 'available',
  });
}

class LoanablesRemoteDataSourceImpl implements LoanablesRemoteDataSource {
  final ApiClient _apiClient;

  const LoanablesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<LoanablesPage> getLoanables({
    String? type,
    int? communityId,
    int? page,
  }) async {
    final queryParams = <String, dynamic>{
      'relations': 'library,image,activeIncidents',
    };
    if (type != null) queryParams['type'] = type;
    if (communityId != null) queryParams['shared_in_community'] = communityId;
    if (page != null) queryParams['page'] = page;

    final response = await _apiClient.get(
      ApiEndpoints.loanables,
      queryParameters: queryParams,
    );

    final data = response.data;

    List<dynamic> items;
    int? currentPage;
    int? lastPage;
    int? total;

    if (data is List) {
      items = data;
      currentPage = page ?? 1;
      lastPage = currentPage; // bare list: no further pages
    } else if (data is Map<String, dynamic> && data['data'] is List) {
      items = data['data'] as List;
      final meta = data['meta'];
      if (meta is Map<String, dynamic>) {
        currentPage = (meta['current_page'] as num?)?.toInt() ?? page ?? 1;
        lastPage = (meta['last_page'] as num?)?.toInt();
        total = (meta['total'] as num?)?.toInt();
      } else {
        currentPage = page ?? 1;
        // links.next is the other signal Laravel provides
        final links = data['links'];
        if (links is Map<String, dynamic> && links['next'] != null) {
          lastPage = currentPage + 1;
        } else {
          lastPage = currentPage;
        }
      }
    } else {
      throw FormatException(
        'Format de réponse inattendu pour la liste des véhicules: ${data.runtimeType}',
      );
    }

    final itemsMap = items.map((item) {
      if (item is! Map<String, dynamic>) {
        throw FormatException('Élément de véhicule invalide: $item');
      }
      return Loanable.fromJson(item);
    }).toList();

    return LoanablesPage(
      items: itemsMap,
      page: currentPage,
      lastPage: lastPage,
      total: total,
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
    String responseMode = 'available',
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.loanableAvailability(loanableId),
      queryParameters: {
        'start': start,
        'end': end,
        'responseMode': responseMode,
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
