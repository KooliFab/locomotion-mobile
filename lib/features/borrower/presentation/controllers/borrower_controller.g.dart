// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrower_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(borrowerRemoteDataSource)
final borrowerRemoteDataSourceProvider = BorrowerRemoteDataSourceProvider._();

final class BorrowerRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          BorrowerRemoteDataSource,
          BorrowerRemoteDataSource,
          BorrowerRemoteDataSource
        >
    with $Provider<BorrowerRemoteDataSource> {
  BorrowerRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'borrowerRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$borrowerRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<BorrowerRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BorrowerRemoteDataSource create(Ref ref) {
    return borrowerRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BorrowerRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BorrowerRemoteDataSource>(value),
    );
  }
}

String _$borrowerRemoteDataSourceHash() =>
    r'32f271853ce4791ef8836737b860efa94cb8d8fc';

@ProviderFor(borrowerRepository)
final borrowerRepositoryProvider = BorrowerRepositoryProvider._();

final class BorrowerRepositoryProvider
    extends
        $FunctionalProvider<
          BorrowerRepository,
          BorrowerRepository,
          BorrowerRepository
        >
    with $Provider<BorrowerRepository> {
  BorrowerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'borrowerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$borrowerRepositoryHash();

  @$internal
  @override
  $ProviderElement<BorrowerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BorrowerRepository create(Ref ref) {
    return borrowerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BorrowerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BorrowerRepository>(value),
    );
  }
}

String _$borrowerRepositoryHash() =>
    r'5811126cfa051839316bee7b5e545c20f84ce968';

@ProviderFor(BorrowerController)
final borrowerControllerProvider = BorrowerControllerProvider._();

final class BorrowerControllerProvider
    extends $NotifierProvider<BorrowerController, Borrower?> {
  BorrowerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'borrowerControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$borrowerControllerHash();

  @$internal
  @override
  BorrowerController create() => BorrowerController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Borrower? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Borrower?>(value),
    );
  }
}

String _$borrowerControllerHash() =>
    r'70245dfd9af4467abe3a50ac481ea2cdf55949d8';

abstract class _$BorrowerController extends $Notifier<Borrower?> {
  Borrower? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Borrower?, Borrower?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Borrower?, Borrower?>,
              Borrower?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
