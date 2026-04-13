// appbar
import 'dart:io';

import 'package:dashboard/src/core/theme/extensions/text_theme_extension.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    this.onTap,
    this.actions,
    this.showBackButton = true,
    this.centerTitle = true,
    this.titleAlignment = CrossAxisAlignment.center,
    this.elevation = 0,
    this.backgroundColor,
    this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    super.key,
  });

  final void Function()? onTap;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool centerTitle;
  final CrossAxisAlignment titleAlignment;
  final double elevation;
  final Color? backgroundColor;
  final String? title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appBarTheme;
    return AppBar(
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor ?? theme.backgroundColor,
      leading: IconButton(
        icon: Icon(
          kIsWeb
              ? Icons.arrow_back
              : Platform.isIOS
              ? Icons.arrow_back_ios
              : Icons.arrow_back,
          color: theme.iconTheme?.color,
        ),
        onPressed:
            onTap ??
            () {
              context.canPop() ? context.pop() : context.go('/');
            },
      ),
      title: Column(
        crossAxisAlignment: titleAlignment,
        children: [
          if (title != null)
            Text(
              title!,
              style:
                  titleStyle ??
                  context.titleMedium.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          if (subtitle != null)
            Text(
              subtitle!,
              style:
                  subtitleStyle ??
                  context.bodySmall.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
            ),
        ],
      ),
      actions: actions,
    );
  }
}
