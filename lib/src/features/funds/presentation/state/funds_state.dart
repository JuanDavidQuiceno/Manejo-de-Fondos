import 'package:dashboard/src/features/funds/domain/models/fund_model.dart';
import 'package:dashboard/src/features/funds/domain/models/transaction_model.dart';
import 'package:equatable/equatable.dart';

class FundsState extends Equatable {
  const FundsState({
    this.balance = 500000,
    this.funds = const [],
    this.transactions = const [],
    this.isLoading = false,
    this.isOperating = false,
    this.errorMessage,
    this.successMessage,
  });

  final double balance;
  final List<FundModel> funds;
  final List<TransactionModel> transactions;
  final bool isLoading;

  /// true mientras se procesa una suscripción o cancelación
  final bool isOperating;
  final String? errorMessage;
  final String? successMessage;

  FundsState copyWith({
    double? balance,
    List<FundModel>? funds,
    List<TransactionModel>? transactions,
    bool? isLoading,
    bool? isOperating,
    Object? errorMessage = _sentinel,
    Object? successMessage = _sentinel,
  }) {
    return FundsState(
      balance: balance ?? this.balance,
      funds: funds ?? this.funds,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      isOperating: isOperating ?? this.isOperating,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
      successMessage: successMessage == _sentinel
          ? this.successMessage
          : successMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    balance,
    funds,
    transactions,
    isLoading,
    isOperating,
    errorMessage,
    successMessage,
  ];
}

const Object _sentinel = Object();
