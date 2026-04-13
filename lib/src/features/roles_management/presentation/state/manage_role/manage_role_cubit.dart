import 'package:dashboard/src/features/roles_management/domain/repositories/roles_management_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manage_role_state.dart';

class ManageRoleCubit extends Cubit<ManageRoleState> {
  ManageRoleCubit({required this.repository}) : super(ManageRoleInitial());

  final RolesManagementRepository repository;

  Future<void> createRole(Map<String, dynamic> data) async {
    emit(ManageRoleLoading());
    try {
      await repository.createRole(data);
      emit(ManageRoleSuccess());
    } on Object catch (e) {
      emit(ManageRoleFailure(e.toString()));
    }
  }

  Future<void> updateRole(String id, Map<String, dynamic> data) async {
    emit(ManageRoleLoading());
    try {
      await repository.updateRole(id, data);
      emit(ManageRoleSuccess());
    } on Object catch (e) {
      emit(ManageRoleFailure(e.toString()));
    }
  }
}
