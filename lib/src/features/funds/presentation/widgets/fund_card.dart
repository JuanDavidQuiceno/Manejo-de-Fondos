import 'package:dashboard/src/common/services/responsive_content.dart';
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

  String _formatCop(double value) => NumberFormat.currency(
    locale: 'es_CO',
    symbol: r'COP $',
    decimalDigits: 0,
  ).format(value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);

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
        child: isMobile
            ? _MobileLayout(
                fund: fund,
                formatter: _formatCop,
                onSubscribe: onSubscribe,
                onCancel: onCancel,
              )
            : _DesktopLayout(
                fund: fund,
                formatter: _formatCop,
                onSubscribe: onSubscribe,
                onCancel: onCancel,
              ),
      ),
    );
  }
}

// ── Mobile: layout vertical ────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.fund,
    required this.formatter,
    required this.onSubscribe,
    required this.onCancel,
  });

  final FundModel fund;
  final String Function(double) formatter;
  final VoidCallback onSubscribe;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _CategoryBadge(category: fund.category),
            const Spacer(),
            if (fund.isSubscribed)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Suscrito',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          fund.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Monto mínimo: ${formatter(fund.minAmount)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
        ),
        if (fund.isSubscribed && fund.subscribedAmount != null) ...[
          const SizedBox(height: 2),
          Text(
            'Suscrito: ${formatter(fund.subscribedAmount!)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 14),
        if (fund.isSubscribed)
          CustomButtonV2(
            text: 'Cancelar participación',
            isOutlined: true,
            isExpanded: true,
            foregroundColor: AppColors.red,
            backgroundColor: AppColors.red,
            onPressed: onCancel,
          )
        else
          CustomButtonV2(
            text: 'Suscribirse',
            isExpanded: true,
            onPressed: onSubscribe,
          ),
      ],
    );
  }
}

// ── Desktop/Tablet: layout horizontal ────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.fund,
    required this.formatter,
    required this.onSubscribe,
    required this.onCancel,
  });

  final FundModel fund;
  final String Function(double) formatter;
  final VoidCallback onSubscribe;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _CategoryBadge(category: fund.category),
        const SizedBox(width: 16),
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
                'Monto mínimo: ${formatter(fund.minAmount)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(160),
                ),
              ),
              if (fund.isSubscribed && fund.subscribedAmount != null) ...[
                const SizedBox(height: 2),
                Text(
                  'Suscrito: ${formatter(fund.subscribedAmount!)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 16),
        if (fund.isSubscribed)
          CustomButtonV2(
            text: 'Cancelar',
            isOutlined: true,
            foregroundColor: AppColors.red,
            backgroundColor: AppColors.red,
            onPressed: onCancel,
          )
        else
          CustomButtonV2(text: 'Suscribirse', onPressed: onSubscribe),
      ],
    );
  }
}

// ── Badge de categoría ────────────────────────────────────────────────────

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
