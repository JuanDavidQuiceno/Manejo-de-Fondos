import 'package:dashboard/src/common/widgets/modal/custom_modal_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomTitleAlertDialog extends StatelessWidget {
  const CustomTitleAlertDialog({
    required this.title,
    required this.isLoading,
    super.key,
    this.onClose,
  });
  final String title;
  final bool isLoading;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return CustomModalHeader(
      title: title,
      onClose: isLoading
          ? () {} // Do nothing if loading
          : () {
              if (onClose != null) {
                onClose!();
              } else {
                context.pop();
              }
            },
    );
  }
}
