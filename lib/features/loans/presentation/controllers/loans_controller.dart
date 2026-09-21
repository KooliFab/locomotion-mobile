import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/network_providers.dart';
import '../../data/datasources/loans_remote_data_source.dart';
import '../../data/repositories/loans_repository_impl.dart';
import '../../domain/entities/loan.dart';
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
class MyLoansController extends _$MyLoansController {
  @override
  FutureOr<List<Loan>> build() async {
    final repository = ref.watch(loansRepositoryProvider);
    try {
      return await repository.getMyLoans();
    } catch (_) {
      // Fallback empty list or preview for initial dev
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(loansRepositoryProvider);
      return await repository.getMyLoans();
    });
  }

  Future<void> returnVehicle(int loanId) async {
    final repository = ref.read(loansRepositoryProvider);
    await repository.returnLoan(loanId);
    await refresh();
  }

  Future<void> cancelReservation(int loanId) async {
    final repository = ref.read(loansRepositoryProvider);
    await repository.cancelLoan(loanId);
    await refresh();
  }
}
