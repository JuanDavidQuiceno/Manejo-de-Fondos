part of 'delete_role_cubit.dart';

abstract class DeleteRoleState {}

class DeleteRoleInitial extends DeleteRoleState {}

class DeleteRoleLoading extends DeleteRoleState {}

class DeleteRoleSuccess extends DeleteRoleState {
  DeleteRoleSuccess(this.roleId);
  final String roleId;
}

class DeleteRoleFailure extends DeleteRoleState {
  DeleteRoleFailure(this.error);
  final String error;
}
