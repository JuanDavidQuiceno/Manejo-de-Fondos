import 'package:dashboard/src/core/theme/app_dimens.dart';
import 'package:dashboard/src/core/theme/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';

class CustomPageBackButtonHeader extends StatelessWidget {
  const CustomPageBackButtonHeader({
    required this.title,
    super.key,
    this.onBack,
  });

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimens.defaultHorizontal / 2,
        top: AppDimens.defaultHorizontal / 2,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Volver',
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: context.titleMedium.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
