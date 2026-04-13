import 'package:dashboard/src/common/auth/services/auth_services.dart';
import 'package:dashboard/src/common/bloc/auth/auth_bloc.dart';
import 'package:dashboard/src/common/bloc/theme/theme_cubit.dart';
import 'package:dashboard/src/common/navigation/app_routes_public.dart';
import 'package:dashboard/src/config/inyection/global_locator.dart';
import 'package:dashboard/src/config/router/app_title_helper.dart';
import 'package:dashboard/src/config/router/routes.dart';
import 'package:dashboard/src/core/config/storage_service.dart';
import 'package:dashboard/src/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;
  late final ValueNotifier<String> _currentLocation;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(
      repository: global<AuthService>(),
      secureStorage: global<StorageService>(),
    );

    _currentLocation = ValueNotifier<String>(AppRoutesPublic.splashPath);
    _router = createRouter(
      _authBloc,
      currentLocationNotifier: _currentLocation,
    );
  }

  @override
  void dispose() {
    _currentLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => _authBloc),
        BlocProvider(create: (context) => ThemeCubit(global<StorageService>())),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (_, state) {
          return ValueListenableBuilder<String>(
            valueListenable: _currentLocation,
            builder: (_, location, __) {
              final title = getAppTitleFromLocation(location);
              return MaterialApp.router(
                title: title,
                debugShowCheckedModeBanner: false,
                routerConfig: _router,
                theme: AppThemes.light,
                darkTheme: AppThemes.dark,
                themeMode: state,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('es', 'CO'),
                  Locale('es', 'ES'),
                  Locale('en', 'US'),
                ],
                builder: (builderContext, child) {
                  return MediaQuery(
                    data: MediaQuery.of(
                      builderContext,
                    ).copyWith(textScaler: TextScaler.noScaling),
                    child: child!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
