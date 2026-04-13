/// Mixin that provides pagination state management for Cubits.
///
/// This mixin handles the common pagination logic including:
/// - Page tracking (`currentPage`, `hasMore`)
/// - Search query management
/// - List concatenation (with web JSArray compatibility)
/// - Loading state tracking
///
/// Usage:
/// ```dart
/// class ProductsCubit extends Cubit<ProductsState>
///     with PaginationMixin<ProductModel> {
///
///   Future<void> loadProducts() async {
///     resetPagination();
///     emit(ProductsLoading());
///     try {
///       final items = await _repository.fetch(paginationParams);
///       updatePaginationState(items);
///       emit(ProductsLoaded(items: allItems, hasMore: hasMore));
///     } catch (e) {
///       emit(ProductsError(e.toString()));
///     }
///   }
///
///   Future<void> loadMore() async {
///     if (!canLoadMore) return;
///     emit(ProductsLoadingMore());
///     incrementPage();
///     try {
///       final newItems = await _repository.fetch(paginationParams);
///       appendItems(newItems);
///       emit(ProductsLoaded(items: allItems, hasMore: hasMore));
///     } catch (e) {
///       revertPage();
///       emit(ProductsError(e.toString()));
///     }
///   }
/// }
/// ```
mixin PaginationMixin<T> {
  // Internal state
  int _currentPage = 1;
  bool _hasMore = true;
  List<T> _items = [];
  String _searchQuery = '';
  bool _isLoadingMore = false;

  /// Override to customize page size. Default is 20.
  int get pageSize => 20;

  /// Current page number (1-indexed).
  int get currentPage => _currentPage;

  /// Whether there are more items to load.
  bool get hasMore => _hasMore;

  /// All loaded items as an unmodifiable list.
  List<T> get allItems => List.unmodifiable(_items);

  /// Current search query.
  String get searchQuery => _searchQuery;

  /// Whether a load more operation is in progress.
  bool get isLoadingMore => _isLoadingMore;

  /// Whether more items can be loaded (has more and not currently loading).
  bool get canLoadMore => _hasMore && !_isLoadingMore;

  /// Pagination parameters for API calls.
  /// Includes `page`, `limit`, and optionally `search`.
  Map<String, dynamic> get paginationParams => {
    'page': _currentPage,
    'limit': pageSize,
    if (_searchQuery.isNotEmpty) 'search': _searchQuery,
  };

  /// Builds pagination params merged with additional parameters.
  Map<String, dynamic> buildPaginationParams([
    Map<String, dynamic>? additionalParams,
  ]) {
    return {...?additionalParams, ...paginationParams};
  }

  /// Resets pagination state for a new fetch.
  /// Call this at the beginning of initial load or search.
  void resetPagination() {
    _currentPage = 1;
    _hasMore = true;
    _items = [];
    _isLoadingMore = false;
  }

  /// Updates pagination state after a successful fetch.
  /// Sets `hasMore` based on whether the result count equals pageSize.
  void updatePaginationState(List<T> newItems) {
    _hasMore = newItems.length >= pageSize;
    _items = newItems;
  }

  /// Sets the search query. Call `resetPagination()` and reload after this.
  void setSearchQuery(String query) {
    _searchQuery = query.trim();
  }

  /// Increments the page counter and marks loading state.
  /// Call this before fetching the next page.
  void incrementPage() {
    _currentPage++;
    _isLoadingMore = true;
  }

  /// Reverts the page counter on error.
  /// Call this if the load more request fails.
  void revertPage() {
    _currentPage--;
    _isLoadingMore = false;
  }

  /// Appends new items to the existing list.
  /// Handles web JSArray casting issue automatically.
  void appendItems(List<T> newItems) {
    _hasMore = newItems.length >= pageSize;
    // Use toList() + addAll to avoid web JSArray cast issues
    final combined = _items.toList()..addAll(newItems);
    final dynamic dynamicList = combined;
    _items = dynamicList as List<T>;
    _isLoadingMore = false;
  }

  /// Marks load more operation as complete.
  /// Call this after successful or failed load more.
  void finishLoadMore() {
    _isLoadingMore = false;
  }

  /// Clears all loaded items without resetting pagination state.
  void clearItems() {
    _items = [];
  }
}
