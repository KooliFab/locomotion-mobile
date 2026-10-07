// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fleet_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fleetRemoteDataSource)
final fleetRemoteDataSourceProvider = FleetRemoteDataSourceProvider._();

final class FleetRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          FleetRemoteDataSource,
          FleetRemoteDataSource,
          FleetRemoteDataSource
        >
    with $Provider<FleetRemoteDataSource> {
  FleetRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fleetRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fleetRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<FleetRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FleetRemoteDataSource create(Ref ref) {
    return fleetRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FleetRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FleetRemoteDataSource>(value),
    );
  }
}

String _$fleetRemoteDataSourceHash() =>
    r'7727fade76f6edd70f76ad4b056ed8c9add01f1b';

@ProviderFor(fleetRepository)
final fleetRepositoryProvider = FleetRepositoryProvider._();

final class FleetRepositoryProvider
    extends
        $FunctionalProvider<FleetRepository, FleetRepository, FleetRepository>
    with $Provider<FleetRepository> {
  FleetRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fleetRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fleetRepositoryHash();

  @$internal
  @override
  $ProviderElement<FleetRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FleetRepository create(Ref ref) {
    return fleetRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FleetRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FleetRepository>(value),
    );
  }
}

String _$fleetRepositoryHash() => r'b062c8ad42dccfe3145005ebe8fc64cb11b4838e';

@ProviderFor(OwnerFleetController)
final ownerFleetControllerProvider = OwnerFleetControllerProvider._();

final class OwnerFleetControllerProvider
    extends $AsyncNotifierProvider<OwnerFleetController, List<FleetVehicle>> {
  OwnerFleetControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownerFleetControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownerFleetControllerHash();

  @$internal
  @override
  OwnerFleetController create() => OwnerFleetController();
}

String _$ownerFleetControllerHash() =>
    r'bf5bc86e049fd5dde4e6952ad6552a01394ae5d6';

abstract class _$OwnerFleetController
    extends $AsyncNotifier<List<FleetVehicle>> {
  FutureOr<List<FleetVehicle>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<FleetVehicle>>, List<FleetVehicle>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<FleetVehicle>>, List<FleetVehicle>>,
              AsyncValue<List<FleetVehicle>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Full vehicle resource: the fleet list (`for=profile`) only carries a summary.

@ProviderFor(fleetVehicleDetail)
final fleetVehicleDetailProvider = FleetVehicleDetailFamily._();

/// Full vehicle resource: the fleet list (`for=profile`) only carries a summary.

final class FleetVehicleDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<FleetVehicle?>,
          FleetVehicle?,
          FutureOr<FleetVehicle?>
        >
    with $FutureModifier<FleetVehicle?>, $FutureProvider<FleetVehicle?> {
  /// Full vehicle resource: the fleet list (`for=profile`) only carries a summary.
  FleetVehicleDetailProvider._({
    required FleetVehicleDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'fleetVehicleDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fleetVehicleDetailHash();

  @override
  String toString() {
    return r'fleetVehicleDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<FleetVehicle?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FleetVehicle?> create(Ref ref) {
    final argument = this.argument as int;
    return fleetVehicleDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FleetVehicleDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fleetVehicleDetailHash() =>
    r'9020d087fb4a731082c58d49214e752c1deb4885';

/// Full vehicle resource: the fleet list (`for=profile`) only carries a summary.

final class FleetVehicleDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<FleetVehicle?>, int> {
  FleetVehicleDetailFamily._()
    : super(
        retry: null,
        name: r'fleetVehicleDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Full vehicle resource: the fleet list (`for=profile`) only carries a summary.

  FleetVehicleDetailProvider call(int id) =>
      FleetVehicleDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'fleetVehicleDetailProvider';
}
