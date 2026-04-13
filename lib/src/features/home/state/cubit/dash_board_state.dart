part of 'dash_board_cubit.dart';

sealed class DashBoardState extends Equatable {
  const DashBoardState({required this.item});
  final String item;
  @override
  List<Object> get props => [];
}

final class DashBoardInitial extends DashBoardState {
  const DashBoardInitial({required super.item});
}

final class DashBoardLoadingState extends DashBoardState {
  const DashBoardLoadingState({required super.item});
}

final class DashBoardLoadedState extends DashBoardState {
  const DashBoardLoadedState({required super.item});
}
