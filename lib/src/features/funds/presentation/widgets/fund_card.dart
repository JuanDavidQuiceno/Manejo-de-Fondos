import 'package:dashboard/src/common/widgets/buttons/custom_button_v2.dart';
import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:dashboard/src/features/funds/domain/models/fund_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FundCard extends StatelessWidget {
  const FundCard({
    required this.fund,
    required this.onSubscribe,
    required this.onCancel,
    super.key,
  });

  final FundModel fund;
  final VoidCallback onSubscribe;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatted = NumberFormat.currency(
      locale: 'es_CO',
      symbol: r'COP $',
      decimalDigits: 0,
    ).format(fund.minAmount);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: fund.isSubscribed
            ? BorderSide(
                color: theme.colorScheme.primary.withAlpha(120),
                width: 1.5,
              )
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CategoryBadge(category: fund.category),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fund.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Monto mínimo: $formatted',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(160),
                    ),
                  ),
                  if (fund.isSubscribed && fund.subscribedAmount != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Suscrito: ${NumberFormat.currency(
                        locale: 'es_CO',
                        symbol: r'COP $',
                        decimalDigits: 0,
                      ).format(fund.subscribedAmount)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (fund.isSubscribed)
              CustomButtonV2(
                text: 'Cancelar',
                isOutlined: true,
                foregroundColor: AppColors.red,
                backgroundColor: AppColors.red,
                onPressed: onCancel,
              )
            else
              CustomButtonV2(
                text: 'Suscribirse',
                onPressed: onSubscribe,
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final isFpv = category == 'FPV';
    final color = isFpv ? AppColors.primary : const Color(0xFF2E7D32);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
