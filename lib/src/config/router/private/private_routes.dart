import 'package:dashboard/src/common/navigation/app_routes_private_.dart';
import 'package:dashboard/src/features/funds/presentation/funds_screen.dart';
import 'package:dashboard/src/features/home/presentation/screens/home_shell_screen.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> privateRoutes = [
  ShellRoute(
    builder: (context, state, child) => HomeShellScreen(child: child),
    routes: [
      GoRoute(
        name: AppRoutesPrivate.fundsName,
        path: AppRoutesPrivate.fundsPath,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: FundsScreen()),
      ),
    ],
  ),
];
