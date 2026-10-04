class ConflictingLoan {
  final int id;
  final String borrowerName;
  final DateTime departureAt;
  final DateTime actualReturnAt;
  final String status;

  const ConflictingLoan({
    required this.id,
    required this.borrowerName,
    required this.departureAt,
    required this.actualReturnAt,
    required this.status,
  });

  factory ConflictingLoan.fromJson(Map<String, dynamic> json) {
    String? name;
    if (json['borrower_user'] is Map) {
      name = (json['borrower_user'] as Map<String, dynamic>)['name'] as String?;
    } else if (json['borrower_name'] != null) {
      name = json['borrower_name'] as String?;
    }

    return ConflictingLoan(
      id: json['id'] as int,
      borrowerName: name ?? 'Emprunteur',
      departureAt: DateTime.parse(json['departure_at'] as String),
      actualReturnAt: DateTime.parse(
        (json['actual_return_at'] ?? json['return_at'] ?? json['departure_at']) as String,
      ),
      status: json['status']?.toString() ?? 'accepted',
    );
  }
}
