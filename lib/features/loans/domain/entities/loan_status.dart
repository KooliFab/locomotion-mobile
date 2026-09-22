enum LoanStatus {
  requested('requested'),
  accepted('accepted'),
  confirmed('confirmed'),
  ongoing('ongoing'),
  ended('ended'),
  validated('validated'),
  completed('completed'),
  canceled('canceled'),
  rejected('rejected'),
  unknown('unknown');

  final String value;
  const LoanStatus(this.value);

  static LoanStatus fromString(String? val) {
    if (val == null) return LoanStatus.unknown;
    return LoanStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == val.toLowerCase(),
      orElse: () => LoanStatus.unknown,
    );
  }

  bool get isTerminal =>
      this == LoanStatus.completed ||
      this == LoanStatus.canceled ||
      this == LoanStatus.rejected;

  bool get isActive =>
      this == LoanStatus.ongoing ||
      this == LoanStatus.ended ||
      this == LoanStatus.validated;

  bool get isWaiting =>
      this == LoanStatus.requested ||
      this == LoanStatus.accepted ||
      this == LoanStatus.confirmed;
}
