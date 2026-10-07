import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/loans/data/repositories/loan_payment_repository_impl.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/invoice_summary.dart';
import 'package:mobile/features/loans/domain/entities/payment_method_model.dart';
import 'package:mobile/features/loans/domain/repositories/loan_payment_repository.dart';
import 'package:mobile/features/profile/presentation/screens/payment_methods_screen.dart';

class StubCardsRepository implements LoanPaymentRepository {
  List<PaymentMethodModel> methods = [
    const PaymentMethodModel(
      id: 1,
      creditCardType: 'Visa',
      fourLastDigits: '4242',
      isDefault: true,
    ),
    const PaymentMethodModel(
      id: 2,
      creditCardType: 'Mastercard',
      fourLastDigits: '5555',
      isDefault: false,
    ),
  ];

  bool deleteCalled = false;

  @override
  Future<InvoiceSummary?> estimateBorrowerInvoice({
    required int loanId,
    required double platformTip,
  }) => throw UnimplementedError();

  @override
  Future<double> addToBalance({required double amount, int? paymentMethodId}) =>
      throw UnimplementedError();

  @override
  Future<Loan> prepay({required int loanId, required double platformTip}) =>
      throw UnimplementedError();

  @override
  Future<Loan> pay({required int loanId, required double platformTip}) =>
      throw UnimplementedError();

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async => methods;

  @override
  Future<void> deletePaymentMethod(int id) async {
    deleteCalled = true;
    methods.removeWhere((m) => m.id == id);
  }
}

void main() {
  testWidgets(
    'PaymentMethodsScreen renders cards and deletes after confirmation',
    (tester) async {
      final stubRepo = StubCardsRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loanPaymentRepositoryProvider.overrideWithValue(stubRepo),
          ],
          child: const MaterialApp(home: PaymentMethodsScreen()),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      // Verify title and security banner
      expect(find.text('Moyens de paiement'), findsOneWidget);
      expect(
        find.textContaining('Vos coordonnées bancaires sont chiffrées'),
        findsOneWidget,
      );

      // Verify cards listed
      expect(find.text('Visa'), findsOneWidget);
      expect(find.text('•••• •••• •••• 4242'), findsOneWidget);
      expect(find.text('Par défaut'), findsOneWidget);

      expect(find.text('Mastercard'), findsOneWidget);
      expect(find.text('•••• •••• •••• 5555'), findsOneWidget);

      // Tap delete on the first card
      final deleteButtons = find.byIcon(Icons.delete_outline);
      expect(deleteButtons, findsNWidgets(2));
      await tester.tap(deleteButtons.first);
      await tester.pumpAndSettle();

      // Verify confirmation dialog
      expect(find.text('Supprimer cette carte ?'), findsOneWidget);

      // Tap Supprimer
      await tester.tap(find.text('Supprimer'));
      await tester.pumpAndSettle();

      expect(stubRepo.deleteCalled, isTrue);
    },
  );
}
