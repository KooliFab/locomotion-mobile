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
    try {
      return await repository.getCommunities();
    } catch (_) {
      return _previewCommunities;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(communitiesRepositoryProvider);
      try {
        return await repository.getCommunities();
      } catch (_) {
        return _previewCommunities;
      }
    });
  }

  static const List<Community> _previewCommunities = [
    Community(
      id: 1,
      name: 'LocoMotion Ahuntsic',
      description: 'Communauté pionnière de partage à Ahuntsic-Cartierville.',
      city: 'Montréal',
      membersCount: 142,
      loanablesCount: 18,
    ),
    Community(
      id: 2,
      name: 'LocoMotion Petite-Patrie',
      description: 'Vélos cargos et véhicules partagés au cœur de Rosemont.',
      city: 'Montréal',
      membersCount: 215,
      loanablesCount: 26,
    ),
    Community(
      id: 3,
      name: 'LocoMotion Villeray',
      description: 'Mobilité active et voisinage solidaire à Villeray.',
      city: 'Montréal',
      membersCount: 98,
      loanablesCount: 12,
    ),
  ];
}
