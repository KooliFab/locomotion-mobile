import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/network_providers.dart';
import '../../data/datasources/communities_remote_data_source.dart';
import '../../data/repositories/communities_repository_impl.dart';
import '../../domain/entities/community.dart';
import '../../domain/repositories/communities_repository.dart';

part 'communities_controller.g.dart';

@Riverpod(keepAlive: true)
CommunitiesRemoteDataSource communitiesRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CommunitiesRemoteDataSourceImpl(apiClient);
}

@Riverpod(keepAlive: true)
CommunitiesRepository communitiesRepository(Ref ref) {
  final remoteDataSource = ref.watch(communitiesRemoteDataSourceProvider);
  return CommunitiesRepositoryImpl(remoteDataSource);
}

@Riverpod(keepAlive: true)
class CommunitiesListController extends _$CommunitiesListController {
  @override
  FutureOr<List<Community>> build() async {
    final repository = ref.watch(communitiesRepositoryProvider);
    return repository.getCommunities();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(communitiesRepositoryProvider);
      return repository.getCommunities();
    });
  }
}
