import '../entities/fleet_vehicle.dart';

abstract class FleetRepository {
  Future<List<FleetVehicle>> getOwnerFleet();
  Future<FleetVehicle> getVehicle(int id);
  Future<FleetVehicle> createVehicle(
    Map<String, dynamic> data, {
    String? idempotencyKey,
  });
  Future<FleetVehicle> updateVehicle(
    int id,
    Map<String, dynamic> data, {
    String? lockVersion,
  });
  Future<void> publishVehicle(int id);
}
