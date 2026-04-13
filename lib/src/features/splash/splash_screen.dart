import 'package:dashboard/src/common/bloc/auth/auth_bloc.dart';
import 'package:dashboard/src/common/navigation/app_routes_private_.dart';
import 'package:dashboard/src/common/navigation/app_routes_public.dart';
import 'package:dashboard/src/common/widgets/images/custom_image.dart';
import 'package:dashboard/src/core/constants/app_images.dart';
import 'package:dashboard/src/core/theme/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = 'verification';
  static const String routePath = '/verification';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AuthBloc authBloc;

  // Controladores de animación
  late AnimationController _animationController;
  late Animation<double> animation;

  // Variables de estado para sincronización
  bool _loadingAnimationDone = false; // ¿La barra llegó al 90%?
  AuthState? _finalAuthState; // ¿Ya respondió el Bloc?

  @override
  void initState() {
    super.initState();
    authBloc = context.read<AuthBloc>();

    // 1. Configurar animación inicial
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500), // Tiempo mínimo de splash
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {}); // Reconstruir UI para mover la barra
      });

    // 2. Iniciar procesos simultáneos
    _startLoadingProcess();
  }

  void _startLoadingProcess() {
    // A. Iniciar consulta de autenticación (mientras carga la barra)
    authBloc.add(const AuthValidateEvent());

    // B. Animar la barra hasta el 90% (Simular carga)
    _animationController.animateTo(0.9).then((_) {
      // Cuando termina la animación al 90%
      _loadingAnimationDone = true;
      _checkAndNavigate(); // Intentar finalizar
    });
  }

  // Función central que decide cuándo terminar
  void _checkAndNavigate() {
    // Solo procedemos si AMBAS cosas ocurrieron:
    // 1. La barra visual llegó al 90%
    // 2. Tenemos una respuesta del AuthBloc
    if (_loadingAnimationDone && _finalAuthState != null && mounted) {
      // Completar la barra visualmente (del 90% al 100% rápido)
      _animationController
          .animateTo(1, duration: const Duration(milliseconds: 300))
          .then((_) {
            if (mounted) {
              _executeNavigation(_finalAuthState!);
            }
          });
    }
  }

  void _executeNavigation(AuthState state) {
    switch (state) {
      case AuthNoAuthenticatedState _:
      case AuthFinishWithError _:
        context.go(AppRoutesPublic.signInPath);
      case AuthenticatedState _:
        context.go(AppRoutesPrivate.fundsPath);
      default:
        context.go(AppRoutesPublic.signInPath);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white, // O el color de fondo que desees
      body: BlocListener<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          // Escuchar estados finales solamente
          if (state is AuthenticatedState ||
              state is AuthNoAuthenticatedState ||
              state is AuthFinishWithError) {
            _finalAuthState = state; // Guardar el resultado
            _checkAndNavigate(); // Verificar si podemos irnos
          }
        },
        child: _loading(screenSize),
      ),
    );
  }

  Widget _loading(Size screenSize) {
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // CustomImage(FlavorsConfig.iconApp, height: 300),
          const CustomImage(AppImages.imageLogo, height: 300),
          const SizedBox(height: 40),
          SizedBox(
            width: screenSize.width * 0.6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                minHeight: 6,
                // Usamos el valor del controlador directamente
                value: _animationController.value,
                color: AppColors.primary,
                backgroundColor: AppColors.grey.withAlpha((0.3 * 255).toInt()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
