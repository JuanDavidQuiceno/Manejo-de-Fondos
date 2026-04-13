import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/src/features/funds/domain/models/fund_model.dart';
import 'package:dashboard/src/features/funds/domain/models/transaction_model.dart';
import 'package:dashboard/src/features/funds/domain/repositories/funds_repository.dart';
import 'package:dashboard/src/features/funds/presentation/state/funds_cubit.dart';
import 'package:dashboard/src/features/funds/presentation/state/funds_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ── Mock ─────────────────────────────────────────────────────────────────────

class MockFundsRepository extends Mock implements FundsRepository {}

// ── Fixtures ─────────────────────────────────────────────────────────────────

final _tFunds = [
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

final _tDate = DateTime(2026, 1, 1);

TransactionModel _tTx({
  String id = 'tx-1',
  TransactionType type = TransactionType.cancellation,
  double amount = 75000,
}) => TransactionModel(
      id: id,
      fundId: '3',
      fundName: 'DEUDAPRIVADA',
      type: type,
      amount: amount,
      date: _tDate,
      notificationMethod: NotificationMethod.email,
    );

// ── Helper ───────────────────────────────────────────────────────────────────

/// Stubs the three read methods so that loadData() succeeds.
void _stubRead(
  MockFundsRepository repo, {
  double balance = 500000,
  List<FundModel>? funds,
  List<TransactionModel>? transactions,
}) {
  when(() => repo.getUserBalance()).thenAnswer((_) async => balance);
  when(() => repo.getFunds()).thenAnswer((_) async => funds ?? _tFunds);
  when(
    () => repo.getTransactions(),
  ).thenAnswer((_) async => transactions ?? []);
}

void main() {
  // Register fallback values for types used with any(named:).
  setUpAll(() {
    registerFallbackValue(NotificationMethod.email);
  });

  late MockFundsRepository repository;

  setUp(() {
    repository = MockFundsRepository();
  });

  FundsCubit buildCubit() => FundsCubit(repository: repository);

  group('FundsCubit', () {
    // ── loadData ─────────────────────────────────────────────────────────────

    group('loadData', () {
      blocTest<FundsCubit, FundsState>(
        r'emite [isLoading:true] luego saldo $500.000 y 5 fondos sin suscribir',
        build: () {
          _stubRead(repository);
          return buildCubit();
        },
        act: (c) => c.loadData(),
        expect: () => [
          isA<FundsState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FundsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.balance, 'balance', 500000.0)
              .having((s) => s.funds.length, 'funds count', 5)
              .having(
                (s) => s.funds.every((f) => !f.isSubscribed),
                'ninguno suscrito',
                true,
              )
              .having((s) => s.transactions, 'transactions', isEmpty),
        ],
      );

      blocTest<FundsCubit, FundsState>(
        'cuando el repositorio lanza excepción emite errorMessage',
        build: () {
          when(
            () => repository.getUserBalance(),
          ).thenThrow(Exception('Sin conexión'));
          return buildCubit();
        },
        act: (c) => c.loadData(),
        expect: () => [
          isA<FundsState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FundsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having(
                (s) => s.errorMessage,
                'errorMessage',
                'Sin conexión',
              ),
        ],
      );
    });

    // ── subscribe ────────────────────────────────────────────────────────────

    group('subscribe', () {
      blocTest<FundsCubit, FundsState>(
        'con saldo suficiente: descuenta saldo, fondo suscrito, '
        'successMessage no nulo',
        build: () {
          _stubRead(repository);
          when(
            () => repository.subscribeFund(
              fundId: any(named: 'fundId'),
              amount: any(named: 'amount'),
              notificationMethod: any(named: 'notificationMethod'),
            ),
          ).thenAnswer((_) async {});
          // _reload después de suscripción exitosa
          final subscribedFund = _tFunds[2].copyWith(
            isSubscribed: true,
            subscribedAmount: 75000.0,
          );
          final updatedFunds = List<FundModel>.from(_tFunds)
            ..[2] = subscribedFund;
          when(
            () => repository.getUserBalance(),
          ).thenAnswer((_) async => 425000.0);
          when(
            () => repository.getFunds(),
          ).thenAnswer((_) async => updatedFunds);
          when(
            () => repository.getTransactions(),
          ).thenAnswer(
            (_) async => [_tTx(type: TransactionType.subscription)],
          );
          return buildCubit();
        },
        act: (c) async {
          await c.loadData();
          await c.subscribe(
            fundId: '3',
            amount: 75000,
            notificationMethod: NotificationMethod.email,
          );
        },
        verify: (c) {
          expect(c.state.balance, 425000.0);
          expect(
            c.state.funds.firstWhere((f) => f.id == '3').isSubscribed,
            isTrue,
          );
          expect(c.state.successMessage, isNotNull);
          expect(c.state.errorMessage, isNull);
          expect(c.state.transactions, hasLength(1));
          expect(
            c.state.transactions.first.type,
            TransactionType.subscription,
          );
        },
      );

      blocTest<FundsCubit, FundsState>(
        'saldo insuficiente: emite errorMessage y no modifica el saldo',
        build: () {
          _stubRead(repository);
          when(
            () => repository.subscribeFund(
              fundId: any(named: 'fundId'),
              amount: any(named: 'amount'),
              notificationMethod: any(named: 'notificationMethod'),
            ),
          ).thenThrow(
            Exception('Saldo insuficiente para el monto ingresado'),
          );
          return buildCubit();
        },
        act: (c) async {
          await c.loadData();
          await c.subscribe(
            fundId: '4',
            amount: 600000,
            notificationMethod: NotificationMethod.sms,
          );
        },
        verify: (c) {
          expect(c.state.errorMessage, contains('Saldo insuficiente'));
          expect(c.state.balance, 500000.0);
          expect(
            c.state.funds.firstWhere((f) => f.id == '4').isSubscribed,
            isFalse,
          );
        },
      );

      blocTest<FundsCubit, FundsState>(
        'fondo ya suscrito: emite errorMessage "Ya está suscrito"',
        build: () {
          _stubRead(repository);
          when(
            () => repository.subscribeFund(
              fundId: any(named: 'fundId'),
              amount: any(named: 'amount'),
              notificationMethod: any(named: 'notificationMethod'),
            ),
          ).thenThrow(Exception('Ya está suscrito a este fondo'));
          return buildCubit();
        },
        act: (c) async {
          await c.loadData();
          await c.subscribe(
            fundId: '3',
            amount: 75000,
            notificationMethod: NotificationMethod.email,
          );
        },
        verify: (c) {
          expect(c.state.errorMessage, contains('Ya está suscrito'));
        },
      );

      blocTest<FundsCubit, FundsState>(
        'monto menor al mínimo: emite errorMessage del repositorio',
        build: () {
          _stubRead(repository);
          when(
            () => repository.subscribeFund(
              fundId: any(named: 'fundId'),
              amount: any(named: 'amount'),
              notificationMethod: any(named: 'notificationMethod'),
            ),
          ).thenThrow(
            Exception(r'El monto es menor al mínimo requerido: $50000'),
          );
          return buildCubit();
        },
        act: (c) async {
          await c.loadData();
          await c.subscribe(
            fundId: '3',
            amount: 10000,
            notificationMethod: NotificationMethod.email,
          );
        },
        verify: (c) {
          expect(c.state.errorMessage, contains('mínimo'));
          expect(c.state.balance, 500000.0);
        },
      );
    });

    // ── cancel ───────────────────────────────────────────────────────────────

    group('cancel', () {
      blocTest<FundsCubit, FundsState>(
        'fondo suscrito: reintegra el monto y desmarca el fondo',
        build: () {
          _stubRead(repository);
          when(
            () => repository.cancelFund(any()),
          ).thenAnswer((_) async {});
          // _reload después de cancelación exitosa
          when(
            () => repository.getUserBalance(),
          ).thenAnswer((_) async => 500000.0);
          when(
            () => repository.getFunds(),
          ).thenAnswer((_) async => _tFunds);
          when(
            () => repository.getTransactions(),
          ).thenAnswer((_) async => [_tTx()]);
          return buildCubit();
        },
        act: (c) async {
          await c.loadData();
          await c.cancel('3');
        },
        verify: (c) {
          expect(c.state.balance, 500000.0);
          expect(
            c.state.funds.firstWhere((f) => f.id == '3').isSubscribed,
            isFalse,
          );
          expect(c.state.successMessage, isNotNull);
          expect(c.state.errorMessage, isNull);
          expect(
            c.state.transactions.first.type,
            TransactionType.cancellation,
          );
        },
      );

      blocTest<FundsCubit, FundsState>(
        'fondo no suscrito: emite errorMessage "No está suscrito"',
        build: () {
          _stubRead(repository);
          when(
            () => repository.cancelFund(any()),
          ).thenThrow(Exception('No está suscrito a este fondo'));
          return buildCubit();
        },
        act: (c) async {
          await c.loadData();
          await c.cancel('3');
        },
        verify: (c) {
          expect(c.state.errorMessage, contains('No está suscrito'));
          expect(c.state.balance, 500000.0);
        },
      );
    });

    // ── clearMessages ────────────────────────────────────────────────────────

    group('clearMessages', () {
      blocTest<FundsCubit, FundsState>(
        'limpia errorMessage y successMessage del estado',
        build: () {
          _stubRead(repository);
          when(
            () => repository.cancelFund(any()),
          ).thenThrow(Exception('No está suscrito a este fondo'));
          return buildCubit();
        },
        act: (c) async {
          await c.loadData();
          await c.cancel('3'); // genera errorMessage
          c.clearMessages();
        },
        verify: (c) {
          expect(c.state.errorMessage, isNull);
          expect(c.state.successMessage, isNull);
        },
      );
    });
  });
}
