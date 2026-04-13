import 'package:dashboard/src/features/funds/presentation/state/funds_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Envuelve [child] en un MaterialApp mínimo (sin router).
/// Útil para widgets que no necesitan navegación.
Widget buildApp(Widget child) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}

/// Envuelve [child] con BlocProvider y un GoRouter de una sola ruta.
/// Requerido para widgets que usan context.pop() (dialogs).
Widget buildDialogApp({
  required Widget child,
  required FundsCubit cubit,
}) {
  return BlocProvider<FundsCubit>.value(
    value: cubit,
    child: MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => Scaffold(body: child),
          ),
        ],
      ),
    ),
  );
}
