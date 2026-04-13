import 'package:dashboard/src/app.dart';
import 'package:dashboard/src/config/inyection/global_locator.dart';
import 'package:dashboard/src/core/config/observer_bloc.dart';
import 'package:dashboard/src/flavors.dart';
import 'package:dynamic_path_url_strategy/dynamic_path_url_strategy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    FlavorsConfig.appFlavor = FlavorEmun.values.firstWhere(
      (element) => element.name == appFlavor,
      orElse: () => FlavorEmun.staging,
    );
    setPathUrlStrategy();

    /// inicializar inyección de dependencias
    setUpGlobalLocator();
    Bloc.observer = ObserverBloc();
    runApp(const App());
  } on Exception catch (e) {
    if (kDebugMode) {
      print('Error initializing app: $e');
    }

    runApp(
      MaterialApp(
        home: Scaffold(body: Center(child: Text('Error initializing app: $e'))),
      ),
    );
  }
}
