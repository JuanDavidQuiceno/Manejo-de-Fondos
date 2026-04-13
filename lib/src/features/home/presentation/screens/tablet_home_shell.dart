import 'package:dashboard/src/common/navigation/app_routes_private_.dart';
import 'package:dashboard/src/common/widgets/containers/custom_change_theme.dart';
import 'package:dashboard/src/config/router/app_title_helper.dart';
import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:dashboard/src/core/theme/extensions/text_theme_extension.dart';
import 'package:dashboard/src/features/home/presentation/widgets/dashboard_card_profile.dart';
import 'package:dashboard/src/features/home/presentation/widgets/drawer/dashboard_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabletHomeShell extends StatelessWidget {
  const TabletHomeShell({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    final title = getAppTitleFromLocation(location);

    return Scaffold(
      drawer: const Drawer(child: DashboardDrawer()),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TabletNavigationRail(currentLocation: location),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: Text(title),
                  leading: const SizedBox.shrink(),
                  actions: const [
                    CustomChangetheme(),
                    SizedBox(width: 8),
                    DashboardProfileCard(),
                    SizedBox(width: 16),
                  ],
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabletNavigationRail extends StatelessWidget {
  const _TabletNavigationRail({required this.currentLocation});
  final String currentLocation;

  static const _destinations = [
    (
      path: AppRoutesPrivate.fundsPath,
      label: 'Fondos BTG',
      icon: Icons.account_balance_outlined,
      selectedIcon: Icons.account_balance,
    ),
  ];

  int get _selectedIndex {
    for (var i = 0; i < _destinations.length; i++) {
      final path = _destinations[i].path;
      if (currentLocation == path || currentLocation.startsWith('$path/')) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIndex = _selectedIndex;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: NavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) {
                  final path = _destinations[index].path;
                  final scaffoldState = Scaffold.maybeOf(context);
                  if (scaffoldState?.isDrawerOpen ?? false) {
                    Navigator.pop(context);
                  }
                  context.go(path);
                },
                labelType: NavigationRailLabelType.all,
                backgroundColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                selectedIconTheme: IconThemeData(
                  color: theme.colorScheme.primary,
                ),
                unselectedIconTheme: IconThemeData(
                  color: theme.iconTheme.color ?? AppColors.grey,
                ),
                selectedLabelTextStyle: context.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary,
                  fontSize: 10,
                ),
                unselectedLabelTextStyle: context.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.iconTheme.color ?? AppColors.grey,
                  fontSize: 10,
                ),
                leading: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
                destinations: _destinations
                    .map(
                      (d) => NavigationRailDestination(
                        icon: Icon(d.icon),
                        selectedIcon: Icon(d.selectedIcon),
                        label: Text(d.label),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
