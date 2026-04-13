import 'package:dashboard/src/features/funds/presentation/funds_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _build() => const MaterialApp(home: FundsScreen());

void main() {
  group('FundsScreen', () {
    // ── tabs ──────────────────────────────────────────────────────────────

    testWidgets('muestra el tab "Fondos disponibles"', (tester) async {
      await tester.pumpWidget(_build());
      await tester.pumpAndSettle();
      expect(find.text('Fondos disponibles'), findsOneWidget);
    });

    testWidgets('muestra el tab "Historial"', (tester) async {
      await tester.pumpWidget(_build());
      await tester.pumpAndSettle();
      expect(find.text('Historial'), findsOneWidget);
    });

    testWidgets(
      'tab "Fondos disponibles" muestra los fondos tras cargar',
      (tester) async {
        await tester.pumpWidget(_build());
        await tester.pumpAndSettle();
        expect(find.text('FPV_BTG_PACTUAL_RECAUDADORA'), findsOneWidget);
      },
    );

    testWidgets(
      'tab "Fondos disponibles" muestra el saldo disponible',
      (tester) async {
        await tester.pumpWidget(_build());
        await tester.pumpAndSettle();
        expect(find.text('Saldo disponible'), findsOneWidget);
      },
    );

    // ── navegación entre tabs ─────────────────────────────────────────────

    testWidgets(
      'al tocar "Historial" muestra "Sin transacciones aún"',
      (tester) async {
        await tester.pumpWidget(_build());
        await tester.pumpAndSettle();
        await tester.tap(find.text('Historial'));
        await tester.pumpAndSettle();
        expect(find.text('Sin transacciones aún'), findsOneWidget);
      },
    );

    testWidgets(
      'al volver a "Fondos disponibles" muestra los fondos',
      (tester) async {
        await tester.pumpWidget(_build());
        await tester.pumpAndSettle();
        await tester.tap(find.text('Historial'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Fondos disponibles'));
        await tester.pumpAndSettle();
        expect(find.text('FPV_BTG_PACTUAL_RECAUDADORA'), findsOneWidget);
      },
    );

    // ── indicador de carga ────────────────────────────────────────────────

    testWidgets(
      'muestra CircularProgressIndicator mientras carga',
      (tester) async {
        await tester.pumpWidget(_build());
        // Un solo pump: isLoading=true, timers aún no han disparado
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        // Drena los timers pendientes antes de que termine el test
        await tester.pumpAndSettle();
      },
    );
  });
}
