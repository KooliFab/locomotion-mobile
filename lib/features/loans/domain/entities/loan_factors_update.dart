/// Payload of `PUT /loans/{id}/factors`, identical to the web factors box:
/// every field is sent, `null` clearing the value on the server.
class LoanFactorsUpdate {
  final int? mileageStart;
  final int? mileageStartImageId;
  final int? mileageEnd;
  final int? mileageEndImageId;
  final double? expensesAmount;
  final int? expenseImageId;
  final bool includeExpenses;

  const LoanFactorsUpdate({
    this.mileageStart,
    this.mileageStartImageId,
    this.mileageEnd,
    this.mileageEndImageId,
    this.expensesAmount,
    this.expenseImageId,
    this.includeExpenses = false,
  });

  Map<String, dynamic> toJson() => {
    'mileage_start': mileageStart,
    'mileage_start_image_id': mileageStartImageId,
    'mileage_end': mileageEnd,
    'mileage_end_image_id': mileageEndImageId,
    if (includeExpenses) ...{
      'expenses_amount': expensesAmount,
      'expense_image_id': expenseImageId,
    },
  };
}
