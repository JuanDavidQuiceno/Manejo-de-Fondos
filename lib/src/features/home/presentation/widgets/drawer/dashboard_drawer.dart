import 'package:dashboard/src/common/navigation/app_routes_private_.dart';
import 'package:dashboard/src/core/theme/extensions/text_theme_extension.dart';
import 'package:dashboard/src/features/home/presentation/widgets/drawer/drawer_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Material(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  size: 60,
                  color: Colors.blue,
                ),
                const SizedBox(height: 10),
                Text('Admin Panel', style: context.titleMedium),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          DrawerListTile(
            title: 'Dashboard',
            iconData: Icons.dashboard_outlined,
            isSelected: location == AppRoutesPrivate.homePath,
            press: () => _navigateTo(context, AppRoutesPrivate.homePath),
          ),
          DrawerListTile(
            title: 'Roles',
            iconData: Icons.manage_accounts_outlined,
            isSelected:
                location == AppRoutesPrivate.rolesManagementPath ||
                location.startsWith('${AppRoutesPrivate.rolesManagementPath}/'),
            press: () =>
                _navigateTo(context, AppRoutesPrivate.rolesManagementPath),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    final scaffoldState = Scaffold.maybeOf(context);
    if (scaffoldState?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }
    context.go(route);
  }
}
