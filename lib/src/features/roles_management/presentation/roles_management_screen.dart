import 'package:dashboard/src/common/bloc/data/data_bloc.dart';
import 'package:dashboard/src/common/models/role/role_model.dart';
import 'package:dashboard/src/common/repositories/role/data/repositories/role_list_repository_impl.dart';
import 'package:dashboard/src/common/repositories/role/domain/repositories/role_list_repository.dart';
import 'package:dashboard/src/common/services/responsive_content.dart';
import 'package:dashboard/src/common/widgets/custom_error.dart';
import 'package:dashboard/src/common/widgets/custom_loading.dart';
import 'package:dashboard/src/common/widgets/dialogs/custom_dialog.dart';
import 'package:dashboard/src/config/inyection/global_locator.dart';
import 'package:dashboard/src/core/api/api_client.dart';
import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:dashboard/src/features/roles_management/data/repositories/roles_management_repository_impl.dart';
import 'package:dashboard/src/features/roles_management/domain/repositories/roles_management_repository.dart';
import 'package:dashboard/src/features/roles_management/presentation/state/delete_role/delete_role_cubit.dart';
import 'package:dashboard/src/features/roles_management/presentation/widgets/no_roles_view.dart';
import 'package:dashboard/src/features/roles_management/presentation/widgets/role_form_dialog.dart';
import 'package:dashboard/src/features/roles_management/presentation/widgets/roles_header.dart';
import 'package:dashboard/src/features/roles_management/presentation/widgets/roles_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RolesManagementScreen extends StatelessWidget {
  const RolesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RoleListRepository>(
          create: (context) =>
              RoleListRepositoryImpl(apiClient: global<ApiClient>()),
        ),
        RepositoryProvider<RolesManagementRepository>(
          create: (context) =>
              RolesManagementRepositoryImpl(apiClient: global<ApiClient>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DataBloc<List<RoleModel>>(
              repository: context.read<RoleListRepository>(),
            )..add(const DataFetchEvent()),
          ),
          BlocProvider(
            create: (context) => DeleteRoleCubit(
              repository: context.read<RolesManagementRepository>(),
            ),
          ),
        ],
        child: const _RolesManagementView(),
      ),
    );
  }
}

class _RolesManagementView extends StatelessWidget {
  const _RolesManagementView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RolesHeader(onRegister: () => _navigateToCreate(context)),
        Expanded(
          child: MultiBlocListener(
            listeners: [
              BlocListener<
                DataBloc<List<RoleModel>>,
                DataState<List<RoleModel>>
              >(
                listener: (context, state) {
                  if (state is DataErrorState<List<RoleModel>>) {
                    // TODO: handle error
                  }
                },
              ),
              BlocListener<DeleteRoleCubit, DeleteRoleState>(
                listener: (context, state) {
                  if (state is DeleteRoleSuccess) {
                    context.read<DataBloc<List<RoleModel>>>().add(
                      const DataRefreshEvent(),
                    );
                  } else if (state is DeleteRoleFailure) {
                    // TODO: handle error
                  }
                },
              ),
            ],
            child:
                BlocBuilder<
                  DataBloc<List<RoleModel>>,
                  DataState<List<RoleModel>>
                >(
                  builder: (context, state) {
                    final isLoadingFetch =
                        state is DataInitialState<List<RoleModel>> ||
                        (state is DataLoadingState<List<RoleModel>> &&
                            state.operation == DataOperation.fetch);

                    if (isLoadingFetch) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Stack(
                      children: [
                        Scaffold(
                          body: _buildBody(context, state),
                          floatingActionButton: Responsive.isMobile(context)
                              ? _buildFAB(context)
                              : null,
                        ),
                        BlocBuilder<DeleteRoleCubit, DeleteRoleState>(
                          builder: (context, deleteState) {
                            return CustomLoading(
                              isLoading:
                                  (state is DataLoadingState<List<RoleModel>> &&
                                      state.operation ==
                                          DataOperation.submit) ||
                                  deleteState is DeleteRoleLoading,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, DataState<List<RoleModel>> state) {
    if (state is DataErrorState<List<RoleModel>> &&
        state.operation == DataOperation.fetch) {
      return Center(
        child: CustomError(
          title: 'Error al cargar los roles',
          message: state.message,
          retryButtonText: 'Reintentar',
          onTap: () => context.read<DataBloc<List<RoleModel>>>().add(
            const DataFetchEvent(),
          ),
        ),
      );
    }

    final roles = state.data ?? [];
    if (roles.isEmpty) {
      return NoRolesView(onRegister: () => _navigateToCreate(context));
    }

    return RolesListView(roles: roles);
  }

  Widget? _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _navigateToCreate(context),
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add, color: AppColors.white),
    );
  }

  Future<void> _navigateToCreate(BuildContext context) async {
    final repo = context.read<RolesManagementRepository>();

    final result = await showCustomDialog<bool>(
      context,
      child: RepositoryProvider.value(
        value: repo,
        child: const RoleFormDialog(),
      ),
    );

    if ((result ?? false) && context.mounted) {
      context.read<DataBloc<List<RoleModel>>>().add(const DataRefreshEvent());
    }
  }
}
