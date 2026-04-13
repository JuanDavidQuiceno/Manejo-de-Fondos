import 'package:dashboard/src/common/services/responsive_content.dart';
import 'package:dashboard/src/common/widgets/containers/custom_change_theme.dart';
import 'package:dashboard/src/core/theme/extensions/text_theme_extension.dart';
import 'package:dashboard/src/features/home/presentation/widgets/dashboard_card_profile.dart';
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        Text(title, style: context.titleLarge),
        const Spacer(),
        const CustomChangetheme(),
        const DashboardProfileCard(),
      ],
    );
  }
}
