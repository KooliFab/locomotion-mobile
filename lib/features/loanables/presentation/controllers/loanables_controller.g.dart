// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loanables_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(loanablesRemoteDataSource)
final loanablesRemoteDataSourceProvider = LoanablesRemoteDataSourceProvider._();

final class LoanablesRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          LoanablesRemoteDataSource,
          LoanablesRemoteDataSource,
          LoanablesRemoteDataSource
        >
    with $Provider<LoanablesRemoteDataSource> {
  LoanablesRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loanablesRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loanablesRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<LoanablesRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LoanablesRemoteDataSource create(Ref ref) {
    return loanablesRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoanablesRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoanablesRemoteDataSource>(value),
    );
  }
}

String _$loanablesRemoteDataSourceHash() =>
    r'c926ea299f2eeab24130df54396633a058e8f235';

@ProviderFor(loanablesRepository)
final loanablesRepositoryProvider = LoanablesRepositoryProvider._();

final class LoanablesRepositoryProvider
    extends
        $FunctionalProvider<
          LoanablesRepository,
          LoanablesRepository,
          LoanablesRepository
        >
    with $Provider<LoanablesRepository> {
  LoanablesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loanablesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loanablesRepositoryHash();

  @$internal
  @override
  $ProviderElement<LoanablesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LoanablesRepository create(Ref ref) {
    return loanablesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoanablesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoanablesRepository>(value),
    );
  }
}

String _$loanablesRepositoryHash() =>
    r'5049df0aae81efcf8aa18c88d5e4c16050adfcbc';

@ProviderFor(SelectedLoanableType)
final selectedLoanableTypeProvider = SelectedLoanableTypeProvider._();

final class SelectedLoanableTypeProvider
    extends $NotifierProvider<SelectedLoanableType, String?> {
  SelectedLoanableTypeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedLoanableTypeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedLoanableTypeHash();

  @$internal
  @override
  SelectedLoanableType create() => SelectedLoanableType();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedLoanableTypeHash() =>
    r'7f58550d3a3a08ab225757318433eaafb8cde120';

abstract class _$SelectedLoanableType extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(LoanablesListController)
final loanablesListControllerProvider = LoanablesListControllerProvider._();

final class LoanablesListControllerProvider
    extends $AsyncNotifierProvider<LoanablesListController, List<Loanable>> {
  LoanablesListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loanablesListControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loanablesListControllerHash();

  @$internal
  @override
  LoanablesListController create() => LoanablesListController();
}

String _$loanablesListControllerHash() =>
    r'b093de9e6163e940d95c38793e49b0967e18e45d';

abstract class _$LoanablesListController
    extends $AsyncNotifier<List<Loanable>> {
  FutureOr<List<Loanable>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Loanable>>, List<Loanable>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Loanable>>, List<Loanable>>,
              AsyncValue<List<Loanable>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
