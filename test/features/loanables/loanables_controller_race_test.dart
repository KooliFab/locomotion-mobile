import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/loanables/domain/entities/loanable.dart';
import 'package:mobile/features/loanables/domain/entities/loanables_page.dart';
import 'package:mobile/features/loanables/domain/repositories/loanables_repository.dart';
import 'package:mobile/features/loanables/presentation/controllers/loanables_controller.dart';

class _MockLoanablesRepo implements LoanablesRepository {
  final Future<LoanablesPage> Function({
    int? communityId,
    int? page,
    String? type,
  })
  onGetLoanables;

  _MockLoanablesRepo(this.onGetLoanables);

  @override
  Future<LoanablesPage> getLoanables({
    int? communityId,
    int? page,
    String? type,
  }) {
    return onGetLoanables(communityId: communityId, page: page, type: type);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('LoanablesListController race conditions in loadMore', () {
    test(
      'discards loadMore result when filter changes before response arrives',
      () async {
        final completer = Completer<LoanablesPage>();

        final repo = _MockLoanablesRepo(({communityId, page, type}) {
          if (page == 1) {
            if (type == 'bike') {
              return Future.value(
                const LoanablesPage(
                  items: [Loanable(id: 10, name: 'Bixi', type: 'bike')],
                  page: 1,
                  lastPage: 1,
                ),
              );
            }
            return Future.value(
              const LoanablesPage(
                items: [Loanable(id: 1, name: 'Prius', type: 'car')],
                page: 1,
                lastPage: 2,
              ),
            );
          } else {
            // page 2
            return completer.future;
          }
        });

        final container = ProviderContainer(
          overrides: [loanablesRepositoryProvider.overrideWithValue(repo)],
        );
        addTearDown(container.dispose);

        // Initial load with no filter
        final initial = await container.read(
          loanablesListControllerProvider.future,
        );
        expect(initial.items.map((e) => e.name), ['Prius']);
        expect(initial.hasMore, isTrue);

        // Start loadMore (captures type=null, page=2)
        final loadMoreFuture = container
            .read(loanablesListControllerProvider.notifier)
            .loadMore();

        // User changes type filter to 'bike' while loadMore is pending
        container
            .read(selectedLoanableTypeProvider.notifier)
            .selectType('bike');

        // Now complete the pending page 2 request with older 'car' items
        completer.complete(
          const LoanablesPage(
            items: [Loanable(id: 2, name: 'Corolla', type: 'car')],
            page: 2,
            lastPage: 2,
          ),
        );

        await loadMoreFuture;

        final updated = await container.read(
          loanablesListControllerProvider.future,
        );
        expect(updated.items.map((e) => e.name), ['Bixi']);
        expect(updated.items.any((e) => e.name == 'Corolla'), isFalse);
      },
    );
  });
}
