import 'package:dashboard/src/common/services/responsive_content.dart';
import 'package:dashboard/src/common/widgets/buttons/custom_button_v2.dart';
import 'package:dashboard/src/common/widgets/images/custom_image.dart';
import 'package:dashboard/src/core/constants/app_images.dart';
import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:dashboard/src/core/theme/app_dimens.dart';
import 'package:dashboard/src/core/theme/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';

class CustomError extends StatelessWidget {
  const CustomError({
    this.title = 'Oops! Something went wrong.',
    this.message = 'Please try again later.',
    this.imagePath = AppImages.image404,
    this.imageHeight = 157,
    this.imageWidth = 169,

    this.titleStyle,
    this.messageStyle,
    this.textAlign = TextAlign.center,
    this.onTap,
    this.retryButtonText = 'Retry',
    this.expandedButton = true,
    super.key,
  });
  final String imagePath;
  final double imageHeight;
  final double imageWidth;
  final String title;
  final String message;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  //onTap
  final VoidCallback? onTap;
  final String retryButtonText;
  final bool expandedButton;

  final dynamic textAlign;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Responsive.isMobile(context)
          ? MediaQuery.of(context).size.width
          : Responsive.desktopWidth(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.defaultHorizontal,
          vertical: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImage(
              imagePath,
              height: imageHeight,
              width: imageWidth,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 16),
              child: Text(
                title,
                style:
                    titleStyle ??
                    context.headlineSmall.copyWith(color: AppColors.primary),
                textAlign: textAlign as TextAlign?,
              ),
            ),
            Text(
              message,
              style: messageStyle ?? context.bodyLarge,
              textAlign: textAlign as TextAlign?,
            ),
            if (onTap != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: CustomButtonV2(
                  isExpanded: expandedButton,
                  onPressed: onTap,
                  text: retryButtonText,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
