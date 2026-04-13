part of 'manage_role_cubit.dart';

abstract class ManageRoleState {}

class ManageRoleInitial extends ManageRoleState {}

class ManageRoleLoading extends ManageRoleState {}

class ManageRoleSuccess extends ManageRoleState {}

class ManageRoleFailure extends ManageRoleState {
  ManageRoleFailure(this.error);
  final String error;
}
