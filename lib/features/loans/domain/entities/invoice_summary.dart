/// Invoice summary as returned by Laravel `InvoiceSummaryResource`
/// (`borrower_invoice` / `owner_invoice` on a loan or an estimate).
///
/// Amounts are computed by the server; the app only displays them.
class InvoiceSummaryItem {
  final String itemType;
  final double amount;
  final double taxesTps;
  final double taxesTvq;
  final double total;

  const InvoiceSummaryItem({
    required this.itemType,
    required this.amount,
    this.taxesTps = 0,
    this.taxesTvq = 0,
    required this.total,
  });

  factory InvoiceSummaryItem.fromJson(Map<String, dynamic> json) {
    return InvoiceSummaryItem(
      itemType: json['item_type']?.toString() ?? '',
      amount: _toDouble(json['amount']),
      taxesTps: _toDouble(json['taxes_tps']),
      taxesTvq: _toDouble(json['taxes_tvq']),
      total: _toDouble(json['total']),
    );
  }

  /// French label for known `BillItemTypes` values.
  String get label {
    switch (itemType) {
      case 'loan.price':
        return 'Coût de l\'emprunt';
      case 'loan.time':
      case 'loan.duration':
        return 'Durée';
      case 'loan.distance':
        return 'Distance';
      case 'loan.minimum':
        return 'Montant minimum';
      case 'loan.insurance':
        return 'Assurance';
      case 'loan.expenses':
        return 'Dépenses remboursées';
      case 'loan.contribution':
      case 'loan.community_contribution':
        return 'Contribution à LocoMotion';
      case 'donation.loan':
        return 'Contribution volontaire';
      default:
        return itemType;
    }
  }
}

class InvoiceSummary {
  final List<InvoiceSummaryItem> items;

  /// Signed change applied to the user balance (negative = amount owed).
  final double userBalanceChange;

  const InvoiceSummary({required this.items, required this.userBalanceChange});

  /// Amount the user must pay (0 when the invoice credits the user).
  double get amountDue => userBalanceChange < 0 ? -userBalanceChange : 0;

  bool get isEmpty => items.isEmpty;

  static InvoiceSummary? tryParse(dynamic json) {
    if (json is! Map<String, dynamic>) return null;
    final rawItems = json['items'];
    return InvoiceSummary(
      items: rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(InvoiceSummaryItem.fromJson)
                .toList()
          : const [],
      userBalanceChange: _toDouble(json['user_balance_change']),
    );
  }
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}
