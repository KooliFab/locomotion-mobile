enum TransportAlternative {
  delivery('delivery', 'Livraison de marchandises'),
  car('car', 'Voiture personnelle'),
  publicTransit('public_transit', 'Transport collectif'),
  bike('bike', 'Vélo personnel'),
  walking('walking', 'Marche à pied'),
  other('other', 'Autre mode de transport');

  final String value;
  final String label;

  const TransportAlternative(this.value, this.label);

  static TransportAlternative? fromValue(String? value) {
    if (value == null) return null;
    for (final alt in values) {
      if (alt.value == value) return alt;
    }
    return null;
  }
}
