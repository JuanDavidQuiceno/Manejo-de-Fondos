import 'package:dashboard/src/common/bloc/auth/auth_bloc.dart';
import 'package:dashboard/src/common/services/responsive_content.dart';
import 'package:dashboard/src/common/widgets/containers/custom_card_container.dart';
import 'package:dashboard/src/common/widgets/custom_loading.dart';
import 'package:dashboard/src/common/widgets/images/custom_image.dart';
import 'package:dashboard/src/common/widgets/text_field/custom_text_field.dart';
import 'package:dashboard/src/config/inyection/global_locator.dart';
import 'package:dashboard/src/core/config/storage_service.dart';
import 'package:dashboard/src/core/constants/app_images.dart';
import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:dashboard/src/core/theme/app_dimens.dart';
import 'package:dashboard/src/core/utils/mixin/form_validation_mixin.dart';
import 'package:dashboard/src/features/sign_in/data/repositories/mock_signin_repository_impl.dart';
import 'package:dashboard/src/features/sign_in/domain/repository/signin_repository.dart';
import 'package:dashboard/src/features/sign_in/presentation/widgets/signin_button.dart';
import 'package:dashboard/src/features/sign_in/state/bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SignInRepository>(
          create: (context) => MockSignInRepositoryImpl(),
        ),
      ],
      child: BlocProvider(
        create: (context) => SignInBloc(
          signInRepository: context.read<SignInRepository>(),
          localStorage: global<StorageService>(),
        )..add(const SignInInitializeEvent()),
        child: Stack(
          children: [
            Scaffold(
              // extendBody: true,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                leading: const SizedBox.shrink(),
                // actions: const [CustomChangetheme()],
                elevation: 0,
                backgroundColor: AppColors.transparent,
                foregroundColor: AppColors.transparent,
                centerTitle: true,
              ),
              body: Container(
                height: size.height,
                width: size.width,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 40,
                        horizontal: AppDimens.defaultHorizontal,
                      ),
                      width: Responsive.isMobile(context)
                          ? size.width
                          : Responsive.desktopWidth(context),
                      child: const LoginForm(),
                    ),
                  ),
                ),
              ),
            ),
            const LoginLoading(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget with FormValidationMixin {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomCardContainer(
            child: Column(
              children: [
                // Moving Logo INSIDE the Glass Container
                const Hero(
                  tag: 'logo',
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: FittedBox(
                      child: CustomImage(
                        AppImages.imageLogo,
                        height: 120, // Slightly smaller to fit nicely
                        width: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Iniciar sesión',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Email/Phone input
                CustomTextField(
                  labelText: 'Correo electrónico',
                  hintText: 'ejemplo@correo.com',
                  validator: validateEmailOrPhone,
                  autocorrect: false,
                  maxLength: 100,
                  keyboardType: TextInputType.emailAddress,
                  onTapOutSide: (value) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  onChanged: (value) => context.read<SignInBloc>().add(
                    SignInEmailChangedEvent(email: value.trim()),
                  ),
                ),
                const SizedBox(height: 24),
                // Password input
                CustomPasswordField(
                  labelText: 'Contraseña',
                  validator: validatePassword,
                  maxLength: 25,
                  onTapOutSide: (value) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  onChanged: (value) => context.read<SignInBloc>().add(
                    SignInPasswordChangedEvent(password: value.trim()),
                  ),
                  onFieldSubmitted: (value) {
                    context.read<SignInBloc>().add(SignInRequestedEvent());
                  },
                ),

                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: SignInButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoginLoading extends StatelessWidget {
  const LoginLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
      listener: (_, state) {
        if (state is SignInSuccessState) {
          context.read<AuthBloc>().add(AuthLoginEvent(model: state.userModel));
          return;
        }
      },
      builder: (_, state) {
        return CustomLoading(isLoading: state is SignInLoadingState);
      },
    );
  }
}
