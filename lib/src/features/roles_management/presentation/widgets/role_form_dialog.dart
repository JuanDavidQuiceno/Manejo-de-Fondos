import 'package:dashboard/src/common/models/role/role_model.dart';
import 'package:dashboard/src/common/widgets/buttons/custom_button_v2.dart';
import 'package:dashboard/src/common/widgets/modal/custom_modal_header.dart';
import 'package:dashboard/src/common/widgets/text_field/custom_text_field.dart';
import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:dashboard/src/features/roles_management/domain/repositories/roles_management_repository.dart';
import 'package:dashboard/src/features/roles_management/presentation/state/manage_role/manage_role_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RoleFormDialog extends StatelessWidget {
  const RoleFormDialog({this.role, super.key});

  final RoleModel? role;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageRoleCubit(
        repository: context.read<RolesManagementRepository>(),
      ),
      child: _RoleFormView(role: role),
    );
  }
}

class _RoleFormView extends StatefulWidget {
  const _RoleFormView({this.role});

  final RoleModel? role;

  @override
  State<_RoleFormView> createState() => _RoleFormViewState();
}

class _RoleFormViewState extends State<_RoleFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _slugController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.role?.name ?? '');
    _slugController = TextEditingController(text: widget.role?.slug ?? '');
    _descriptionController = TextEditingController(
      text: widget.role?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.role != null;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageRoleCubit, ManageRoleState>(
      listener: (context, state) {
        if (state is ManageRoleSuccess) {
          context.pop(true);
        } else if (state is ManageRoleFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.error}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ManageRoleLoading;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomModalHeader(title: _isEditing ? 'Editar rol' : 'Crear rol'),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          labelText: 'Nombre',
                          hintText: 'Ej. Administrador',
                          controller: _nameController,
                          enabled: !isLoading,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El nombre es obligatorio';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (!_isEditing) {
                              final slugValue = value.toLowerCase().replaceAll(
                                ' ',
                                '_',
                              );
                              _slugController.text = slugValue;
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          labelText: 'Slug',
                          hintText: 'Ej. administrator',
                          controller: _slugController,
                          enabled: !isLoading,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El slug es obligatorio';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          labelText: 'Descripción (Opcional)',
                          hintText: 'Ej. Acceso total al sistema',
                          controller: _descriptionController,
                          enabled: !isLoading,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 32),
                        CustomButtonV2(
                          text: _isEditing ? 'Actualizar rol' : 'Crear rol',
                          isLoading: isLoading,
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final data = {
                                'name': _nameController.text.trim(),
                                'slug': _slugController.text.trim(),
                                'description': _descriptionController.text
                                    .trim(),
                              };

                              if (_isEditing) {
                                context.read<ManageRoleCubit>().updateRole(
                                  widget.role!.id,
                                  data,
                                );
                              } else {
                                context.read<ManageRoleCubit>().createRole(
                                  data,
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
