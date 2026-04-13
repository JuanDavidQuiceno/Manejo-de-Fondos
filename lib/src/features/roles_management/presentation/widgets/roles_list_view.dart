import 'package:dashboard/src/common/models/role/role_model.dart';
import 'package:dashboard/src/features/roles_management/presentation/widgets/role_item.dart';
import 'package:flutter/material.dart';

class RolesListView extends StatelessWidget {
  const RolesListView({required this.roles, super.key});

  final List<RoleModel> roles;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: roles.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final role = roles[index];
        return RoleItem(role: role);
      },
    );
  }
}
