import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:dashboard/src/features/funds/domain/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsHistoryView extends StatelessWidget {
  const TransactionsHistoryView({required this.transactions, super.key});

  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(60),
            ),
            const SizedBox(height: 16),
            Text(
              'Sin transacciones aún',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) =>
          _TransactionItem(transaction: transactions[index]),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSubscription =
        transaction.type == TransactionType.subscription;

    final color = isSubscription ? AppColors.red : const Color(0xFF2E7D32);
    final icon = isSubscription
        ? Icons.arrow_upward_rounded
        : Icons.arrow_downward_rounded;
    final label = isSubscription ? 'Suscripción' : 'Cancelación';
    final sign = isSubscription ? '-' : '+';

    final formattedAmount = NumberFormat.currency(
      locale: 'es_CO',
      symbol: r'COP $',
      decimalDigits: 0,
    ).format(transaction.amount);

    final formattedDate = DateFormat(
      'dd/MM/yyyy HH:mm',
      'es_CO',
    ).format(transaction.date);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        transaction.fundName,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(140),
            ),
          ),
          Text(
            formattedDate,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(100),
              fontSize: 11,
            ),
          ),
          if (transaction.notificationMethod != null)
            Text(
              'Notif. por ${transaction.notificationMethod!.label}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(100),
                fontSize: 11,
              ),
            ),
        ],
      ),
      trailing: Text(
        '$sign $formattedAmount',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
