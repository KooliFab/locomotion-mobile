import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/network_providers.dart';
import '../../data/datasources/loanables_remote_data_source.dart';
import '../../data/repositories/loanables_repository_impl.dart';
import '../../domain/entities/loanable.dart';
import '../../domain/entities/loanable_availability_window.dart';
import '../../domain/entities/loanables_page.dart';
import '../../domain/entities/vehicle_local_dates.dart';
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
class SelectedLoanableCommunity extends _$SelectedLoanableCommunity {
  @override
  int? build() => null;

  void selectCommunity(int? id) {
    state = id;
  }
}

@Riverpod(keepAlive: true)
class LoanablesListController extends _$LoanablesListController {
  Future<LoanablesPage> _fetchPage(int page) {
    final repository = ref.read(loanablesRepositoryProvider);
    return repository.getLoanables(
      type: ref.read(selectedLoanableTypeProvider),
      communityId: ref.read(selectedLoanableCommunityProvider),
      page: page,
    );
  }

  @override
  FutureOr<LoanablesPage> build() async {
    ref.watch(selectedLoanableTypeProvider);
    ref.watch(selectedLoanableCommunityProvider);
    return _fetchPage(1);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPage(1));
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    final typeAtRequest = ref.read(selectedLoanableTypeProvider);
    final communityAtRequest = ref.read(selectedLoanableCommunityProvider);

    state = AsyncData(
      current.copyWith(isLoadingMore: true, clearLoadMoreError: true),
    );
    try {
      final next = await _fetchPage(current.page + 1);

      // Discard response if filters changed while fetching or state was replaced
      if (ref.read(selectedLoanableTypeProvider) != typeAtRequest ||
          ref.read(selectedLoanableCommunityProvider) != communityAtRequest ||
          state.value !=
              current.copyWith(isLoadingMore: true, clearLoadMoreError: true)) {
        return;
      }

      state = AsyncData(
        LoanablesPage(
          items: [...current.items, ...next.items],
          page: next.page,
          lastPage: next.lastPage ?? current.lastPage,
          total: next.total ?? current.total,
        ),
      );
    } catch (e) {
      if (ref.read(selectedLoanableTypeProvider) != typeAtRequest ||
          ref.read(selectedLoanableCommunityProvider) != communityAtRequest) {
        return;
      }
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: e.toString()),
      );
    }
  }
}

@riverpod
Future<Loanable> loanableDetail(Ref ref, int loanableId) {
  return ref.watch(loanablesRepositoryProvider).getLoanableDetails(loanableId);
}

@riverpod
class LoanableAvailabilityPeriod extends _$LoanableAvailabilityPeriod {
  @override
  String build(int loanableId, {String? timezone}) {
    // Compute the initial date in the vehicle's timezone so that, around
    // midnight or for a vehicle in a different timezone, the correct calendar
    // day is used as the window start.
    return VehicleLocalDates.nowYmdInZone(timezone);
  }

  void shift(int days) {
    state = VehicleLocalDates.shiftYmd(state, days);
  }

  void goTo(String ymd) {
    state = ymd;
  }
}

@riverpod
Future<LoanableAvailabilityWindow> loanableAvailabilityWindow(
  Ref ref,
  int loanableId,
  String start,
  String end,
) async {
  final repository = ref.watch(loanablesRepositoryProvider);
  final results = await Future.wait([
    repository.getAvailability(
      loanableId,
      start: start,
      end: end,
      responseMode: 'available',
    ),
    repository.getAvailability(
      loanableId,
      start: start,
      end: end,
      responseMode: 'unavailable',
    ),
  ]);
  return LoanableAvailabilityWindow(
    available: results[0],
    unavailable: results[1],
  );
}
