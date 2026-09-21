// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'communities_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(communitiesRemoteDataSource)
final communitiesRemoteDataSourceProvider =
    CommunitiesRemoteDataSourceProvider._();

final class CommunitiesRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          CommunitiesRemoteDataSource,
          CommunitiesRemoteDataSource,
          CommunitiesRemoteDataSource
        >
    with $Provider<CommunitiesRemoteDataSource> {
  CommunitiesRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'communitiesRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$communitiesRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<CommunitiesRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CommunitiesRemoteDataSource create(Ref ref) {
    return communitiesRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommunitiesRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CommunitiesRemoteDataSource>(value),
    );
  }
}

String _$communitiesRemoteDataSourceHash() =>
    r'e11bc2fb2d761c3877bae6392f1088b074aac528';

@ProviderFor(communitiesRepository)
final communitiesRepositoryProvider = CommunitiesRepositoryProvider._();

final class CommunitiesRepositoryProvider
    extends
        $FunctionalProvider<
          CommunitiesRepository,
          CommunitiesRepository,
          CommunitiesRepository
        >
    with $Provider<CommunitiesRepository> {
  CommunitiesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'communitiesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$communitiesRepositoryHash();

  @$internal
  @override
  $ProviderElement<CommunitiesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CommunitiesRepository create(Ref ref) {
    return communitiesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommunitiesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CommunitiesRepository>(value),
    );
  }
}

String _$communitiesRepositoryHash() =>
    r'f042bbc58d40b1c304ec8b807dba5a4bf8e4c179';

@ProviderFor(CommunitiesListController)
final communitiesListControllerProvider = CommunitiesListControllerProvider._();

final class CommunitiesListControllerProvider
    extends $AsyncNotifierProvider<CommunitiesListController, List<Community>> {
  CommunitiesListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'communitiesListControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$communitiesListControllerHash();

  @$internal
  @override
  CommunitiesListController create() => CommunitiesListController();
}

String _$communitiesListControllerHash() =>
    r'02454aa98930f2c4c5ec7937abdd029a307ab0b9';

abstract class _$CommunitiesListController
    extends $AsyncNotifier<List<Community>> {
  FutureOr<List<Community>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Community>>, List<Community>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Community>>, List<Community>>,
              AsyncValue<List<Community>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
