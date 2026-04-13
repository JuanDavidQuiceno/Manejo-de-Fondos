import 'package:bloc/bloc.dart';
import 'package:dashboard/src/common/navigation/app_routes_private_.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'dash_board_state.dart';

class DashBoardCubit extends Cubit<DashBoardState> {
  DashBoardCubit()
    : super(const DashBoardInitial(item: AppRoutesPrivate.homePath));

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    final state = _scaffoldKey.currentState;
    if (state != null && !state.isDrawerOpen) {
      state.openDrawer();
    }
  }

  void closeMenu(String item) {
    emit(DashBoardLoadingState(item: item));
    final state = _scaffoldKey.currentState;
    if (state != null && state.isDrawerOpen) {
      state.closeDrawer();
    }
    emit(DashBoardLoadedState(item: item));
  }

  void selectItem(String item) {
    emit(DashBoardLoadingState(item: item));
    emit(DashBoardLoadedState(item: state.item));
  }

  bool isSelected(String item) {
    return state.item == item;
  }
}
