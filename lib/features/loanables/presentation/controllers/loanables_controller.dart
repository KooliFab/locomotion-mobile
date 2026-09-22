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
    return repository.getLoanables(type: selectedType);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(loanablesRepositoryProvider);
      final selectedType = ref.read(selectedLoanableTypeProvider);
      return repository.getLoanables(type: selectedType);
    });
  }
}
