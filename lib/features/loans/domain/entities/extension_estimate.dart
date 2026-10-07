class ExtensionBlockingLoan {
  final int id;
  final DateTime? departureAt;
  final String? borrowerName;
  final String? borrowerPhone;

  const ExtensionBlockingLoan({
    required this.id,
    this.departureAt,
    this.borrowerName,
    this.borrowerPhone,
  });

  factory ExtensionBlockingLoan.fromJson(Map<String, dynamic> json) {
    final borrowerUser = json['borrower_user'] as Map<String, dynamic>?;
    DateTime? dep;
    if (json['departure_at'] != null) {
      dep = DateTime.tryParse(
        json['departure_at'].toString().replaceAll(' ', 'T'),
      );
    }
    return ExtensionBlockingLoan(
      id: json['id'] as int? ?? 0,
      departureAt: dep,
      borrowerName: borrowerUser?['name'] as String?,
      borrowerPhone: borrowerUser?['phone'] as String?,
    );
  }
}

class ExtensionEstimate {
  final bool available;
  final ExtensionBlockingLoan? blockingLoan;
  final double? desiredContribution;
  final double? borrowerTotal;
  final double? ownerTotal;
  final bool depositExpiresBeforeReturn;
  final String? depositWarning;
  final DateTime? depositExpiresAt;

  const ExtensionEstimate({
    required this.available,
    this.blockingLoan,
    this.desiredContribution,
    this.borrowerTotal,
    this.ownerTotal,
    this.depositExpiresBeforeReturn = false,
    this.depositWarning,
    this.depositExpiresAt,
  });

  factory ExtensionEstimate.fromJson(Map<String, dynamic> json) {
    ExtensionBlockingLoan? blocking;
    if (json['blocking_loan'] is Map<String, dynamic>) {
      blocking = ExtensionBlockingLoan.fromJson(
        json['blocking_loan'] as Map<String, dynamic>,
      );
    }

    double? bTotal;
    final bInv = json['borrower_invoice'];
    if (bInv is Map<String, dynamic>) {
      if (bInv['user_balance_change'] != null) {
        bTotal = (bInv['user_balance_change'] as num).toDouble().abs();
      } else if (bInv['total'] != null) {
        bTotal = (bInv['total'] as num).toDouble().abs();
      }
    }

    double? oTotal;
    final oInv = json['owner_invoice'];
    if (oInv is Map<String, dynamic>) {
      if (oInv['user_balance_change'] != null) {
        oTotal = (oInv['user_balance_change'] as num).toDouble().abs();
      } else if (oInv['total'] != null) {
        oTotal = (oInv['total'] as num).toDouble().abs();
      }
    }

    DateTime? depExp;
    if (json['deposit_expires_at'] != null) {
      depExp = DateTime.tryParse(
        json['deposit_expires_at'].toString().replaceAll(' ', 'T'),
      );
    }

    return ExtensionEstimate(
      available: json['available'] as bool? ?? false,
      blockingLoan: blocking,
      desiredContribution: (json['desired_contribution'] as num?)?.toDouble(),
      borrowerTotal: bTotal,
      ownerTotal: oTotal,
      depositExpiresBeforeReturn:
          json['deposit_expires_before_return'] as bool? ?? false,
      depositWarning: json['deposit_warning'] as String?,
      depositExpiresAt: depExp,
    );
  }
}
