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

@ProviderFor(SelectedLoanableCommunity)
final selectedLoanableCommunityProvider = SelectedLoanableCommunityProvider._();

final class SelectedLoanableCommunityProvider
    extends $NotifierProvider<SelectedLoanableCommunity, int?> {
  SelectedLoanableCommunityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedLoanableCommunityProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedLoanableCommunityHash();

  @$internal
  @override
  SelectedLoanableCommunity create() => SelectedLoanableCommunity();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$selectedLoanableCommunityHash() =>
    r'857b06c55eafaf21513e29bababef04307d5bc68';

abstract class _$SelectedLoanableCommunity extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(LoanablesListController)
final loanablesListControllerProvider = LoanablesListControllerProvider._();

final class LoanablesListControllerProvider
    extends $AsyncNotifierProvider<LoanablesListController, LoanablesPage> {
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
    r'ad551c5d1ac25a0954a20c672f5b6edd0e224bce';

abstract class _$LoanablesListController extends $AsyncNotifier<LoanablesPage> {
  FutureOr<LoanablesPage> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LoanablesPage>, LoanablesPage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LoanablesPage>, LoanablesPage>,
              AsyncValue<LoanablesPage>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(loanableDetail)
final loanableDetailProvider = LoanableDetailFamily._();

final class LoanableDetailProvider
    extends
        $FunctionalProvider<AsyncValue<Loanable>, Loanable, FutureOr<Loanable>>
    with $FutureModifier<Loanable>, $FutureProvider<Loanable> {
  LoanableDetailProvider._({
    required LoanableDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'loanableDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loanableDetailHash();

  @override
  String toString() {
    return r'loanableDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Loanable> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Loanable> create(Ref ref) {
    final argument = this.argument as int;
    return loanableDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoanableDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loanableDetailHash() => r'ec7171083303d21fabf930f39071b3735ed139c2';

final class LoanableDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Loanable>, int> {
  LoanableDetailFamily._()
    : super(
        retry: null,
        name: r'loanableDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoanableDetailProvider call(int loanableId) =>
      LoanableDetailProvider._(argument: loanableId, from: this);

  @override
  String toString() => r'loanableDetailProvider';
}

@ProviderFor(LoanableAvailabilityPeriod)
final loanableAvailabilityPeriodProvider = LoanableAvailabilityPeriodFamily._();

final class LoanableAvailabilityPeriodProvider
    extends $NotifierProvider<LoanableAvailabilityPeriod, String> {
  LoanableAvailabilityPeriodProvider._({
    required LoanableAvailabilityPeriodFamily super.from,
    required (int, {String? timezone}) super.argument,
  }) : super(
         retry: null,
         name: r'loanableAvailabilityPeriodProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loanableAvailabilityPeriodHash();

  @override
  String toString() {
    return r'loanableAvailabilityPeriodProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LoanableAvailabilityPeriod create() => LoanableAvailabilityPeriod();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LoanableAvailabilityPeriodProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loanableAvailabilityPeriodHash() =>
    r'ef4b3990561a0eec267c186092730ac26f271347';

final class LoanableAvailabilityPeriodFamily extends $Family
    with
        $ClassFamilyOverride<
          LoanableAvailabilityPeriod,
          String,
          String,
          String,
          (int, {String? timezone})
        > {
  LoanableAvailabilityPeriodFamily._()
    : super(
        retry: null,
        name: r'loanableAvailabilityPeriodProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoanableAvailabilityPeriodProvider call(int loanableId, {String? timezone}) =>
      LoanableAvailabilityPeriodProvider._(
        argument: (loanableId, timezone: timezone),
        from: this,
      );

  @override
  String toString() => r'loanableAvailabilityPeriodProvider';
}

abstract class _$LoanableAvailabilityPeriod extends $Notifier<String> {
  late final _$args = ref.$arg as (int, {String? timezone});
  int get loanableId => _$args.$1;
  String? get timezone => _$args.timezone;

  String build(int loanableId, {String? timezone});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(_$args.$1, timezone: _$args.timezone),
    );
  }
}

@ProviderFor(loanableAvailabilityWindow)
final loanableAvailabilityWindowProvider = LoanableAvailabilityWindowFamily._();

final class LoanableAvailabilityWindowProvider
    extends
        $FunctionalProvider<
          AsyncValue<LoanableAvailabilityWindow>,
          LoanableAvailabilityWindow,
          FutureOr<LoanableAvailabilityWindow>
        >
    with
        $FutureModifier<LoanableAvailabilityWindow>,
        $FutureProvider<LoanableAvailabilityWindow> {
  LoanableAvailabilityWindowProvider._({
    required LoanableAvailabilityWindowFamily super.from,
    required (int, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'loanableAvailabilityWindowProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loanableAvailabilityWindowHash();

  @override
  String toString() {
    return r'loanableAvailabilityWindowProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<LoanableAvailabilityWindow> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LoanableAvailabilityWindow> create(Ref ref) {
    final argument = this.argument as (int, String, String);
    return loanableAvailabilityWindow(
      ref,
      argument.$1,
      argument.$2,
      argument.$3,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LoanableAvailabilityWindowProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loanableAvailabilityWindowHash() =>
    r'eff584d4a4167d4bccbf09ffda6658f06283d297';

final class LoanableAvailabilityWindowFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<LoanableAvailabilityWindow>,
          (int, String, String)
        > {
  LoanableAvailabilityWindowFamily._()
    : super(
        retry: null,
        name: r'loanableAvailabilityWindowProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoanableAvailabilityWindowProvider call(
    int loanableId,
    String start,
    String end,
  ) => LoanableAvailabilityWindowProvider._(
    argument: (loanableId, start, end),
    from: this,
  );

  @override
  String toString() => r'loanableAvailabilityWindowProvider';
}
