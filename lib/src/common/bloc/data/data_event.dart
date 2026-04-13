part of 'data_bloc.dart';

/// Base event for data operations.
sealed class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object?> get props => [];
}

/// Fetches data from the repository.
/// Use for initial data loading.
class DataFetchEvent extends DataEvent {
  const DataFetchEvent({this.params});

  final Map<String, dynamic>? params;

  @override
  List<Object?> get props => [params];
}

/// Refreshes data from the repository.
/// Use for pull-to-refresh or manual refresh actions.
class DataRefreshEvent extends DataEvent {
  const DataRefreshEvent({this.params});

  final Map<String, dynamic>? params;

  @override
  List<Object?> get props => [params];
}

/// Submits data to the repository.
/// Use for forms, sending data to server, etc.
class DataSubmitEvent extends DataEvent {
  const DataSubmitEvent({required this.data, this.params});

  final Map<String, dynamic> data;
  final Map<String, dynamic>? params;

  @override
  List<Object?> get props => [data, params];
}

/// Gets a single item by ID.
class DataGetByIdEvent extends DataEvent {
  const DataGetByIdEvent(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Creates a new item.
class DataCreateEvent extends DataEvent {
  const DataCreateEvent(this.data);

  final Map<String, dynamic> data;

  @override
  List<Object?> get props => [data];
}

/// Updates an existing item.
class DataUpdateEvent extends DataEvent {
  const DataUpdateEvent({required this.id, required this.data});

  final String id;
  final Map<String, dynamic> data;

  @override
  List<Object?> get props => [id, data];
}

/// Deletes an item by ID.
class DataDeleteEvent extends DataEvent {
  const DataDeleteEvent(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Resets the bloc to initial state.
class DataResetEvent extends DataEvent {
  const DataResetEvent();
}

/// Loads more data for pagination.
/// Use for infinite scroll / load more functionality.
class DataLoadMoreEvent extends DataEvent {
  const DataLoadMoreEvent({this.params});

  final Map<String, dynamic>? params;

  @override
  List<Object?> get props => [params];
}
