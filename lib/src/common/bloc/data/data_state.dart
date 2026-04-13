part of 'data_bloc.dart';

/// Represents the type of operation being performed.
enum DataOperation {
  fetch,
  refresh,
  submit,
  getById,
  create,
  update,
  delete,
  loadMore,
}

/// Generic state for data operations.
/// [T] is the data type being managed.
sealed class DataState<T> extends Equatable {
  const DataState({this.data, this.operation});

  /// The current data. Can be any type: a model, a list, etc.
  final T? data;

  /// The operation that triggered the current state (useful for UI decisions).
  final DataOperation? operation;

  @override
  List<Object?> get props => [data, operation];
}

/// Initial state before any operation.
final class DataInitialState<T> extends DataState<T> {
  const DataInitialState() : super();
}

/// Loading state while an operation is in progress.
/// Preserves [data] to allow showing previous data during loading.
final class DataLoadingState<T> extends DataState<T> {
  const DataLoadingState({required DataOperation operation, super.data})
    : super(operation: operation);
}

final class DataLoadingRefreshState<T> extends DataState<T> {
  const DataLoadingRefreshState({required DataOperation operation, super.data})
    : super(operation: operation);
}

/// Loading more state while fetching additional data for pagination.
/// Preserves [data] to allow showing current data while loading more.
final class DataLoadingMoreState<T> extends DataState<T> {
  const DataLoadingMoreState({required super.data})
    : super(operation: DataOperation.loadMore);
}

/// Success state when an operation completes successfully.
final class DataSuccessState<T> extends DataState<T> {
  const DataSuccessState({
    required super.data,
    required DataOperation operation,
    this.hasMore = true,
    this.currentPage = 1,
  }) : super(operation: operation);

  /// Indicates if there are more items to load.
  final bool hasMore;

  /// Current page number for pagination.
  final int currentPage;

  @override
  List<Object?> get props => [data, operation, hasMore, currentPage];
}

/// Error state when an operation fails.
/// Preserves [data] to allow showing previous data alongside error.
final class DataErrorState<T> extends DataState<T> {
  const DataErrorState({
    required this.message,
    required DataOperation operation,
    super.data,
    this.exceptionType,
  }) : super(operation: operation);

  final String message;
  final ExceptionType? exceptionType;

  @override
  List<Object?> get props => [data, operation, message, exceptionType];
}
