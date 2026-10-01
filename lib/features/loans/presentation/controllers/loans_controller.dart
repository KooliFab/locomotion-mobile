import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/network_providers.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../loanables/presentation/controllers/loanables_controller.dart';
import '../../data/datasources/loans_remote_data_source.dart';
import '../../data/repositories/loans_repository_impl.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/loan_comment.dart';
import '../../domain/entities/loan_dates_update_request.dart';
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

/// Centralized invalidation helper for dashboard, list, and detail views.
/// Accepts either [Ref] or [WidgetRef].
/// Reusable by Lot 4, Lot 5, and Lot 6.
void invalidateLoanViews(dynamic ref, {int? loanId, int? loanableId}) {
  ref.invalidate(loansDashboardControllerProvider);
  ref.invalidate(myLoansControllerProvider);
  ref.invalidate(cancelledOrRejectedLoansProvider);
  if (loanId != null) {
    ref.invalidate(loanDetailProvider(loanId));
  }
  if (loanableId != null) {
    ref.invalidate(loanableDetailProvider(loanableId));
  }
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

/// Detail provider for `GET /loans/{id}`
@riverpod
Future<Loan> loanDetail(Ref ref, int id) async {
  final repository = ref.watch(loansRepositoryProvider);
  return repository.getLoanDetail(id);
}

/// Provider for canceled / rejected loans for the current borrower
@riverpod
Future<List<Loan>> cancelledOrRejectedLoans(Ref ref) async {
  final user = ref.watch(authControllerProvider).value;
  final repository = ref.watch(loansRepositoryProvider);

  // Status enum filter with comma separation as supported by WebQueryBuilder
  final page = await repository.getLoansPage(
    page: 1,
    perPage: 20,
    status: 'canceled,rejected',
    borrowerUserId: user?.id,
  );
  return page.data;
}

/// Action controller for borrower actions: cancel, update dates, comment
@Riverpod(keepAlive: true)
class LoanActionsController extends _$LoanActionsController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<Loan?> cancel(int loanId, {int? loanableId}) async {
    state = const AsyncLoading();
    Loan? result;
    state = await AsyncValue.guard(() async {
      final repo = ref.read(loansRepositoryProvider);
      result = await repo.cancelLoan(loanId);
      invalidateLoanViews(ref, loanId: loanId, loanableId: loanableId ?? result?.loanableId);
      return;
    });
    if (state.hasError) {
      throw state.error!;
    }
    return result;
  }

  Future<Loan?> updateDates({
    required int loanId,
    required String departureAt,
    required int durationInMinutes,
    int? loanableId,
  }) async {
    state = const AsyncLoading();
    Loan? result;
    state = await AsyncValue.guard(() async {
      final repo = ref.read(loansRepositoryProvider);
      result = await repo.updateLoanDates(
        loanId,
        LoanDatesUpdateRequest(
          departureAt: departureAt,
          durationInMinutes: durationInMinutes,
        ),
      );
      invalidateLoanViews(ref, loanId: loanId, loanableId: loanableId ?? result?.loanableId);
      return;
    });
    if (state.hasError) {
      throw state.error!;
    }
    return result;
  }

  Future<LoanComment?> addComment({
    required int loanId,
    required String text,
    int? loanableId,
  }) async {
    state = const AsyncLoading();
    LoanComment? comment;
    state = await AsyncValue.guard(() async {
      final repo = ref.read(loansRepositoryProvider);
      comment = await repo.addComment(loanId, text);
      invalidateLoanViews(ref, loanId: loanId, loanableId: loanableId);
      return;
    });
    if (state.hasError) {
      throw state.error!;
    }
    return comment;
  }

  Future<Loan?> accept(int loanId, {String? comment, int? loanableId}) async {
    state = const AsyncLoading();
    Loan? result;
    state = await AsyncValue.guard(() async {
      final repo = ref.read(loansRepositoryProvider);
      result = await repo.acceptLoan(loanId, comment: comment);
      invalidateLoanViews(ref, loanId: loanId, loanableId: loanableId ?? result?.loanableId);
      return;
    });
    if (state.hasError) {
      throw state.error!;
    }
    return result;
  }

  Future<Loan?> reject(int loanId, {String? comment, int? loanableId}) async {
    state = const AsyncLoading();
    Loan? result;
    state = await AsyncValue.guard(() async {
      final repo = ref.read(loansRepositoryProvider);
      result = await repo.rejectLoan(loanId, comment: comment);
      invalidateLoanViews(ref, loanId: loanId, loanableId: loanableId ?? result?.loanableId);
      return;
    });
    if (state.hasError) {
      throw state.error!;
    }
    return result;
  }
}
