import 'package:dashboard/src/common/widgets/buttons/custom_button_v2.dart';
import 'package:dashboard/src/common/widgets/modal/custom_modal_header.dart';
import 'package:dashboard/src/features/funds/domain/models/fund_model.dart';
import 'package:dashboard/src/features/funds/domain/models/transaction_model.dart';
import 'package:dashboard/src/features/funds/presentation/state/funds_cubit.dart';
import 'package:dashboard/src/features/funds/presentation/state/funds_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SubscribeDialog extends StatefulWidget {
  const SubscribeDialog({required this.fund, super.key});

  final FundModel fund;

  @override
  State<SubscribeDialog> createState() => _SubscribeDialogState();
}

class _SubscribeDialogState extends State<SubscribeDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  NotificationMethod _notification = NotificationMethod.email;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.fund.minAmount.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String _formatCop(double value) => NumberFormat.currency(
    locale: 'es_CO',
    symbol: r'COP $',
    decimalDigits: 0,
  ).format(value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<FundsCubit, FundsState>(
      listener: (context, state) {
        if (!state.isOperating && state.successMessage != null) {
          context.pop(true);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CustomModalHeader(title: 'Suscribirse al fondo'),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _InfoRow(label: 'Fondo', value: widget.fund.name),
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: 'Monto mínimo',
                    value: _formatCop(widget.fund.minAmount),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Monto a suscribir',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      prefixText: r'COP $ ',
                    ),
                    validator: (value) {
                      final amount = double.tryParse(value ?? '') ?? 0;
                      if (amount < widget.fund.minAmount) {
                        return 'Mínimo ${_formatCop(widget.fund.minAmount)}';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Método de notificación',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RadioGroup<NotificationMethod>(
                    groupValue: _notification,
                    onChanged: (v) {
                      if (v != null) setState(() => _notification = v);
                    },
                    child: Column(
                      children: NotificationMethod.values
                          .map(
                            (method) => RadioListTile<NotificationMethod>(
                              value: method,
                              title: Text(method.label),
                              contentPadding: EdgeInsets.zero,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  // Error inline
                  BlocBuilder<FundsCubit, FundsState>(
                    buildWhen: (prev, curr) =>
                        prev.errorMessage != curr.errorMessage,
                    builder: (context, state) {
                      if (state.errorMessage == null) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ErrorBanner(message: state.errorMessage!),
                      );
                    },
                  ),
                  BlocBuilder<FundsCubit, FundsState>(
                    builder: (context, state) {
                      return CustomButtonV2(
                        text: 'Confirmar suscripción',
                        isExpanded: true,
                        isLoading: state.isOperating,
                        onPressed: state.isOperating ? null : _submit,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount =
        double.tryParse(_amountController.text) ?? widget.fund.minAmount;
    context.read<FundsCubit>().subscribe(
      fundId: widget.fund.id,
      amount: amount,
      notificationMethod: _notification,
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
