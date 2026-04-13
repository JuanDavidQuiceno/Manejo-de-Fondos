import 'package:dashboard/src/features/funds/domain/models/fund_model.dart';
import 'package:dashboard/src/features/funds/presentation/widgets/fund_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final _unsubscribed = FundModel(
  id: '1',
  name: 'FPV_BTG_PACTUAL_RECAUDADORA',
  minAmount: 75000,
  category: 'FPV',
);

final _subscribed = FundModel(
  id: '1',
  name: 'FPV_BTG_PACTUAL_RECAUDADORA',
  minAmount: 75000,
  category: 'FPV',
  isSubscribed: true,
  subscribedAmount: 75000,
);

Widget _build(
  FundModel fund, {
  VoidCallback? onSubscribe,
  VoidCallback? onCancel,
  Size size = const Size(1200, 800),
}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: Scaffold(
        body: FundCard(
          fund: fund,
          onSubscribe: onSubscribe ?? () {},
          onCancel: onCancel ?? () {},
        ),
      ),
    ),
  );
}

void main() {
  group('FundCard', () {
    // ── badge de categoría ────────────────────────────────────────────────

    testWidgets('muestra el badge de categoría "FPV"', (tester) async {
      await tester.pumpWidget(_build(_unsubscribed));
      expect(find.text('FPV'), findsOneWidget);
    });

    // ── fondo no suscrito ─────────────────────────────────────────────────

    group('no suscrito', () {
      testWidgets('muestra botón "Suscribirse"', (tester) async {
        await tester.pumpWidget(_build(_unsubscribed));
        expect(find.text('Suscribirse'), findsOneWidget);
      });

      testWidgets('no muestra chip "Suscrito"', (tester) async {
        await tester.pumpWidget(_build(_unsubscribed));
        expect(find.text('Suscrito'), findsNothing);
      });

      testWidgets('llama onSubscribe al presionar el botón', (tester) async {
        var called = false;
        await tester.pumpWidget(
          _build(_unsubscribed, onSubscribe: () => called = true),
        );
        await tester.tap(find.text('Suscribirse'));
        expect(called, isTrue);
      });
    });

    // ── fondo suscrito ────────────────────────────────────────────────────

    group('suscrito', () {
      testWidgets('muestra chip "Suscrito" en mobile', (tester) async {
        await tester.pumpWidget(
          _build(_subscribed, size: const Size(400, 800)),
        );
        expect(find.text('Suscrito'), findsOneWidget);
      });

      testWidgets(
        'muestra el monto suscrito formateado',
        (tester) async {
          await tester.pumpWidget(_build(_subscribed));
          expect(find.textContaining('75.000'), findsWidgets);
        },
      );

      testWidgets('llama onCancel al presionar "Cancelar"', (tester) async {
        var called = false;
        await tester.pumpWidget(
          _build(_subscribed, onCancel: () => called = true),
        );
        // Desktop muestra "Cancelar", mobile muestra "Cancelar participación"
        final cancelFinder = find.textContaining('Cancelar');
        expect(cancelFinder, findsOneWidget);
        await tester.tap(cancelFinder);
        expect(called, isTrue);
      });
    });

    // ── layout responsivo ─────────────────────────────────────────────────

    group('layout responsivo', () {
      testWidgets(
        'desktop (≥ 800 px): layout horizontal con Row',
        (tester) async {
          await tester.pumpWidget(_build(_unsubscribed));
          // En desktop, fondo name y botón están en una Row
          expect(find.byType(Row), findsWidgets);
        },
      );

      testWidgets(
        'mobile (< 800 px): muestra "Cancelar participación"',
        (tester) async {
          await tester.pumpWidget(
            _build(_subscribed, size: const Size(400, 800)),
          );
          expect(find.text('Cancelar participación'), findsOneWidget);
        },
      );
    });
  });
}
