import 'package:dashboard/src/common/bloc/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomChangetheme extends StatelessWidget {
  const CustomChangetheme({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;

    return IconButton(
      icon: Icon(
        themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
      ),
      onPressed: () {
        // Llamamos a la lógica del Cubit
        context.read<ThemeCubit>().toggleTheme();
      },
    );
  }
}
