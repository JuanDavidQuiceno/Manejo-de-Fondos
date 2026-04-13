import 'package:dashboard/src/common/widgets/buttons/custom_button_v2.dart';
import 'package:dashboard/src/common/widgets/modal/custom_modal_header.dart';
import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:dashboard/src/features/funds/domain/models/fund_model.dart';
import 'package:dashboard/src/features/funds/presentation/state/funds_cubit.dart';
import 'package:dashboard/src/features/funds/presentation/state/funds_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CancelDialog extends StatelessWidget {
  const CancelDialog({required this.fund, super.key});

  final FundModel fund;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatted = NumberFormat.currency(
      locale: 'es_CO',
      symbol: r'COP $',
      decimalDigits: 0,
    ).format(fund.subscribedAmount ?? 0);

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
          const CustomModalHeader(title: 'Cancelar participación'),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.red.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.red.withAlpha(60)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Al cancelar, recibirá el reintegro de $formatted '
                          'a su saldo disponible.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  fund.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '¿Está seguro de que desea cancelar su participación?',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(160),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<FundsCubit, FundsState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: CustomButtonV2(
                            text: 'No cancelar',
                            isOutlined: true,
                            onPressed: state.isOperating
                                ? null
                                : () => context.pop(false),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButtonV2(
                            text: 'Confirmar',
                            backgroundColor: AppColors.red,
                            isLoading: state.isOperating,
                            onPressed: state.isOperating
                                ? null
                                : () => context
                                    .read<FundsCubit>()
                                    .cancel(fund.id),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
