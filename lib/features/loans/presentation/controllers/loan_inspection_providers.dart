import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_providers.dart';
import '../../../../core/storage/storage_providers.dart';
import '../../data/datasources/departure_draft_local_data_source.dart';
import '../../data/datasources/loan_inspection_remote_data_source.dart';
import '../../data/datasources/return_draft_local_data_source.dart';
import '../../data/repositories/departure_draft_repository_impl.dart';
import '../../data/repositories/loan_inspection_repository_impl.dart';
import '../../data/repositories/return_draft_repository_impl.dart';
import '../../domain/repositories/departure_draft_repository.dart';
import '../../domain/repositories/loan_inspection_repository.dart';
import '../../domain/repositories/return_draft_repository.dart';

final departureDraftLocalDataSourceProvider =
    Provider<DepartureDraftLocalDataSource>((ref) {
      final storage = ref.watch(secureStorageServiceProvider);
      return DepartureDraftLocalDataSourceImpl(storage);
    });

final departureDraftRepositoryProvider = Provider<DepartureDraftRepository>((
  ref,
) {
  final localDataSource = ref.watch(departureDraftLocalDataSourceProvider);
  return DepartureDraftRepositoryImpl(localDataSource);
});

final returnDraftLocalDataSourceProvider = Provider<ReturnDraftLocalDataSource>(
  (ref) {
    final storage = ref.watch(secureStorageServiceProvider);
    return ReturnDraftLocalDataSourceImpl(storage);
  },
);

final returnDraftRepositoryProvider = Provider<ReturnDraftRepository>((ref) {
  final localDataSource = ref.watch(returnDraftLocalDataSourceProvider);
  return ReturnDraftRepositoryImpl(localDataSource);
});

final loanInspectionRemoteDataSourceProvider =
    Provider<LoanInspectionRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return LoanInspectionRemoteDataSourceImpl(apiClient);
    });

final loanInspectionRepositoryProvider = Provider<LoanInspectionRepository>((
  ref,
) {
  final remoteDataSource = ref.watch(loanInspectionRemoteDataSourceProvider);
  return LoanInspectionRepositoryImpl(remoteDataSource);
});
