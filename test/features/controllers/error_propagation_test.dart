import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/loanables/domain/entities/loanable.dart';
import 'package:mobile/features/loanables/domain/entities/loanable_availability.dart';
import 'package:mobile/features/loanables/domain/entities/loanables_page.dart';
import 'package:mobile/features/loanables/domain/repositories/loanables_repository.dart';
import 'package:mobile/features/loanables/presentation/controllers/loanables_controller.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/loan_comment.dart';
import 'package:mobile/features/loans/domain/entities/loan_creation_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_dates_update_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_pagination.dart';
import 'package:mobile/features/loans/domain/entities/loans_dashboard.dart';
import 'package:mobile/features/loans/domain/repositories/loans_repository.dart';
import 'package:mobile/features/loans/presentation/controllers/loans_controller.dart';

class FailingLoanablesRepository implements LoanablesRepository {
  @override
  Future<LoanablesPage> getLoanables({
    String? type,
    int? communityId,
    int? page,
  }) async {
    throw const ServerException(
      message: 'Erreur réseau simulée',
      statusCode: 500,
    );
  }

  @override
  Future<Loanable> getLoanableDetails(int id) async {
    throw const ServerException(
      message: 'Erreur réseau simulée',
      statusCode: 500,
    );
  }

  @override
  Future<List<LoanableAvailabilityInterval>> getAvailability(
    int loanableId, {
    required String start,
    required String end,
    String responseMode = 'available',
  }) async {
    throw const ServerException(
      message: 'Erreur réseau simulée',
      statusCode: 500,
    );
  }
}

class FailingLoansRepository implements LoansRepository {
  @override
  Future<LoansDashboard> getDashboard() async {
    throw const ServerException(message: 'Erreur dashboard', statusCode: 500);
  }

  @override
  Future<Loan> createLoan(LoanCreationRequest request) async {
    throw const ServerException(message: 'Erreur create', statusCode: 500);
  }

  @override
  Future<List<Loan>> getMyLoans() async {
    throw const ServerException(message: 'Erreur my loans', statusCode: 500);
  }

  @override
  Future<Loan> getLoanDetail(int id) async {
    throw const ServerException(message: 'Erreur loan detail', statusCode: 500);
  }

  @override
  Future<LoanPagination> getLoansPage({
    int page = 1,
    int perPage = 10,
    String? status,
    int? borrowerUserId,
  }) async {
    throw const ServerException(message: 'Erreur loans page', statusCode: 500);
  }

  @override
  Future<Loan> cancelLoan(int id) async {
    throw const ServerException(message: 'Erreur cancel loan', statusCode: 500);
  }

  @override
  Future<Loan> acceptLoan(int id, {String? comment}) async {
    throw const ServerException(message: 'Erreur accept loan', statusCode: 500);
  }

  @override
  Future<Loan> rejectLoan(int id, {String? comment}) async {
    throw const ServerException(message: 'Erreur reject loan', statusCode: 500);
  }

  @override
  Future<Loan> validateLoan(int id) async {
    throw const ServerException(message: 'Erreur validate loan', statusCode: 500);
  }

  @override
  Future<Loan> updateLoanDates(int id, LoanDatesUpdateRequest request) async {
    throw const ServerException(
      message: 'Erreur update dates',
      statusCode: 500,
    );
  }

  @override
  Future<LoanComment> addComment(int id, String text) async {
    throw const ServerException(message: 'Erreur add comment', statusCode: 500);
  }
}

void main() {
  test(
    'LoanablesListController propagates error and does not return preview data',
    () async {
      final container = ProviderContainer(
        overrides: [
          loanablesRepositoryProvider.overrideWithValue(
            FailingLoanablesRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Initial read starts loading
      container.read(loanablesListControllerProvider);

      // Allow async build to complete
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final state = container.read(loanablesListControllerProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<ServerException>());
      expect((state.error as ServerException).message, 'Erreur réseau simulée');
    },
  );

  test(
    'LoansDashboardController propagates error without returning empty category fallback',
    () async {
      final container = ProviderContainer(
        overrides: [
          loansRepositoryProvider.overrideWithValue(FailingLoansRepository()),
        ],
      );
      addTearDown(container.dispose);

      container.read(loansDashboardControllerProvider);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final state = container.read(loansDashboardControllerProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<ServerException>());
      expect((state.error as ServerException).message, 'Erreur dashboard');
    },
  );

  test(
    'MyLoansController propagates error without swallowing into empty list',
    () async {
      final container = ProviderContainer(
        overrides: [
          loansRepositoryProvider.overrideWithValue(FailingLoansRepository()),
        ],
      );
      addTearDown(container.dispose);

      container.read(myLoansControllerProvider);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final state = container.read(myLoansControllerProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<ServerException>());
      expect((state.error as ServerException).message, 'Erreur my loans');
    },
  );
}
