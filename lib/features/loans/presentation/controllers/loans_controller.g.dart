// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loans_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(loansRemoteDataSource)
final loansRemoteDataSourceProvider = LoansRemoteDataSourceProvider._();

final class LoansRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          LoansRemoteDataSource,
          LoansRemoteDataSource,
          LoansRemoteDataSource
        >
    with $Provider<LoansRemoteDataSource> {
  LoansRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loansRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loansRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<LoansRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LoansRemoteDataSource create(Ref ref) {
    return loansRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoansRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoansRemoteDataSource>(value),
    );
  }
}

String _$loansRemoteDataSourceHash() =>
    r'e398c81952908ff54c695756e182ab56e645dd18';

@ProviderFor(loansRepository)
final loansRepositoryProvider = LoansRepositoryProvider._();

final class LoansRepositoryProvider
    extends
        $FunctionalProvider<LoansRepository, LoansRepository, LoansRepository>
    with $Provider<LoansRepository> {
  LoansRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loansRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loansRepositoryHash();

  @$internal
  @override
  $ProviderElement<LoansRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoansRepository create(Ref ref) {
    return loansRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoansRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoansRepository>(value),
    );
  }
}

String _$loansRepositoryHash() => r'c2d0eceeb6a26d31eb2165323c37cd6c4e01cf1c';

@ProviderFor(LoansDashboardController)
final loansDashboardControllerProvider = LoansDashboardControllerProvider._();

final class LoansDashboardControllerProvider
    extends $AsyncNotifierProvider<LoansDashboardController, LoansDashboard> {
  LoansDashboardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loansDashboardControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loansDashboardControllerHash();

  @$internal
  @override
  LoansDashboardController create() => LoansDashboardController();
}

String _$loansDashboardControllerHash() =>
    r'ca7d4247ae97d556f586c7c07b66e0561729a1a9';

abstract class _$LoansDashboardController
    extends $AsyncNotifier<LoansDashboard> {
  FutureOr<LoansDashboard> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LoansDashboard>, LoansDashboard>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LoansDashboard>, LoansDashboard>,
              AsyncValue<LoansDashboard>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(MyLoansController)
final myLoansControllerProvider = MyLoansControllerProvider._();

final class MyLoansControllerProvider
    extends $AsyncNotifierProvider<MyLoansController, List<Loan>> {
  MyLoansControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myLoansControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myLoansControllerHash();

  @$internal
  @override
  MyLoansController create() => MyLoansController();
}

String _$myLoansControllerHash() => r'e1bfbe11e20c832fb10e8370cdc3b405027ff564';

abstract class _$MyLoansController extends $AsyncNotifier<List<Loan>> {
  FutureOr<List<Loan>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Loan>>, List<Loan>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Loan>>, List<Loan>>,
              AsyncValue<List<Loan>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
