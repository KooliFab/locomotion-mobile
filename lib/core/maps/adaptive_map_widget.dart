import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:apple_maps_flutter/apple_maps_flutter.dart' as apple;
import 'package:flutter_map/flutter_map.dart' as osm;
import 'package:latlong2/latlong.dart' as latlong;
import '../theme/app_colors.dart';
import 'map_marker.dart';

class AdaptiveMapWidget extends StatelessWidget {
  final double initialLatitude;
  final double initialLongitude;
  final double initialZoom;
  final List<AppMapMarker> markers;
  final void Function(double lat, double lng)? onTap;

  const AdaptiveMapWidget({
    super.key,
    this.initialLatitude = 45.5017, // Montréal coordinates by default
    this.initialLongitude = -73.5673,
    this.initialZoom = 13.0,
    this.markers = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // If running natively on iOS, use Apple Maps
    if (!kIsWeb && Platform.isIOS) {
      return _buildAppleMap();
    }

    // On Android, Web, or desktop, use FlutterMap with OpenStreetMap
    return _buildOpenStreetMap();
  }

  Widget _buildAppleMap() {
    final annotations = markers.map((marker) {
      return apple.Annotation(
        annotationId: apple.AnnotationId(marker.id),
        position: apple.LatLng(marker.latitude, marker.longitude),
        infoWindow: apple.InfoWindow(
          title: marker.title,
          snippet: marker.snippet,
        ),
        onTap: marker.onTap,
      );
    }).toSet();

    return apple.AppleMap(
      initialCameraPosition: apple.CameraPosition(
        target: apple.LatLng(initialLatitude, initialLongitude),
        zoom: initialZoom,
      ),
      annotations: annotations,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }

  Widget _buildOpenStreetMap() {
    final osmMarkers = markers.map((m) {
      return osm.Marker(
        point: latlong.LatLng(m.latitude, m.longitude),
        width: 44,
        height: 44,
        child: GestureDetector(
          onTap: m.onTap,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              _getIconForType(m.type),
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      );
    }).toList();

    return osm.FlutterMap(
      options: osm.MapOptions(
        initialCenter: latlong.LatLng(initialLatitude, initialLongitude),
        initialZoom: initialZoom,
        onTap: onTap != null
            ? (tapPosition, point) => onTap!(point.latitude, point.longitude)
            : null,
      ),
      children: [
        osm.TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'app.locomotion.mobile',
        ),
        osm.MarkerLayer(markers: osmMarkers),
      ],
    );
  }

  IconData _getIconForType(String? type) {
    switch (type) {
      case 'car':
        return Icons.directions_car_rounded;
      case 'bike':
        return Icons.pedal_bike_rounded;
      case 'trailer':
        return Icons.rv_hookup_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }
}
