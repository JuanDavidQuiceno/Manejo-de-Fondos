import 'package:dashboard/src/common/navigation/app_routes_private_.dart';
import 'package:dashboard/src/common/widgets/guards/module_access_guard.dart';
import 'package:dashboard/src/features/home/presentation/screens/home_sections.dart';
import 'package:dashboard/src/features/home/presentation/screens/home_shell_screen.dart';
import 'package:dashboard/src/features/home/state/cubit/dash_board_cubit.dart';
import 'package:dashboard/src/features/roles_management/presentation/roles_management_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> privateRoutes = [
  // Dashboard with Bottom Navigation (ShellRoute)
  ShellRoute(
    builder: (context, state, child) => BlocProvider(
      create: (context) => DashBoardCubit(),
      child: HomeShellScreen(child: child),
    ),
    routes: [
      GoRoute(
        name: AppRoutesPrivate.homeName,
        path: AppRoutesPrivate.homePath,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: DashboardScreen()),
      ),
      GoRoute(
        name: AppRoutesPrivate.rolesManagementName,
        path: AppRoutesPrivate.rolesManagementPath,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ModuleAccessGuard(
            moduleSlug: 'roles', // Se asume el slug 'roles'
            child: RolesManagementScreen(),
          ),
        ),
      ),
    ],
  ),
];
