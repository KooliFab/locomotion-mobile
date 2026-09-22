import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/network_providers.dart';
import '../../data/datasources/loans_remote_data_source.dart';
import '../../data/repositories/loans_repository_impl.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/loans_dashboard.dart';
import '../../domain/repositories/loans_repository.dart';

part 'loans_controller.g.dart';

@Riverpod(keepAlive: true)
LoansRemoteDataSource loansRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LoansRemoteDataSourceImpl(apiClient);
}

@Riverpod(keepAlive: true)
LoansRepository loansRepository(Ref ref) {
  final remoteDataSource = ref.watch(loansRemoteDataSourceProvider);
  return LoansRepositoryImpl(remoteDataSource);
}

@Riverpod(keepAlive: true)
class LoansDashboardController extends _$LoansDashboardController {
  @override
  FutureOr<LoansDashboard> build() async {
    final repository = ref.watch(loansRepositoryProvider);
    return repository.getDashboard();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(loansRepositoryProvider);
      return repository.getDashboard();
    });
  }
}

@Riverpod(keepAlive: true)
class MyLoansController extends _$MyLoansController {
  @override
  FutureOr<List<Loan>> build() async {
    final repository = ref.watch(loansRepositoryProvider);
    return repository.getMyLoans();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(loansRepositoryProvider);
      return repository.getMyLoans();
    });
  }
}
