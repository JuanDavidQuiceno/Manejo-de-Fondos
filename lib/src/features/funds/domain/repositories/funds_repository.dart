import 'package:dashboard/src/features/funds/domain/models/fund_model.dart';
import 'package:dashboard/src/features/funds/domain/models/transaction_model.dart';

abstract class FundsRepository {
  Future<List<FundModel>> getFunds();
  Future<List<TransactionModel>> getTransactions();
  Future<double> getUserBalance();
  Future<void> subscribeFund({
    required String fundId,
    required double amount,
    required NotificationMethod notificationMethod,
  });
  Future<void> cancelFund(String fundId);
}
