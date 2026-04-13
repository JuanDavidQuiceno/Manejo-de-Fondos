import 'package:dashboard/src/features/funds/domain/models/transaction_model.dart';
import 'package:dashboard/src/features/funds/presentation/widgets/transactions_history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

final _subscription = TransactionModel(
  id: 'tx-1',
  fundId: '3',
  fundName: 'DEUDAPRIVADA',
  type: TransactionType.subscription,
  amount: 75000,
  date: DateTime(2026),
  notificationMethod: NotificationMethod.email,
);

final _cancellation = TransactionModel(
  id: 'tx-2',
  fundId: '3',
  fundName: 'DEUDAPRIVADA',
  type: TransactionType.cancellation,
  amount: 75000,
  date: DateTime(2026),
);

Widget _build(List<TransactionModel> transactions) => MaterialApp(
      home: Scaffold(
        body: TransactionsHistoryView(transactions: transactions),
      ),
    );

void main() {
  // DateFormat('dd/MM/yyyy HH:mm', 'es_CO') requiere inicialización de locale.
  setUpAll(() => initializeDateFormatting('es_CO'));

  group('TransactionsHistoryView', () {
    // ── estado vacío ──────────────────────────────────────────────────────

    testWidgets(
      'lista vacía muestra "Sin transacciones aún"',
      (tester) async {
        await tester.pumpWidget(_build([]));
        expect(find.text('Sin transacciones aún'), findsOneWidget);
        expect(find.byType(ListView), findsNothing);
      },
    );

    // ── con transacciones ─────────────────────────────────────────────────

    testWidgets('muestra el nombre del fondo de cada transacción', (
      tester,
    ) async {
      await tester.pumpWidget(_build([_subscription]));
      expect(find.text('DEUDAPRIVADA'), findsOneWidget);
    });

    testWidgets('suscripción muestra la etiqueta "Suscripción"', (
      tester,
    ) async {
      await tester.pumpWidget(_build([_subscription]));
      expect(find.text('Suscripción'), findsOneWidget);
    });

    testWidgets('cancelación muestra la etiqueta "Cancelación"', (
      tester,
    ) async {
      await tester.pumpWidget(_build([_cancellation]));
      expect(find.text('Cancelación'), findsOneWidget);
    });

    testWidgets(
      'suscripción muestra el monto con signo "-"',
      (tester) async {
        await tester.pumpWidget(_build([_subscription]));
        expect(find.textContaining('- '), findsOneWidget);
      },
    );

    testWidgets(
      'cancelación muestra el monto con signo "+"',
      (tester) async {
        await tester.pumpWidget(_build([_cancellation]));
        expect(find.textContaining('+ '), findsOneWidget);
      },
    );

    testWidgets(
      'suscripción con email muestra "Notif. por Email"',
      (tester) async {
        await tester.pumpWidget(_build([_subscription]));
        expect(find.textContaining('Notif. por Email'), findsOneWidget);
      },
    );

    testWidgets(
      'cancelación sin método de notificación no muestra "Notif."',
      (tester) async {
        await tester.pumpWidget(_build([_cancellation]));
        expect(find.textContaining('Notif.'), findsNothing);
      },
    );

    testWidgets('renderiza todas las transacciones de la lista', (
      tester,
    ) async {
      await tester.pumpWidget(
        _build([_subscription, _cancellation]),
      );
      expect(find.byType(ListTile), findsNWidgets(2));
    });
  });
}
