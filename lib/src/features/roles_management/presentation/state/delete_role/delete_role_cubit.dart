import 'package:dashboard/src/features/roles_management/domain/repositories/roles_management_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'delete_role_state.dart';

class DeleteRoleCubit extends Cubit<DeleteRoleState> {
  DeleteRoleCubit({required this.repository}) : super(DeleteRoleInitial());

  final RolesManagementRepository repository;

  Future<void> deleteRole(String id) async {
    emit(DeleteRoleLoading());
    try {
      await repository.deleteRole(id);
      emit(DeleteRoleSuccess(id));
    } on Object catch (e) {
      emit(DeleteRoleFailure(e.toString()));
    }
  }
}
