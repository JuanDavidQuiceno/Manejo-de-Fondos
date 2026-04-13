import 'package:dashboard/src/common/services/responsive_content.dart';
import 'package:dashboard/src/common/widgets/containers/custom_change_theme.dart';
import 'package:dashboard/src/config/router/app_title_helper.dart';
import 'package:dashboard/src/core/theme/app_dimens.dart';
import 'package:dashboard/src/features/home/presentation/screens/tablet_home_shell.dart';
import 'package:dashboard/src/features/home/presentation/widgets/dashboard_card_profile.dart';
import 'package:dashboard/src/features/home/presentation/widgets/dashboard_header.dart';
import 'package:dashboard/src/features/home/presentation/widgets/drawer/dashboard_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeShellScreen extends StatelessWidget {
  const HomeShellScreen({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: MobileHomeShell(child: child),
      desktop: DesktopHomeShell(child: child),
      tablet: TabletHomeShell(child: child),
    );
  }
}

class MobileHomeShell extends StatelessWidget {
  const MobileHomeShell({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final title = getAppTitleFromLocation(location);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: const [
          CustomChangetheme(),
          SizedBox(width: 8),
          DashboardProfileCard(),
          SizedBox(width: 16),
        ],
      ),
      drawer: const Drawer(child: DashboardDrawer()),
      body: child,
    );
  }
}

class DesktopHomeShell extends StatelessWidget {
  const DesktopHomeShell({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    final title = getAppTitleFromLocation(location);

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 250, child: DashboardDrawer()),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.p20,
                    horizontal: AppDimens.defaultHorizontal,
                  ),
                  child: DashboardHeader(title: title),
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
