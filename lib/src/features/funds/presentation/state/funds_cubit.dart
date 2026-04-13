import 'package:dashboard/src/features/funds/domain/models/transaction_model.dart';
import 'package:dashboard/src/features/funds/domain/repositories/funds_repository.dart';
import 'package:dashboard/src/features/funds/presentation/state/funds_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FundsCubit extends Cubit<FundsState> {
  FundsCubit({required FundsRepository repository})
    : _repository = repository,
      super(const FundsState());

  final FundsRepository _repository;

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final balance = await _repository.getUserBalance();
      final funds = await _repository.getFunds();
      final transactions = await _repository.getTransactions();
      emit(
        state.copyWith(
          isLoading: false,
          balance: balance,
          funds: funds,
          transactions: transactions,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> subscribe({
    required String fundId,
    required double amount,
    required NotificationMethod notificationMethod,
  }) async {
    emit(
      state.copyWith(
        isOperating: true,
        errorMessage: null,
        successMessage: null,
      ),
    );
    try {
      await _repository.subscribeFund(
        fundId: fundId,
        amount: amount,
        notificationMethod: notificationMethod,
      );
      await _reload();
      emit(
        state.copyWith(
          isOperating: false,
          successMessage: 'Suscripción realizada exitosamente.',
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          isOperating: false,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> cancel(String fundId) async {
    emit(
      state.copyWith(
        isOperating: true,
        errorMessage: null,
        successMessage: null,
      ),
    );
    try {
      await _repository.cancelFund(fundId);
      await _reload();
      emit(
        state.copyWith(
          isOperating: false,
          successMessage: 'Participación cancelada. Saldo reintegrado.',
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          isOperating: false,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void clearMessages() {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }

  Future<void> _reload() async {
    final balance = await _repository.getUserBalance();
    final funds = await _repository.getFunds();
    final transactions = await _repository.getTransactions();
    emit(
      state.copyWith(
        balance: balance,
        funds: funds,
        transactions: transactions,
      ),
    );
  }
}
