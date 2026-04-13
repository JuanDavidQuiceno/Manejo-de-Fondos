import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCardContainer extends StatelessWidget {
  const CustomCardContainer({
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.margin,
    this.width,
    this.height,
    this.border,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color:
            Theme.of(context).extension<AppColorsExtension>()?.card ??
            Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: border,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
