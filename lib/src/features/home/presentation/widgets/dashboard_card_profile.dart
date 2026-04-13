import 'package:dashboard/src/common/bloc/auth/auth_bloc.dart';
import 'package:dashboard/src/common/services/responsive_content.dart';
import 'package:dashboard/src/common/widgets/alerts/alert_dialog.dart';
import 'package:dashboard/src/core/theme/app_dimens.dart';
import 'package:dashboard/src/core/theme/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DashboardProfileCard extends StatefulWidget {
  const DashboardProfileCard({super.key});

  @override
  State<DashboardProfileCard> createState() => _DashboardProfileCardState();
}

class _DashboardProfileCardState extends State<DashboardProfileCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButton<String>(
      offset: const Offset(0, 56),
      color: Theme.of(context).cardColor,
      elevation: 8,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      onSelected: (value) {
        switch (value) {
          case 'logout':
            CustomAlert.dialog(
              context,
              type: AlertType.warning,
              title: 'Cerrar Sesión',
              message: '¿Estás seguro de que deseas cerrar sesión?',
              textButton: 'Cerrar Sesión',
              textButtomCancel: 'Cancelar',
              onPressed: () {
                context.read<AuthBloc>().add(const LogoutEvent());
                context.pop();
              },
              onPressedCancel: () => context.pop(),
            );
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.person_rounded, size: 20),
              const SizedBox(width: 12),
              Text(
                'Perfil',
                style: context.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.logout_rounded, size: 20, color: Colors.red),
              const SizedBox(width: 12),
              Text(
                'Cerrar sesión',
                style: context.bodyMedium.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.defaultHorizontal,
          // vertical: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: theme.colorScheme.primaryContainer),
        ),
        child: Row(
          children: [
            const SizedBox(height: 38, child: Icon(Icons.person_rounded)),
            if (!Responsive.isMobile(context))
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.defaultHorizontal / 2,
                ),
                child: BlocBuilder<AuthBloc, AuthState>(
                  // bloc: global<AuthBloc>(),
                  builder: (_, state) {
                    final name = state.user.name;
                    final lastName = state.user.lastName;

                    final fullName = '$name $lastName';
                    if (fullName.length > 15) {
                      return Text(
                        '$name ${lastName.substring(0, 1)}.',
                        style: theme.textTheme.bodyMedium,
                      );
                    }

                    return Text(fullName, style: theme.textTheme.bodyMedium);
                  },
                ),
              ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
