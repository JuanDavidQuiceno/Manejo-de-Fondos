import 'package:dashboard/src/common/bloc/auth/auth_bloc.dart';
import 'package:dashboard/src/common/navigation/app_routes_private_.dart';
import 'package:dashboard/src/common/navigation/app_routes_public.dart';
import 'package:dashboard/src/config/router/private/private_routes.dart';
import 'package:dashboard/src/config/router/public_routes.dart';
import 'package:dashboard/src/config/router/router_refresh_stream.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Crea el GoRouter. Si se pasa [currentLocationNotifier], se actualiza
/// con la ruta actual en cada redirect para poder derivar el título de la app.
GoRouter createRouter(
  AuthBloc authBloc, {
  ValueNotifier<String>? currentLocationNotifier,
}) {
  return GoRouter(
    initialLocation: AppRoutesPublic.splashPath,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),

    routes: [...publicRoutes, ...privateRoutes],

    redirect: (BuildContext context, GoRouterState state) {
      final authState = authBloc.state;
      final isAuthenticated = authState.authStatus == AuthStatus.authenticated;

      final fullPath = state.matchedLocation;
      final uriPath = state.uri.path;
      final isGoingToPublic = AppRoutesPublic.publicPaths.any(
        fullPath.startsWith,
      );
      if (kDebugMode) {
        debugPrint('Path actual: $fullPath');
        debugPrint('URI path: $uriPath');
        debugPrint('¿Es público?: $isGoingToPublic');
      }

      String? redirectResult;

      if (authState.authStatus == AuthStatus.checking) {
        // Mientras el auth está verificando, mantener al usuario en el splash
        redirectResult = fullPath == AppRoutesPublic.splashPath
            ? null
            : AppRoutesPublic.splashPath;
      } else if (!isAuthenticated) {
        // Solo redirigir a sign-in si intenta acceder a rutas privadas
        redirectResult = !isGoingToPublic ? AppRoutesPublic.signInPath : null;
      } else if (isAuthenticated) {
        if (isGoingToPublic || fullPath == '/') {
          redirectResult = AppRoutesPrivate.homePath;
        }
      }

      final resolvedLocation = redirectResult ?? fullPath;
      final notifier = currentLocationNotifier;
      if (notifier != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifier.value = resolvedLocation;
        });
      }

      return redirectResult;
    },
  );
}
