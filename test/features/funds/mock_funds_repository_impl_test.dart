import 'package:dashboard/src/features/funds/data/repositories/mock_funds_repository_impl.dart';
import 'package:dashboard/src/features/funds/domain/models/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockFundsRepositoryImpl repo;

  setUp(() => repo = MockFundsRepositoryImpl());

  group('MockFundsRepositoryImpl', () {
    // ── estado inicial ───────────────────────────────────────────────────────

    group('estado inicial', () {
      test('getUserBalance devuelve 500.000', () async {
        expect(await repo.getUserBalance(), 500000.0);
      });

      test('getFunds devuelve 5 fondos sin suscribir', () async {
        final funds = await repo.getFunds();
        expect(funds.length, 5);
        expect(funds.every((f) => !f.isSubscribed), isTrue);
      });

      test('getTransactions devuelve lista vacía', () async {
        expect(await repo.getTransactions(), isEmpty);
      });
    });

    // ── subscribeFund — éxito ────────────────────────────────────────────────

    group('subscribeFund — éxito', () {
      test(
        'descuenta el monto del saldo y marca el fondo como suscrito',
        () async {
          await repo.subscribeFund(
            fundId: '3', // DEUDAPRIVADA mínimo $50.000
            amount: 75000,
            notificationMethod: NotificationMethod.email,
          );

          expect(await repo.getUserBalance(), 425000.0);
          final fund =
              (await repo.getFunds()).firstWhere((f) => f.id == '3');
          expect(fund.isSubscribed, isTrue);
          expect(fund.subscribedAmount, 75000.0);
        },
      );

      test('registra la transacción de suscripción', () async {
        await repo.subscribeFund(
          fundId: '3',
          amount: 75000,
          notificationMethod: NotificationMethod.sms,
        );

        final txs = await repo.getTransactions();
        expect(txs, hasLength(1));
        expect(txs.first.type, TransactionType.subscription);
        expect(txs.first.fundId, '3');
        expect(txs.first.amount, 75000.0);
        expect(
          txs.first.notificationMethod,
          NotificationMethod.sms,
        );
      });
    });

    // ── subscribeFund — errores ──────────────────────────────────────────────

    group('subscribeFund — errores', () {
      test(
        'lanza excepción cuando el saldo es menor al mínimo del fondo',
        () async {
          // Suscribirse 4 veces para consumir casi todo el saldo
          // FPV_BTG_PACTUAL_RECAUDADORA $75k
          await repo.subscribeFund(
            fundId: '1',
            amount: 75000,
            notificationMethod: NotificationMethod.email,
          );
          // DEUDAPRIVADA $50k — saldo 425k → 375k
          await repo.subscribeFund(
            fundId: '3',
            amount: 50000,
            notificationMethod: NotificationMethod.email,
          );
          // FPV_BTG_PACTUAL_DINAMICA $100k — saldo 375k → 275k
          await repo.subscribeFund(
            fundId: '5',
            amount: 100000,
            notificationMethod: NotificationMethod.email,
          );
          // FDO-ACCIONES $250k — saldo 275k → 25k
          await repo.subscribeFund(
            fundId: '4',
            amount: 250000,
            notificationMethod: NotificationMethod.email,
          );
          // Saldo restante 25k < mínimo FPV_ECOPETROL ($125k)
          expect(
            () => repo.subscribeFund(
              fundId: '2',
              amount: 125000,
              notificationMethod: NotificationMethod.email,
            ),
            throwsException,
          );
        },
      );

      test(
        'lanza excepción cuando el monto ingresado es menor al mínimo',
        () {
          expect(
            () => repo.subscribeFund(
              fundId: '3', // mínimo $50.000
              amount: 10000,
              notificationMethod: NotificationMethod.email,
            ),
            throwsException,
          );
        },
      );

      test(
        'lanza excepción cuando el monto supera el saldo disponible',
        () {
          expect(
            () => repo.subscribeFund(
              fundId: '1',
              amount: 600000, // mayor al saldo de $500k
              notificationMethod: NotificationMethod.email,
            ),
            throwsException,
          );
        },
      );

      test('lanza excepción al suscribirse a un fondo ya suscrito', () async {
        await repo.subscribeFund(
          fundId: '3',
          amount: 50000,
          notificationMethod: NotificationMethod.email,
        );
        expect(
          () => repo.subscribeFund(
            fundId: '3',
            amount: 50000,
            notificationMethod: NotificationMethod.email,
          ),
          throwsException,
        );
      });

      test('lanza excepción con fondo inexistente', () {
        expect(
          () => repo.subscribeFund(
            fundId: 'no-existe',
            amount: 100000,
            notificationMethod: NotificationMethod.email,
          ),
          throwsException,
        );
      });
    });

    // ── cancelFund — éxito ───────────────────────────────────────────────────

    group('cancelFund — éxito', () {
      test('reintegra el monto al saldo y desmarca el fondo', () async {
        await repo.subscribeFund(
          fundId: '3',
          amount: 75000,
          notificationMethod: NotificationMethod.email,
        );
        await repo.cancelFund('3');

        expect(await repo.getUserBalance(), 500000.0);
        final fund =
            (await repo.getFunds()).firstWhere((f) => f.id == '3');
        expect(fund.isSubscribed, isFalse);
        expect(fund.subscribedAmount, isNull);
      });

      test('registra la transacción de cancelación', () async {
        await repo.subscribeFund(
          fundId: '3',
          amount: 75000,
          notificationMethod: NotificationMethod.email,
        );
        await repo.cancelFund('3');

        final txs = await repo.getTransactions();
        expect(txs, hasLength(2));
        // getTransactions devuelve en orden inverso
        expect(txs.first.type, TransactionType.cancellation);
        expect(txs.first.amount, 75000.0);
      });
    });

    // ── cancelFund — errores ─────────────────────────────────────────────────

    group('cancelFund — errores', () {
      test('lanza excepción al cancelar un fondo no suscrito', () {
        expect(() => repo.cancelFund('3'), throwsException);
      });

      test('lanza excepción con fondo inexistente', () {
        expect(() => repo.cancelFund('no-existe'), throwsException);
      });
    });

    // ── getTransactions — orden ──────────────────────────────────────────────

    group('getTransactions — orden', () {
      test('devuelve las transacciones en orden cronológico inverso', () async {
        await repo.subscribeFund(
          fundId: '3',
          amount: 50000,
          notificationMethod: NotificationMethod.email,
        );
        await repo.subscribeFund(
          fundId: '1',
          amount: 75000,
          notificationMethod: NotificationMethod.email,
        );

        final txs = await repo.getTransactions();
        expect(txs.length, 2);
        // La más reciente (id 'tx-2') debe aparecer primera
        expect(txs.first.fundId, '1');
        expect(txs.last.fundId, '3');
      });
    });
  });
}
