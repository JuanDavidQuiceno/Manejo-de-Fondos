import 'package:dashboard/src/features/funds/presentation/widgets/funds_balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _build(double balance) => MaterialApp(
      home: Scaffold(
        body: FundsBalanceCard(balance: balance),
      ),
    );

void main() {
  group('FundsBalanceCard', () {
    testWidgets('muestra la etiqueta "Saldo disponible"', (tester) async {
      await tester.pumpWidget(_build(500000));
      expect(find.text('Saldo disponible'), findsOneWidget);
    });

    testWidgets(
      r'formatea el saldo inicial como "COP $ 500.000"',
      (tester) async {
        await tester.pumpWidget(_build(500000));
        expect(find.textContaining('500.000'), findsOneWidget);
      },
    );

    testWidgets(
      'muestra el nuevo saldo cuando cambia el valor',
      (tester) async {
        await tester.pumpWidget(_build(425000));
        expect(find.textContaining('425.000'), findsOneWidget);
      },
    );

    testWidgets('no muestra texto de saldo anterior tras rebuild', (
      tester,
    ) async {
      await tester.pumpWidget(_build(500000));
      await tester.pumpWidget(_build(300000));
      expect(find.textContaining('500.000'), findsNothing);
      expect(find.textContaining('300.000'), findsOneWidget);
    });
  });
}
