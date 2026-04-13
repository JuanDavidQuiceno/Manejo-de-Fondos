import 'package:dashboard/src/core/theme/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';

class CustomTextFieldDropdown<T> extends StatelessWidget {
  const CustomTextFieldDropdown({
    required this.items,
    super.key,
    this.selectedValue,
    this.onChanged,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.filled,
    this.fillColor,
    this.suffixIcon,
    this.prefixIcon,
    this.padding,
    this.isDense = true,
    this.itemLabelBuilder,
    this.validator,
  });

  final List<T> items;
  final T? selectedValue;
  final ValueChanged<T?>? onChanged;

  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool? filled;
  final Color? fillColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? padding;
  final bool isDense;
  final String Function(T)? itemLabelBuilder;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultLabelStyle = context.bodyLarge;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(labelText!, style: defaultLabelStyle),
          const SizedBox(height: 4),
        ],
        DropdownButtonFormField<T>(
          initialValue: items.contains(selectedValue) ? selectedValue : null,
          isDense: isDense,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black87),
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            helperText: helperText,
            errorText: errorText,
            filled: filled,
            fillColor: fillColor,
            contentPadding: padding,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            isDense: isDense,
          ).applyDefaults(theme.inputDecorationTheme),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    itemLabelBuilder?.call(e) ?? e.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
