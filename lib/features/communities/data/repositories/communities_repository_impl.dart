import '../../domain/entities/community.dart';
import '../../domain/repositories/communities_repository.dart';
import '../datasources/communities_remote_data_source.dart';

class CommunitiesRepositoryImpl implements CommunitiesRepository {
  final CommunitiesRemoteDataSource _remoteDataSource;

  const CommunitiesRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Community>> getCommunities() {
    return _remoteDataSource.getCommunities();
  }

  @override
  Future<Community> getCommunityDetails(int id) {
    return _remoteDataSource.getCommunityDetails(id);
  }
}
