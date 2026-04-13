import 'package:dashboard/src/features/funds/domain/models/fund_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FundModel', () {
    final base = FundModel(
      id: '1',
      name: 'TEST_FUND',
      minAmount: 50000,
      category: 'FPV',
    );

    // ── copyWith ─────────────────────────────────────────────────────────────

    group('copyWith', () {
      test('sin argumentos devuelve objeto con los mismos valores', () {
        final copy = base.copyWith();
        expect(copy.id, base.id);
        expect(copy.name, base.name);
        expect(copy.minAmount, base.minAmount);
        expect(copy.category, base.category);
        expect(copy.isSubscribed, base.isSubscribed);
        expect(copy.subscribedAmount, base.subscribedAmount);
      });

      test('actualiza id, name, minAmount y category correctamente', () {
        final copy = base.copyWith(
          id: '99',
          name: 'NUEVO',
          minAmount: 99000,
          category: 'FIC',
        );
        expect(copy.id, '99');
        expect(copy.name, 'NUEVO');
        expect(copy.minAmount, 99000);
        expect(copy.category, 'FIC');
      });

      test(
        'copyWith(isSubscribed: true, subscribedAmount: 75000) '
        'marca el fondo como suscrito',
        () {
          final copy = base.copyWith(
            isSubscribed: true,
            subscribedAmount: 75000.0,
          );
          expect(copy.isSubscribed, isTrue);
          expect(copy.subscribedAmount, 75000.0);
        },
      );

      test(
        'copyWith(isSubscribed: false) limpia subscribedAmount '
        'mediante el patrón sentinel (null explícito)',
        () {
          final subscribed = base.copyWith(
            isSubscribed: true,
            subscribedAmount: 75000.0,
          );
          // Al cancelar: isSubscribed false y subscribedAmount null
          final cancelled = subscribed.copyWith(
            isSubscribed: false,
            subscribedAmount: null,
          );
          expect(cancelled.isSubscribed, isFalse);
          expect(cancelled.subscribedAmount, isNull);
        },
      );

      test(
        'omitir subscribedAmount en copyWith preserva el valor existente',
        () {
          final subscribed = base.copyWith(
            isSubscribed: true,
            subscribedAmount: 75000.0,
          );
          // Solo cambia name, subscribedAmount debe conservarse
          final copy = subscribed.copyWith(name: 'OTRO');
          expect(copy.subscribedAmount, 75000.0);
        },
      );
    });

    // ── valores por defecto ──────────────────────────────────────────────────

    group('valores por defecto', () {
      test('isSubscribed es false al construir', () {
        expect(base.isSubscribed, isFalse);
      });

      test('subscribedAmount es null al construir', () {
        expect(base.subscribedAmount, isNull);
      });
    });
  });
}
