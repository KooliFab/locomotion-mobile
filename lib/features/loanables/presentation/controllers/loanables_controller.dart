import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/network_providers.dart';
import '../../data/datasources/loanables_remote_data_source.dart';
import '../../data/repositories/loanables_repository_impl.dart';
import '../../domain/entities/loanable.dart';
import '../../domain/repositories/loanables_repository.dart';

part 'loanables_controller.g.dart';

@Riverpod(keepAlive: true)
LoanablesRemoteDataSource loanablesRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LoanablesRemoteDataSourceImpl(apiClient);
}

@Riverpod(keepAlive: true)
LoanablesRepository loanablesRepository(Ref ref) {
  final remoteDataSource = ref.watch(loanablesRemoteDataSourceProvider);
  return LoanablesRepositoryImpl(remoteDataSource);
}

@Riverpod(keepAlive: true)
class SelectedLoanableType extends _$SelectedLoanableType {
  @override
  String? build() => null;

  void selectType(String? type) {
    state = type;
  }
}

@Riverpod(keepAlive: true)
class LoanablesListController extends _$LoanablesListController {
  @override
  FutureOr<List<Loanable>> build() async {
    final repository = ref.watch(loanablesRepositoryProvider);
    final selectedType = ref.watch(selectedLoanableTypeProvider);

    try {
      return await repository.getLoanables(type: selectedType);
    } catch (_) {
      // Fallback preview items if API not yet populated locally
      return _previewLoanables;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(loanablesRepositoryProvider);
      final selectedType = ref.read(selectedLoanableTypeProvider);
      try {
        return await repository.getLoanables(type: selectedType);
      } catch (_) {
        return _previewLoanables;
      }
    });
  }

  static const List<Loanable> _previewLoanables = [
    Loanable(
      id: 1,
      name: 'Toyota Prius Hybride',
      type: 'car',
      description: 'Voiture partagée 5 places, stationnement réservé sur rue.',
      address: 'Ahuntsic, Montréal',
      latitude: 45.5532,
      longitude: -73.6543,
      communityName: 'LocoMotion Ahuntsic',
      isAvailable: true,
    ),
    Loanable(
      id: 2,
      name: 'Vélo Cargo Électrique Babboe',
      type: 'bike',
      description: 'Vélo cargo idéal pour courses volumineuses ou sorties avec enfants.',
      address: 'Petite-Patrie, Montréal',
      latitude: 45.5348,
      longitude: -73.5982,
      communityName: 'LocoMotion Petite-Patrie',
      isAvailable: true,
    ),
    Loanable(
      id: 3,
      name: 'Remorque pour vélo Croozer',
      type: 'trailer',
      description: 'Remorque légère pliable avec attache standard universelle.',
      address: 'Villeray, Montréal',
      latitude: 45.5451,
      longitude: -73.6120,
      communityName: 'LocoMotion Villeray',
      isAvailable: true,
    ),
  ];
}
