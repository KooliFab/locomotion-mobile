class AppMapMarker {
  final String id;
  final String title;
  final String? snippet;
  final double latitude;
  final double longitude;
  final String? type; // 'car', 'bike', 'trailer'
  final void Function()? onTap;

  const AppMapMarker({
    required this.id,
    required this.title,
    this.snippet,
    required this.latitude,
    required this.longitude,
    this.type,
    this.onTap,
  });
}
