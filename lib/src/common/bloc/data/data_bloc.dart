import 'package:bloc/bloc.dart';
import 'package:dashboard/src/common/repositories/data_repository.dart';
import 'package:dashboard/src/core/api/api_exception.dart';
import 'package:dashboard/src/core/utils/api_response_mixin.dart';
import 'package:equatable/equatable.dart';

part 'data_event.dart';
part 'data_state.dart';

/// Generic BLoC for data operations.
///
/// [T] is the data type returned by the repository.
///
/// Usage example:
/// ```dart
/// // For a simple fetch operation returning UserModel
/// final userBloc = DataBloc<UserModel>(repository: myUserRepository);
/// userBloc.add(const DataFetchEvent());
///
/// // For a list of items
/// final listBloc = DataBloc<List<ItemModel>>(repository: myListRepository);
/// listBloc.add(const DataFetchEvent(params: {'page': 1}));
///
/// // For form submission
/// bloc.add(DataSubmitEvent(data: {'name': 'John', 'email': 'john@mail.com'}));
/// ```
class DataBloc<T> extends Bloc<DataEvent, DataState<T>>
    with ApiResponseErrorMixin {
  DataBloc({required this.repository, this.pageSize = 20})
    : super(const DataInitialState()) {
    on<DataFetchEvent>(_onFetch);
    on<DataRefreshEvent>(_onRefresh);
    on<DataSubmitEvent>(_onSubmit);
    on<DataResetEvent>(_onReset);
    on<DataLoadMoreEvent>(_onLoadMore);
  }

  final DataRepository<T> repository;
  final int pageSize;
  int _currentPage = 1;
  bool _hasMore = true;
  Map<String, dynamic>? _lastParams;

  Future<void> _onFetch(
    DataFetchEvent event,
    Emitter<DataState<T>> emit,
  ) async {
    // Reset pagination on new fetch
    _currentPage = 1;
    _hasMore = true;
    _lastParams = event.params;

    emit(DataLoadingState<T>(operation: DataOperation.fetch, data: state.data));
    try {
      final params = Map<String, dynamic>.from(event.params ?? {})
        ..addAll({'page': _currentPage, 'limit': pageSize});
      final data = await repository.fetch(params);

      // Check if there are more items
      if (data is List) {
        _hasMore = data.length >= pageSize;
      }

      emit(
        DataSuccessState<T>(
          data: data,
          operation: DataOperation.fetch,
          hasMore: _hasMore,
          currentPage: _currentPage,
        ),
      );
    } on Object catch (e) {
      emit(
        DataErrorState<T>(
          message: e.toString(),
          operation: DataOperation.fetch,
          data: state.data,
          exceptionType: extractExceptionType(e),
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    DataLoadMoreEvent event,
    Emitter<DataState<T>> emit,
  ) async {
    // Don't load more if already loading or no more items
    if (state is DataLoadingMoreState<T> || !_hasMore) return;

    final currentData = state.data;
    if (currentData is! List) return;

    emit(DataLoadingMoreState<T>(data: currentData as T));

    try {
      _currentPage++;
      final params = Map<String, dynamic>.from(_lastParams ?? {})
        ..addAll(event.params ?? {})
        ..addAll({'page': _currentPage, 'limit': pageSize});
      final newData = await repository.fetch(params);

      if (newData is List) {
        _hasMore = newData.length >= pageSize;
        // Combine lists - cast to dynamic first for web JSArray compatibility
        final combinedList = (currentData as List).toList()..addAll(newData);
        final dynamic dynamicList = combinedList;
        emit(
          DataSuccessState<T>(
            data: dynamicList as T,
            operation: DataOperation.loadMore,
            hasMore: _hasMore,
            currentPage: _currentPage,
          ),
        );
      }
    } on Object catch (e) {
      _currentPage--; // Revert page increment on error
      emit(
        DataErrorState<T>(
          message: e.toString(),
          operation: DataOperation.loadMore,
          data: currentData as T,
          exceptionType: extractExceptionType(e),
        ),
      );
    }
  }

  Future<void> _onRefresh(
    DataRefreshEvent event,
    Emitter<DataState<T>> emit,
  ) async {
    _currentPage = 1;
    _hasMore = true;
    _lastParams = event.params;

    emit(
      DataLoadingRefreshState<T>(
        operation: DataOperation.refresh,
        data: state.data,
      ),
    );
    try {
      final data = await repository.refresh(event.params);

      if (data is List) {
        _hasMore = data.length >= pageSize;
      }

      emit(
        DataSuccessState<T>(
          data: data,
          operation: DataOperation.refresh,
          hasMore: _hasMore,
          currentPage: _currentPage,
        ),
      );
    } on Object catch (e) {
      emit(
        DataErrorState<T>(
          message: e.toString(),
          operation: DataOperation.refresh,
          data: state.data,
          exceptionType: extractExceptionType(e),
        ),
      );
    }
  }

  Future<void> _onSubmit(
    DataSubmitEvent event,
    Emitter<DataState<T>> emit,
  ) async {
    emit(
      DataLoadingState<T>(operation: DataOperation.submit, data: state.data),
    );
    try {
      final data = await repository.submit(event.data, event.params);
      emit(DataSuccessState<T>(data: data, operation: DataOperation.submit));
    } on Object catch (e) {
      emit(
        DataErrorState<T>(
          message: e.toString(),
          operation: DataOperation.submit,
          data: state.data,
          exceptionType: extractExceptionType(e),
        ),
      );
    }
  }

  void _onReset(DataResetEvent event, Emitter<DataState<T>> emit) {
    emit(const DataInitialState());
  }
}

/// Extended BLoC with full CRUD operations (create, read, update, delete).
///
/// Use this when you need getById, create, update, and delete operations.
///
/// Usage example:
/// ```dart
/// final bloc = DataResourceBloc<UserModel>(repository: myExtendedRepo);
/// bloc.add(const DataGetByIdEvent('user-123'));
/// bloc.add(DataCreateEvent({'name': 'John'}));
/// bloc.add(DataUpdateEvent(id: 'user-123', data: {'name': 'Jane'}));
/// bloc.add(const DataDeleteEvent('user-123'));
/// ```
class DataResourceBloc<T> extends DataBloc<T> {
  DataResourceBloc({required DataResourceRepository<T> repository})
    : _resourceRepository = repository,
      super(repository: repository) {
    on<DataGetByIdEvent>(_onGetById);
    on<DataCreateEvent>(_onCreate);
    on<DataUpdateEvent>(_onUpdate);
    on<DataDeleteEvent>(_onDelete);
  }

  final DataResourceRepository<T> _resourceRepository;

  Future<void> _onGetById(
    DataGetByIdEvent event,
    Emitter<DataState<T>> emit,
  ) async {
    emit(
      DataLoadingState<T>(operation: DataOperation.getById, data: state.data),
    );
    try {
      final data = await _resourceRepository.getById(event.id);
      emit(DataSuccessState<T>(data: data, operation: DataOperation.getById));
    } on Object catch (e) {
      emit(
        DataErrorState<T>(
          message: e.toString(),
          operation: DataOperation.getById,
          data: state.data,
          exceptionType: extractExceptionType(e),
        ),
      );
    }
  }

  Future<void> _onCreate(
    DataCreateEvent event,
    Emitter<DataState<T>> emit,
  ) async {
    emit(
      DataLoadingState<T>(operation: DataOperation.create, data: state.data),
    );
    try {
      final data = await _resourceRepository.create(event.data);
      emit(DataSuccessState<T>(data: data, operation: DataOperation.create));
    } on Object catch (e) {
      emit(
        DataErrorState<T>(
          message: e.toString(),
          operation: DataOperation.create,
          data: state.data,
          exceptionType: extractExceptionType(e),
        ),
      );
    }
  }

  Future<void> _onUpdate(
    DataUpdateEvent event,
    Emitter<DataState<T>> emit,
  ) async {
    emit(
      DataLoadingState<T>(operation: DataOperation.update, data: state.data),
    );
    try {
      final data = await _resourceRepository.update(event.id, event.data);
      emit(DataSuccessState<T>(data: data, operation: DataOperation.update));
    } on Object catch (e) {
      emit(
        DataErrorState<T>(
          message: e.toString(),
          operation: DataOperation.update,
          data: state.data,
          exceptionType: extractExceptionType(e),
        ),
      );
    }
  }

  Future<void> _onDelete(
    DataDeleteEvent event,
    Emitter<DataState<T>> emit,
  ) async {
    emit(
      DataLoadingState<T>(operation: DataOperation.delete, data: state.data),
    );
    try {
      await _resourceRepository.delete(event.id);
      // After delete, we emit success but data becomes null since item was
      // deleted
      emit(const DataSuccessState(data: null, operation: DataOperation.delete));
    } on Object catch (e) {
      emit(
        DataErrorState<T>(
          message: e.toString(),
          operation: DataOperation.delete,
          data: state.data,
          exceptionType: extractExceptionType(e),
        ),
      );
    }
  }
}
