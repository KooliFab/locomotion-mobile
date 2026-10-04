import '../../domain/entities/fleet_vehicle.dart';
import '../../domain/repositories/fleet_repository.dart';
import '../datasources/fleet_remote_data_source.dart';

class FleetRepositoryImpl implements FleetRepository {
  final FleetRemoteDataSource _remoteDataSource;

  FleetRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<FleetVehicle>> getOwnerFleet() {
    return _remoteDataSource.getOwnerFleet();
  }

  @override
  Future<FleetVehicle> createVehicle(
    Map<String, dynamic> data, {
    String? idempotencyKey,
  }) {
    return _remoteDataSource.createVehicle(
      data,
      idempotencyKey: idempotencyKey,
    );
  }

  @override
  Future<FleetVehicle> updateVehicle(
    int id,
    Map<String, dynamic> data, {
    String? lockVersion,
  }) {
    return _remoteDataSource.updateVehicle(
      id,
      data,
      lockVersion: lockVersion,
    );
  }

  @override
  Future<void> publishVehicle(int id) {
    return _remoteDataSource.publishVehicle(id);
  }

  @override
  Future<Map<String, dynamic>> suspendVehicle(
    int id, {
    String? reason,
    bool preserveFuture = true,
  }) {
    return _remoteDataSource.suspendVehicle(
      id,
      reason: reason,
      preserveFuture: preserveFuture,
    );
  }

  @override
  Future<FleetVehicle> unsuspendVehicle(int id) {
    return _remoteDataSource.unsuspendVehicle(id);
  }
}
