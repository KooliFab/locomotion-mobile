import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/network_providers.dart';
import '../../../loanables/presentation/controllers/loanables_controller.dart';
import '../../data/datasources/fleet_remote_data_source.dart';
import '../../data/repositories/fleet_repository_impl.dart';
import '../../domain/entities/fleet_vehicle.dart';
import '../../domain/repositories/fleet_repository.dart';

part 'fleet_controller.g.dart';

@Riverpod(keepAlive: true)
FleetRemoteDataSource fleetRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FleetRemoteDataSourceImpl(apiClient);
}

@Riverpod(keepAlive: true)
FleetRepository fleetRepository(Ref ref) {
  final remote = ref.watch(fleetRemoteDataSourceProvider);
  return FleetRepositoryImpl(remote);
}

@Riverpod(keepAlive: true)
class OwnerFleetController extends _$OwnerFleetController {
  @override
  FutureOr<List<FleetVehicle>> build() {
    final repo = ref.watch(fleetRepositoryProvider);
    return repo.getOwnerFleet();
  }

  Future<void> refreshFleet() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(fleetRepositoryProvider);
      return repo.getOwnerFleet();
    });
  }

  Future<FleetVehicle> createVehicle(
    Map<String, dynamic> data, {
    String? idempotencyKey,
  }) async {
    final repo = ref.read(fleetRepositoryProvider);
    final vehicle = await repo.createVehicle(
      data,
      idempotencyKey: idempotencyKey,
    );

    _invalidateRelatedCaches(vehicle.id);
    await refreshFleet();
    return vehicle;
  }

  Future<FleetVehicle> updateVehicle(
    int id,
    Map<String, dynamic> patch, {
    String? lockVersion,
  }) async {
    final repo = ref.read(fleetRepositoryProvider);
    final vehicle = await repo.updateVehicle(
      id,
      patch,
      lockVersion: lockVersion,
    );

    _invalidateRelatedCaches(id);
    await refreshFleet();
    return vehicle;
  }

  Future<void> publishVehicle(int id) async {
    final repo = ref.read(fleetRepositoryProvider);
    await repo.publishVehicle(id);

    _invalidateRelatedCaches(id);
    await refreshFleet();
  }

  Future<Map<String, dynamic>> suspendVehicle(
    int id, {
    String? reason,
    bool preserveFuture = true,
  }) async {
    final repo = ref.read(fleetRepositoryProvider);
    final response = await repo.suspendVehicle(
      id,
      reason: reason,
      preserveFuture: preserveFuture,
    );

    _invalidateRelatedCaches(id);
    await refreshFleet();
    return response;
  }

  Future<FleetVehicle> unsuspendVehicle(int id) async {
    final repo = ref.read(fleetRepositoryProvider);
    final vehicle = await repo.unsuspendVehicle(id);

    _invalidateRelatedCaches(id);
    await refreshFleet();
    return vehicle;
  }

  void _invalidateRelatedCaches(int vehicleId) {
    ref.invalidate(loanablesListControllerProvider);
    ref.invalidate(loanableDetailProvider(vehicleId));
    ref.invalidate(loanableAvailabilityPeriodProvider(vehicleId));
  }
}

@riverpod
Future<FleetVehicle?> fleetVehicleDetail(Ref ref, int id) async {
  final fleet = await ref.watch(ownerFleetControllerProvider.future);
  try {
    return fleet.firstWhere((v) => v.id == id);
  } catch (_) {
    return null;
  }
}
