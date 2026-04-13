import 'package:dashboard/src/features/funds/domain/models/fund_model.dart';
import 'package:dashboard/src/features/funds/domain/models/transaction_model.dart';
import 'package:dashboard/src/features/funds/domain/repositories/funds_repository.dart';

class MockFundsRepositoryImpl implements FundsRepository {
  MockFundsRepositoryImpl() {
    _funds = [
      FundModel(
        id: '1',
        name: 'FPV_BTG_PACTUAL_RECAUDADORA',
        minAmount: 75000,
        category: 'FPV',
      ),
      FundModel(
        id: '2',
        name: 'FPV_BTG_PACTUAL_ECOPETROL',
        minAmount: 125000,
        category: 'FPV',
      ),
      FundModel(
        id: '3',
        name: 'DEUDAPRIVADA',
        minAmount: 50000,
        category: 'FIC',
      ),
      FundModel(
        id: '4',
        name: 'FDO-ACCIONES',
        minAmount: 250000,
        category: 'FIC',
      ),
      FundModel(
        id: '5',
        name: 'FPV_BTG_PACTUAL_DINAMICA',
        minAmount: 100000,
        category: 'FPV',
      ),
    ];
  }

  double _balance = 500000;
  late List<FundModel> _funds;
  final List<TransactionModel> _transactions = [];
  int _txCounter = 0;

  @override
  Future<double> getUserBalance() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _balance;
  }

  @override
  Future<List<FundModel>> getFunds() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_funds);
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_transactions.reversed.toList());
  }

  @override
  Future<void> subscribeFund({
    required String fundId,
    required double amount,
    required NotificationMethod notificationMethod,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final index = _funds.indexWhere((f) => f.id == fundId);
    if (index == -1) throw Exception('Fondo no encontrado');

    final fund = _funds[index];

    if (fund.isSubscribed) {
      throw Exception('Ya está suscrito a este fondo');
    }

    if (_balance < fund.minAmount) {
      throw Exception(
        'No tiene saldo suficiente. Saldo actual: '
        '\$${_balance.toStringAsFixed(0)}. '
        'Monto mínimo requerido: \$${fund.minAmount.toStringAsFixed(0)}',
      );
    }

    if (amount < fund.minAmount) {
      throw Exception(
        'El monto es menor al mínimo requerido: '
        '\$${fund.minAmount.toStringAsFixed(0)}',
      );
    }

    if (amount > _balance) {
      throw Exception('Saldo insuficiente para el monto ingresado');
    }

    _balance -= amount;
    _funds[index] = fund.copyWith(
      isSubscribed: true,
      subscribedAmount: amount,
    );
    _transactions.add(
      TransactionModel(
        id: 'tx-${++_txCounter}',
        fundId: fundId,
        fundName: fund.name,
        type: TransactionType.subscription,
        amount: amount,
        date: DateTime.now(),
        notificationMethod: notificationMethod,
      ),
    );
  }

  @override
  Future<void> cancelFund(String fundId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final index = _funds.indexWhere((f) => f.id == fundId);
    if (index == -1) throw Exception('Fondo no encontrado');

    final fund = _funds[index];
    if (!fund.isSubscribed) {
      throw Exception('No está suscrito a este fondo');
    }

    final refund = fund.subscribedAmount ?? 0;
    _balance += refund;
    _funds[index] = fund.copyWith(
      isSubscribed: false,
      subscribedAmount: null,
    );
    _transactions.add(
      TransactionModel(
        id: 'tx-${++_txCounter}',
        fundId: fundId,
        fundName: fund.name,
        type: TransactionType.cancellation,
        amount: refund,
        date: DateTime.now(),
      ),
    );
  }
}
