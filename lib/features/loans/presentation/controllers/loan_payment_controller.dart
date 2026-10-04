import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/stripe_payment_service.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/loan_status.dart';
import '../../domain/entities/payment_intent_response.dart';
import '../../domain/repositories/loan_payment_repository.dart';
import '../../domain/repositories/loans_repository.dart';
import '../../data/repositories/loan_payment_repository_impl.dart';
import 'loans_controller.dart';

sealed class LoanPaymentState {
  const LoanPaymentState();
}

class LoanPaymentInitial extends LoanPaymentState {
  const LoanPaymentInitial();
}

class LoanPaymentLoadingBreakdown extends LoanPaymentState {
  const LoanPaymentLoadingBreakdown();
}

class LoanPaymentBreakdownReady extends LoanPaymentState {
  final PaymentIntentResponse intentResponse;
  const LoanPaymentBreakdownReady(this.intentResponse);
}

class LoanPaymentProcessing extends LoanPaymentState {
  final String message;
  const LoanPaymentProcessing({this.message = 'Traitement en cours...'});
}

class LoanPaymentSuccess extends LoanPaymentState {
  final Loan loan;
  const LoanPaymentSuccess(this.loan);
}

class LoanPaymentCanceled extends LoanPaymentState {
  const LoanPaymentCanceled();
}

class LoanPaymentError extends LoanPaymentState {
  final String message;
  const LoanPaymentError(this.message);
}

class LoanPaymentController extends Notifier<LoanPaymentState> {
  late final LoanPaymentRepository _repository;
  late final LoansRepository _loansRepository;
  late final StripePaymentService _stripeService;

  final Map<int, String> _paidContributionIntentIds = {};

  @override
  LoanPaymentState build() {
    _repository = ref.watch(loanPaymentRepositoryProvider);
    _loansRepository = ref.watch(loansRepositoryProvider);
    _stripeService = ref.watch(stripePaymentServiceProvider);
    return const LoanPaymentInitial();
  }

  Future<PaymentIntentResponse?> fetchBreakdown(
    int loanId, {
    int? platformTipCents,
    bool useBalance = true,
  }) async {
    state = const LoanPaymentLoadingBreakdown();
    try {
      final response = await _repository.createPaymentIntent(
        loanId: loanId,
        platformTipCents: platformTipCents,
        useBalance: useBalance,
      );
      state = LoanPaymentBreakdownReady(response);
      return response;
    } catch (e) {
      state = LoanPaymentError(
        'Erreur lors du calcul financier : ${e.toString()}',
      );
      return null;
    }
  }

  /// Relit l'état de l'emprunt auprès du serveur pour déterminer
  /// s'il est déjà confirmé (ex: suite à un timeout réseau après validation Stripe).
  Future<bool> checkServerStatus(int loanId) async {
    try {
      final refreshedLoan = await _loansRepository.getLoanDetail(loanId);
      if (refreshedLoan.prepaidAt != null ||
          refreshedLoan.parsedStatus == LoanStatus.confirmed ||
          refreshedLoan.parsedStatus == LoanStatus.ongoing) {
        invalidateLoanViews(ref, loanId: loanId);
        state = LoanPaymentSuccess(refreshedLoan);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> confirmPayment({
    required int loanId,
    required PaymentIntentResponse intentResponse,
    int? platformTipCents,
  }) async {
    // Aligner de manière déterministe sur le pourboire calculé dans le breakdown
    final effectiveTipCents =
        intentResponse.financialBreakdown.platformTipCents;

    // Cas 1 : Aucun flux Stripe requis (solde 100% suffisant et aucune caution)
    if (!intentResponse.requiresStripeAction) {
      state = const LoanPaymentProcessing(
        message: 'Confirmation immédiate avec votre solde...',
      );
      try {
        final confirmedLoan = await _repository.prepay(
          loanId: loanId,
          platformTipCents: effectiveTipCents,
        );
        invalidateLoanViews(ref, loanId: loanId);
        state = LoanPaymentSuccess(confirmedLoan);
        return true;
      } catch (e) {
        final recovered = await checkServerStatus(loanId);
        if (recovered) return true;

        state = LoanPaymentError(
          'Erreur lors de la confirmation : ${e.toString()}',
        );
        return false;
      }
    }

    // Cas 2 : Flux Stripe (contribution et/ou caution)
    final stripeData = intentResponse.stripe;
    if (stripeData == null) {
      state = const LoanPaymentError('Données de session Stripe absentes.');
      return false;
    }

    final contributionSecret =
        stripeData.contributionPaymentIntentClientSecret;
    final depositSecret = stripeData.depositPaymentIntentClientSecret;

    final hasContribution =
        contributionSecret != null && contributionSecret.isNotEmpty;
    final hasDeposit = depositSecret != null && depositSecret.isNotEmpty;

    if (!hasContribution && !hasDeposit) {
      state = const LoanPaymentError(
        'Secret de paiement Stripe manquant pour initialiser la transaction.',
      );
      return false;
    }

    // Étape 1 : Présentation de la feuille de paiement pour la contribution si pas déjà payée
    final alreadyPaidContributionId = _paidContributionIntentIds[loanId];
    final bool shouldChargeContribution =
        hasContribution && alreadyPaidContributionId == null;

    if (shouldChargeContribution) {
      state = const LoanPaymentProcessing(
        message: 'Règlement de la contribution...',
      );

      try {
        await _stripeService.initPaymentSheet(
          paymentIntentClientSecret: contributionSecret,
          customerId: stripeData.customerId,
          customerEphemeralKeySecret: stripeData.ephemeralKeySecret,
        );

        final sheetResponse = await _stripeService.presentPaymentSheet();

        if (sheetResponse.isCanceled) {
          state = const LoanPaymentCanceled();
          return false;
        }

        if (sheetResponse.isFailed) {
          state = LoanPaymentError(
            sheetResponse.errorMessage ??
                'Le paiement de la contribution a été refusé.',
          );
          return false;
        }

        final extractedId = _extractPaymentIntentId(contributionSecret);
        if (extractedId != null) {
          _paidContributionIntentIds[loanId] = extractedId;
        }
      } catch (e) {
        state = LoanPaymentError('Erreur Stripe : ${e.toString()}');
        return false;
      }
    }

    // Étape 2 : Présentation de la feuille de caution si requise
    if (hasDeposit) {
      state = const LoanPaymentProcessing(
        message: 'Autorisation de l\'empreinte de caution (250 \$)...',
      );

      try {
        await _stripeService.initPaymentSheet(
          paymentIntentClientSecret: depositSecret,
          customerId: stripeData.customerId,
          customerEphemeralKeySecret: stripeData.ephemeralKeySecret,
        );

        final sheetResponse = await _stripeService.presentPaymentSheet();

        if (sheetResponse.isCanceled) {
          state = const LoanPaymentCanceled();
          return false;
        }

        if (sheetResponse.isFailed) {
          state = LoanPaymentError(
            sheetResponse.errorMessage ??
                'L\'autorisation de la caution a été refusée.',
          );
          return false;
        }
      } catch (e) {
        state = LoanPaymentError('Erreur Stripe : ${e.toString()}');
        return false;
      }
    }

    // Étape 3 : Finalisation auprès de l'API avec les identifiants dûment confirmés
    state = const LoanPaymentProcessing(
      message: 'Validation du prépaiement et de la caution...',
    );

    final contributionId = alreadyPaidContributionId ??
        (hasContribution ? _extractPaymentIntentId(contributionSecret) : null);
    final depositId = hasDeposit
        ? _extractPaymentIntentId(depositSecret)
        : null;

    try {
      final confirmedLoan = await _repository.prepay(
        loanId: loanId,
        platformTipCents: effectiveTipCents,
        contributionPaymentIntentId: contributionId,
        depositPaymentIntentId: depositId,
      );

      _paidContributionIntentIds.remove(loanId);
      invalidateLoanViews(ref, loanId: loanId);
      state = LoanPaymentSuccess(confirmedLoan);
      return true;
    } catch (e) {
      // Tolérance aux pannes : en cas d'erreur de communication ou timeout,
      // on relit l'emprunt pour vérifier si le serveur l'a déjà confirmé
      final recovered = await checkServerStatus(loanId);
      if (recovered) return true;

      try {
        invalidateLoanViews(ref, loanId: loanId);
      } catch (_) {}

      state = LoanPaymentError(
        'Une erreur est survenue lors de la confirmation : ${e.toString()}',
      );
      return false;
    }
  }

  void reset() {
    state = const LoanPaymentInitial();
  }

  String? _extractPaymentIntentId(String? clientSecret) {
    if (clientSecret == null || clientSecret.isEmpty) return null;
    final parts = clientSecret.split('_secret_');
    return parts.first;
  }
}

final loanPaymentControllerProvider =
    NotifierProvider<LoanPaymentController, LoanPaymentState>(() {
  return LoanPaymentController();
});
