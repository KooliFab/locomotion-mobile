import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/community.dart';

abstract class CommunitiesRemoteDataSource {
  Future<List<Community>> getCommunities();
  Future<Community> getCommunityDetails(int id);
}

class CommunitiesRemoteDataSourceImpl implements CommunitiesRemoteDataSource {
  final ApiClient _apiClient;

  const CommunitiesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<Community>> getCommunities() async {
    final response = await _apiClient.get(ApiEndpoints.communities);
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(Community.fromJson)
          .toList();
    } else if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(Community.fromJson)
          .toList();
    }
    return [];
  }

  @override
  Future<Community> getCommunityDetails(int id) async {
    final response = await _apiClient.get('${ApiEndpoints.communities}/$id');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final item = data['community'] is Map<String, dynamic>
          ? data['community'] as Map<String, dynamic>
          : data;
      return Community.fromJson(item);
    }
    throw Exception('Communauté introuvable');
  }
}
