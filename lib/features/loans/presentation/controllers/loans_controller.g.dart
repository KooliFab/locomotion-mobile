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

/// Detail provider for `GET /loans/{id}`

@ProviderFor(loanDetail)
final loanDetailProvider = LoanDetailFamily._();

/// Detail provider for `GET /loans/{id}`

final class LoanDetailProvider
    extends $FunctionalProvider<AsyncValue<Loan>, Loan, FutureOr<Loan>>
    with $FutureModifier<Loan>, $FutureProvider<Loan> {
  /// Detail provider for `GET /loans/{id}`
  LoanDetailProvider._({
    required LoanDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'loanDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loanDetailHash();

  @override
  String toString() {
    return r'loanDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Loan> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Loan> create(Ref ref) {
    final argument = this.argument as int;
    return loanDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoanDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loanDetailHash() => r'd3ed2514b1bf4e56e5515a333c7f6d7b451ee5c1';

/// Detail provider for `GET /loans/{id}`

final class LoanDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Loan>, int> {
  LoanDetailFamily._()
    : super(
        retry: null,
        name: r'loanDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Detail provider for `GET /loans/{id}`

  LoanDetailProvider call(int id) =>
      LoanDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'loanDetailProvider';
}

/// Provider for canceled / rejected loans for the current borrower

@ProviderFor(cancelledOrRejectedLoans)
final cancelledOrRejectedLoansProvider = CancelledOrRejectedLoansProvider._();

/// Provider for canceled / rejected loans for the current borrower

final class CancelledOrRejectedLoansProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Loan>>,
          List<Loan>,
          FutureOr<List<Loan>>
        >
    with $FutureModifier<List<Loan>>, $FutureProvider<List<Loan>> {
  /// Provider for canceled / rejected loans for the current borrower
  CancelledOrRejectedLoansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cancelledOrRejectedLoansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cancelledOrRejectedLoansHash();

  @$internal
  @override
  $FutureProviderElement<List<Loan>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Loan>> create(Ref ref) {
    return cancelledOrRejectedLoans(ref);
  }
}

String _$cancelledOrRejectedLoansHash() =>
    r'97aa0bff3deec228a16775ae9cb098c0f07bc2ee';

/// Action controller for borrower actions: cancel, update dates, comment

@ProviderFor(LoanActionsController)
final loanActionsControllerProvider = LoanActionsControllerProvider._();

/// Action controller for borrower actions: cancel, update dates, comment
final class LoanActionsControllerProvider
    extends $NotifierProvider<LoanActionsController, AsyncValue<void>> {
  /// Action controller for borrower actions: cancel, update dates, comment
  LoanActionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loanActionsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loanActionsControllerHash();

  @$internal
  @override
  LoanActionsController create() => LoanActionsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$loanActionsControllerHash() =>
    r'b0b83752db3f489846f1c7ddd12d208af1fe90a4';

/// Action controller for borrower actions: cancel, update dates, comment

abstract class _$LoanActionsController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
