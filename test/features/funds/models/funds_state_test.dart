import 'package:dashboard/src/features/funds/domain/models/fund_model.dart';
import 'package:dashboard/src/features/funds/domain/models/transaction_model.dart';
import 'package:dashboard/src/features/funds/presentation/state/funds_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tFund = FundModel(
    id: '1',
    name: 'TEST',
    minAmount: 50000,
    category: 'FPV',
  );
  final tTx = TransactionModel(
    id: 'tx-1',
    fundId: '1',
    fundName: 'TEST',
    type: TransactionType.subscription,
    amount: 50000,
    date: DateTime(2026),
  );

  group('FundsState', () {
    // ── valores por defecto ───────────────────────────────────────────────

    group('valores por defecto', () {
      test('construye con valores iniciales correctos', () {
        const state = FundsState();
        expect(state.balance, 500000.0);
        expect(state.funds, isEmpty);
        expect(state.transactions, isEmpty);
        expect(state.isLoading, isFalse);
        expect(state.isOperating, isFalse);
        expect(state.errorMessage, isNull);
        expect(state.successMessage, isNull);
      });
    });

    // ── copyWith ──────────────────────────────────────────────────────────

    group('copyWith', () {
      test('sin argumentos preserva todos los valores', () {
        final state = FundsState(
          balance: 300000,
          funds: [tFund],
          transactions: [tTx],
          isLoading: true,
          isOperating: true,
          errorMessage: 'error',
          successMessage: 'ok',
        );
        final copy = state.copyWith();
        expect(copy.balance, state.balance);
        expect(copy.funds, state.funds);
        expect(copy.transactions, state.transactions);
        expect(copy.isLoading, state.isLoading);
        expect(copy.isOperating, state.isOperating);
        expect(copy.errorMessage, state.errorMessage);
        expect(copy.successMessage, state.successMessage);
      });

      test('actualiza balance, isLoading e isOperating', () {
        const state = FundsState();
        final copy = state.copyWith(
          balance: 250000,
          isLoading: true,
          isOperating: true,
        );
        expect(copy.balance, 250000.0);
        expect(copy.isLoading, isTrue);
        expect(copy.isOperating, isTrue);
      });

      test(
        'errorMessage: null explícito limpia el campo '
        '(patrón sentinel)',
        () {
          const state = FundsState(errorMessage: 'fallo');
          final copy = state.copyWith(errorMessage: null);
          expect(copy.errorMessage, isNull);
        },
      );

      test(
        'successMessage: null explícito limpia el campo '
        '(patrón sentinel)',
        () {
          const state = FundsState(successMessage: 'ok');
          final copy = state.copyWith(successMessage: null);
          expect(copy.successMessage, isNull);
        },
      );

      test(
        'omitir errorMessage en copyWith preserva el valor existente',
        () {
          const state = FundsState(errorMessage: 'fallo');
          final copy = state.copyWith(balance: 100000);
          expect(copy.errorMessage, 'fallo');
        },
      );

      test(
        'omitir successMessage en copyWith preserva el valor existente',
        () {
          const state = FundsState(successMessage: 'ok');
          final copy = state.copyWith(balance: 100000);
          expect(copy.successMessage, 'ok');
        },
      );
    });

    // ── Equatable ─────────────────────────────────────────────────────────

    group('Equatable', () {
      test('dos instancias con mismos valores son iguales', () {
        const a = FundsState(balance: 400000);
        const b = FundsState(balance: 400000);
        expect(a, equals(b));
      });

      test('instancias con distinto balance no son iguales', () {
        const a = FundsState(balance: 400000);
        const b = FundsState(balance: 300000);
        expect(a, isNot(equals(b)));
      });

      test('instancias con distinto errorMessage no son iguales', () {
        const a = FundsState(errorMessage: 'err');
        const b = FundsState();
        expect(a, isNot(equals(b)));
      });

      test('props incluye todos los campos relevantes', () {
        final state = FundsState(
          balance: 100000,
          funds: [tFund],
          transactions: [tTx],
          isLoading: true,
          errorMessage: 'e',
          successMessage: 's',
        );
        expect(
          state.props,
          [
            100000.0,
            [tFund],
            [tTx],
            true,
            false,
            'e',
            's',
          ],
        );
      });
    });
  });
}
