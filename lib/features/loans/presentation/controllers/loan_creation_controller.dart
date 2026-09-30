import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../loanables/presentation/controllers/loanables_controller.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/loan_creation_request.dart';
import '../../domain/entities/loan_draft.dart';
import '../../domain/entities/transport_alternative.dart';
import 'loan_creation_state.dart';
import 'loans_controller.dart';

part 'loan_creation_controller.g.dart';

@riverpod
class LoanCreationController extends _$LoanCreationController {
  @override
  LoanCreationState build(LoanDraft initialDraft) {
    return LoanCreationState(draft: initialDraft);
  }

  Map<String, String>? _clearFieldError(String fieldKey) {
    if (state.fieldErrors == null) return null;
    final map = Map<String, String>.from(state.fieldErrors!)..remove(fieldKey);
    return map.isEmpty ? null : map;
  }

  // --- Step 1: Schedule mutators ---
  void updateDepartureDate(String date) {
    state = state.copyWith(
      draft: state.draft.copyWith(departureDate: date),
      availabilityConflictMessage: null,
      generalError: null,
      fieldErrors: _clearFieldError('departure_at'),
    );
  }

  void updateDepartureTime(String time) {
    state = state.copyWith(
      draft: state.draft.copyWith(departureTime: time),
      availabilityConflictMessage: null,
      generalError: null,
      fieldErrors: _clearFieldError('departure_at'),
    );
  }

  void updateDuration(int minutes) {
    state = state.copyWith(
      draft: state.draft.copyWith(durationInMinutes: minutes),
      availabilityConflictMessage: null,
      generalError: null,
      fieldErrors: _clearFieldError('duration_in_minutes'),
    );
  }

  // --- Step 2: Trip details mutators ---
  void updateEstimatedDistance(int distance) {
    state = state.copyWith(
      draft: state.draft.copyWith(estimatedDistance: distance),
      generalError: null,
      fieldErrors: _clearFieldError('estimated_distance'),
    );
  }

  void updateAlternativeTo(TransportAlternative? alternative) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        alternativeTo: alternative,
        alternativeToOther: alternative == TransportAlternative.other
            ? state.draft.alternativeToOther
            : null,
      ),
      generalError: null,
      fieldErrors: _clearFieldError('alternative_to'),
    );
  }

  void updateAlternativeToOther(String? other) {
    state = state.copyWith(
      draft: state.draft.copyWith(alternativeToOther: other),
      generalError: null,
      fieldErrors: _clearFieldError('alternative_to_other'),
    );
  }

  void updateMessageForOwner(String? message) {
    state = state.copyWith(
      draft: state.draft.copyWith(messageForOwner: message),
      generalError: null,
      fieldErrors: _clearFieldError('message_for_owner'),
    );
  }

  // --- Navigation between steps ---
  Future<bool> goToTripDetailsStep() async {
    final validationError = state.draft.scheduleValidationError;
    if (validationError != null) {
      state = state.copyWith(generalError: validationError);
      return false;
    }

    // Check availability with backend
    state = state.copyWith(
      isCheckingAvailability: true,
      availabilityConflictMessage: null,
      generalError: null,
    );

    try {
      final available = await _checkAvailability();
      if (!available) {
        state = state.copyWith(
          isCheckingAvailability: false,
          availabilityConflictMessage:
              'Le véhicule n\'est pas disponible pour le créneau sélectionné.',
        );
        return false;
      }
      state = state.copyWith(
        isCheckingAvailability: false,
        currentStep: 1,
        availabilityConflictMessage: null,
        generalError: null,
      );
      return true;
    } catch (e) {
      final errorMsg = e is AppException
          ? e.message
          : 'Impossible de vérifier la disponibilité du créneau.';
      state = state.copyWith(
        isCheckingAvailability: false,
        generalError: errorMsg,
      );
      return false;
    }
  }

  void goToSummaryStep() {
    final validationError = state.draft.tripDetailsValidationError;
    if (validationError != null) {
      state = state.copyWith(generalError: validationError);
      return;
    }
    state = state.copyWith(
      currentStep: 2,
      generalError: null,
      fieldErrors: null,
    );
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 2) {
      state = state.copyWith(currentStep: step, generalError: null);
    }
  }

  /// Timezone-safe availability check comparing vehicle-local intervals
  Future<bool> _checkAvailability() async {
    final draft = state.draft;
    final depStr = draft.departureAtString;
    if (depStr == null || draft.durationInMinutes == null) return false;

    // Use departure date & time
    final depParts = depStr.split(' ');
    final date = depParts[0];
    final start = '$date 00:00:00';
    // Shift date by 2 days for window check
    final end = '${_shiftYmd(date, 2)} 00:00:00';

    final loanablesRepo = ref.read(loanablesRepositoryProvider);
    final intervals = await loanablesRepo.getAvailability(
      draft.loanableId,
      start: start,
      end: end,
      responseMode: 'unavailable',
    );

    // Calculate requested interval string bounds in format 'yyyy-MM-dd HH:mm:ss'
    // depStr is guaranteed to be 'yyyy-MM-dd HH:mm:ss'
    final reqDateParts = depParts[0].split('-');
    final reqTimeParts = depParts[1].split(':');
    final reqStartDt = DateTime.utc(
      int.parse(reqDateParts[0]),
      int.parse(reqDateParts[1]),
      int.parse(reqDateParts[2]),
      int.parse(reqTimeParts[0]),
      int.parse(reqTimeParts[1]),
    );
    final reqEndDt = reqStartDt.add(Duration(minutes: draft.durationInMinutes!));

    final reqStartStr = depStr;
    final reqEndStr =
        '${reqEndDt.year.toString().padLeft(4, '0')}-'
        '${reqEndDt.month.toString().padLeft(2, '0')}-'
        '${reqEndDt.day.toString().padLeft(2, '0')} '
        '${reqEndDt.hour.toString().padLeft(2, '0')}:'
        '${reqEndDt.minute.toString().padLeft(2, '0')}:'
        '${reqEndDt.second.toString().padLeft(2, '0')}';

    for (final interval in intervals) {
      if (!interval.isAvailable) {
        // Compare rawStart and rawEnd strings (vehicle-local wall-clock) directly.
        // Fallback to formatted start/end if rawStart/rawEnd are null.
        // Intersect check: intervalStart < reqEnd && intervalEnd > reqStart
        final intervalStartStr = interval.rawStart?.trim() ??
            '${interval.start.year.toString().padLeft(4, '0')}-'
            '${interval.start.month.toString().padLeft(2, '0')}-'
            '${interval.start.day.toString().padLeft(2, '0')} '
            '${interval.start.hour.toString().padLeft(2, '0')}:'
            '${interval.start.minute.toString().padLeft(2, '0')}:'
            '${interval.start.second.toString().padLeft(2, '0')}';

        final intervalEndStr = interval.rawEnd?.trim() ??
            '${interval.end.year.toString().padLeft(4, '0')}-'
            '${interval.end.month.toString().padLeft(2, '0')}-'
            '${interval.end.day.toString().padLeft(2, '0')} '
            '${interval.end.hour.toString().padLeft(2, '0')}:'
            '${interval.end.minute.toString().padLeft(2, '0')}:'
            '${interval.end.second.toString().padLeft(2, '0')}';

        if (intervalStartStr.compareTo(reqEndStr) < 0 &&
            intervalEndStr.compareTo(reqStartStr) > 0) {
          return false;
        }
      }
    }
    return true;
  }

  static String _shiftYmd(String ymd, int days) {
    final parts = ymd.split('-');
    if (parts.length != 3) return ymd;
    final base = DateTime.utc(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    final shifted = base.add(Duration(days: days));
    final y = shifted.year.toString().padLeft(4, '0');
    final m = shifted.month.toString().padLeft(2, '0');
    final d = shifted.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Final submit to POST /loans
  Future<Loan?> submitReservation() async {
    // Prevent re-entrant submissions
    if (state.isSubmitting || state.isCheckingAvailability) return null;

    final validationError = state.draft.fullValidationError;
    if (validationError != null) {
      state = state.copyWith(generalError: validationError);
      return null;
    }

    final user = ref.read(authControllerProvider).value;
    if (user == null) {
      state = state.copyWith(
        generalError: 'Vous devez être connecté pour réserver.',
      );
      return null;
    }

    state = state.copyWith(
      isSubmitting: true,
      generalError: null,
      availabilityConflictMessage: null,
    );

    // Étape 4 du découpage : Vérification de disponibilité juste avant le POST
    try {
      final isStillAvailable = await _checkAvailability();
      if (!isStillAvailable) {
        state = state.copyWith(
          isSubmitting: false,
          currentStep: 0,
          availabilityConflictMessage:
              'Le créneau sélectionné n\'est plus disponible. Veuillez choisir un autre horaire.',
        );
        return null;
      }
    } catch (_) {
      // If availability network check fails, proceed and let the backend 409 handle it
    }

    final draft = state.draft;
    final request = LoanCreationRequest(
      loanableId: draft.loanableId,
      borrowerUserId: user.id,
      departureAt: draft.departureAtString!,
      durationInMinutes: draft.durationInMinutes!,
      estimatedDistance: draft.estimatedDistance!,
      alternativeTo: draft.alternativeTo!.value,
      alternativeToOther: draft.alternativeToOther,
      messageForOwner:
          draft.messageForOwner != null &&
              draft.messageForOwner!.trim().isNotEmpty
          ? draft.messageForOwner!.trim()
          : null,
      communityId: draft.communityId,
    );

    try {
      final loansRepo = ref.read(loansRepositoryProvider);
      final createdLoan = await loansRepo.createLoan(request);

      // Invalidate relevant providers upon success using centralized invalidation
      invalidateLoanViews(
        ref,
        loanId: createdLoan.id,
        loanableId: draft.loanableId,
      );

      state = state.copyWith(isSubmitting: false, createdLoan: createdLoan);
      return createdLoan;
    } on ValidationException catch (e) {
      final fieldMap = <String, String>{};
      if (e.errors != null) {
        e.errors!.forEach((key, val) {
          if (val is List && val.isNotEmpty) {
            fieldMap[key] = val.first.toString();
          } else if (val is String) {
            fieldMap[key] = val;
          }
        });
      }

      // Revenir à l'étape du premier champ en erreur
      var targetStep = state.currentStep;
      if (fieldMap.containsKey('departure_at') ||
          fieldMap.containsKey('duration_in_minutes')) {
        targetStep = 0;
      } else if (fieldMap.containsKey('estimated_distance') ||
          fieldMap.containsKey('alternative_to') ||
          fieldMap.containsKey('alternative_to_other') ||
          fieldMap.containsKey('message_for_owner')) {
        targetStep = 1;
      }

      final isAvailabilityError = e.message.toLowerCase().contains('pas disponible') ||
          (fieldMap.containsKey('departure_at') &&
              fieldMap['departure_at']!.toLowerCase().contains('pas disponible'));

      state = state.copyWith(
        isSubmitting: false,
        currentStep: isAvailabilityError ? 0 : targetStep,
        availabilityConflictMessage: isAvailabilityError ? e.message : null,
        generalError: isAvailabilityError ? null : e.message,
        fieldErrors: fieldMap.isNotEmpty ? fieldMap : null,
      );
      return null;
    } on ConflictException catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        currentStep: 0,
        availabilityConflictMessage: e.message,
        generalError: null,
      );
      return null;
    } on ForbiddenException catch (e) {
      state = state.copyWith(isSubmitting: false, generalError: e.message);
      return null;
    } on UnauthorizedException catch (e) {
      state = state.copyWith(isSubmitting: false, generalError: e.message);
      return null;
    } catch (e) {
      final message = e is AppException
          ? e.message
          : 'Une erreur inattendue est survenue lors de la création de la réservation.';
      state = state.copyWith(isSubmitting: false, generalError: message);
      return null;
    }
  }
}
