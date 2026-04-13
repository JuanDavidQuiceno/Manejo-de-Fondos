import 'package:dashboard/src/common/widgets/buttons/custom_button_v2.dart';
import 'package:dashboard/src/core/theme/app_dimens.dart';
import 'package:dashboard/src/core/utils/mixin/form_validation_mixin.dart';
import 'package:dashboard/src/features/sign_in/state/bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInButton extends StatelessWidget with FormValidationMixin {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.p16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<SignInBloc, SignInState>(
            builder: (context, state) {
              return CustomButtonV2(
                text: 'Iniciar Sesión',
                onPressed:
                    validateEmailOrPhone(state.model.email) == null &&
                        validatePassword(state.model.password) == null
                    ? () {
                        FocusScope.of(context).unfocus();
                        context.read<SignInBloc>().add(SignInRequestedEvent());
                      }
                    : null,
                isExpanded: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
