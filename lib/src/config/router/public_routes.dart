import 'package:dashboard/src/common/feature/loading_scree.dart';
import 'package:dashboard/src/common/navigation/app_routes_public.dart';
import 'package:dashboard/src/features/sign_in/presentation/signin_screen.dart';

import 'package:dashboard/src/features/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

final publicRoutes = <GoRoute>[
  GoRoute(
    path: AppRoutesPublic.loadingPath,
    name: AppRoutesPublic.loadingName,
    builder: (context, state) => const LoadingScreen(),
  ),

  GoRoute(
    name: AppRoutesPublic.splashName,
    path: AppRoutesPublic.splashPath,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    name: AppRoutesPublic.signInName,
    path: AppRoutesPublic.signInPath,
    builder: (context, state) => const SignInScreen(),
  ),
];
