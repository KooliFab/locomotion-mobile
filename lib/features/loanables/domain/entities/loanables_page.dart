import 'loanable.dart';

/// One page of `GET /loanables` (`ListLoanableResource` paginated envelope).
///
/// The list endpoint never contains detail-only fields (images, instructions,
/// min/max durations…). Always fetch `GET /loanables/{id}` for the detail.
class LoanablesPage {
  /// Typed items for this page (already parsed from the list envelope).
  final List<Loanable> items;

  final int page;
  final int? lastPage;
  final int? total;
  final bool isLoadingMore;
  final String? loadMoreError;

  const LoanablesPage({
    required this.items,
    required this.page,
    this.lastPage,
    this.total,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  /// Without Laravel `meta`, we cannot know if more pages exist: stop.
  bool get hasMore {
    final last = lastPage;
    return last != null && page < last;
  }

  LoanablesPage copyWith({
    List<Loanable>? items,
    int? page,
    int? lastPage,
    int? total,
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) {
    return LoanablesPage(
      items: items ?? this.items,
      page: page ?? this.page,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: clearLoadMoreError
          ? null
          : (loadMoreError ?? this.loadMoreError),
    );
  }
}
