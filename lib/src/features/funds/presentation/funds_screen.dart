import 'package:dashboard/src/common/widgets/custom_loading.dart';
import 'package:dashboard/src/common/widgets/dialogs/custom_dialog.dart';
import 'package:dashboard/src/features/funds/data/repositories/mock_funds_repository_impl.dart';
import 'package:dashboard/src/features/funds/domain/repositories/funds_repository.dart';
import 'package:dashboard/src/features/funds/presentation/state/funds_cubit.dart';
import 'package:dashboard/src/features/funds/presentation/state/funds_state.dart';
import 'package:dashboard/src/features/funds/presentation/widgets/cancel_dialog.dart';
import 'package:dashboard/src/features/funds/presentation/widgets/fund_card.dart';
import 'package:dashboard/src/features/funds/presentation/widgets/funds_balance_card.dart';
import 'package:dashboard/src/features/funds/presentation/widgets/subscribe_dialog.dart';
import 'package:dashboard/src/features/funds/presentation/widgets/transactions_history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FundsScreen extends StatelessWidget {
  const FundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<FundsRepository>(
      create: (_) => MockFundsRepositoryImpl(),
      child: BlocProvider(
        create: (context) => FundsCubit(
          repository: context.read<FundsRepository>(),
        )..loadData(),
        child: const _FundsView(),
      ),
    );
  }
}

class _FundsView extends StatelessWidget {
  const _FundsView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<FundsCubit, FundsState>(
      listenWhen: (prev, curr) =>
          curr.errorMessage != null && prev.errorMessage != curr.errorMessage ||
          curr.successMessage != null &&
              prev.successMessage != curr.successMessage,
      listener: (context, state) {
        final message = state.errorMessage ?? state.successMessage;
        if (message == null) return;
        final isError = state.errorMessage != null;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: isError
                  ? Colors.red.shade700
                  : Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        context.read<FundsCubit>().clearMessages();
      },
      child: DefaultTabController(
        length: 2,
        child: Stack(
          children: [
            Scaffold(
              body: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Fondos disponibles'),
                      Tab(text: 'Historial'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _FundsTab(),
                        _HistoryTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<FundsCubit, FundsState>(
              builder: (context, state) =>
                  CustomLoading(isLoading: state.isOperating),
            ),
          ],
        ),
      ),
    );
  }
}

class _FundsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FundsCubit, FundsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FundsBalanceCard(balance: state.balance),
            const SizedBox(height: 16),
            ...state.funds.map(
              (fund) => FundCard(
                fund: fund,
                onSubscribe: () => _showSubscribeDialog(context, fund.id),
                onCancel: () => _showCancelDialog(context, fund.id),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSubscribeDialog(
    BuildContext context,
    String fundId,
  ) async {
    final cubit = context.read<FundsCubit>();
    final fund = cubit.state.funds.firstWhere((f) => f.id == fundId);

    await showCustomDialog<bool>(
      context,
      child: BlocProvider.value(
        value: cubit,
        child: SubscribeDialog(fund: fund),
      ),
    );
  }

  Future<void> _showCancelDialog(
    BuildContext context,
    String fundId,
  ) async {
    final cubit = context.read<FundsCubit>();
    final fund = cubit.state.funds.firstWhere((f) => f.id == fundId);

    await showCustomDialog<bool>(
      context,
      child: BlocProvider.value(
        value: cubit,
        child: CancelDialog(fund: fund),
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FundsCubit, FundsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return TransactionsHistoryView(transactions: state.transactions);
      },
    );
  }
}
