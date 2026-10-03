import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/payment_method_model.dart';
import '../../domain/repositories/loan_payment_repository.dart';
import '../../data/repositories/loan_payment_repository_impl.dart';

class PaymentMethodsController
    extends AsyncNotifier<List<PaymentMethodModel>> {
  late final LoanPaymentRepository _repository;

  @override
  Future<List<PaymentMethodModel>> build() async {
    _repository = ref.watch(loanPaymentRepositoryProvider);
    return _repository.getPaymentMethods();
  }

  Future<void> refreshMethods() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.getPaymentMethods());
  }

  Future<bool> deleteMethod(int id) async {
    try {
      await _repository.deletePaymentMethod(id);
      await refreshMethods();
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final paymentMethodsControllerProvider = AsyncNotifierProvider<
    PaymentMethodsController, List<PaymentMethodModel>>(() {
  return PaymentMethodsController();
});
