import 'package:dashboard/src/common/widgets/images/custom_image.dart';
import 'package:dashboard/src/core/theme/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    required this.title,
    required this.press,
    this.image,
    this.iconData,
    this.isSelected = false,
    super.key,
  });

  final String title;
  final bool isSelected;
  final String? image;
  final IconData? iconData;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = isSelected
        ? theme.colorScheme.primary
        : (theme.iconTheme.color ?? theme.colorScheme.onSurface);

    return ListTile(
      selected: isSelected,
      onTap: press,
      horizontalTitleGap: 0,
      leading: iconData != null
          ? Icon(iconData, size: 20, color: activeColor)
          : image != null
          ? CustomImage(
              image!,
              height: 18,
              width: 18,
              color: activeColor,
              widthLoading: 15,
              heightLoading: 15,
              strokeWidthLoading: 1,
              sizeIconError: 20,
            )
          : Icon(Icons.info_outline, size: 20, color: activeColor),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          title,
          style: context.bodyMedium.copyWith(
            color: isSelected
                ? theme.colorScheme.primary
                : (theme.iconTheme.color ?? theme.colorScheme.onSurface),
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }
}
