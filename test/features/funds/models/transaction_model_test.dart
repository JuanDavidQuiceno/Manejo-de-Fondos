import 'package:dashboard/src/features/funds/domain/models/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationMethod', () {
    test('email.label devuelve "Email"', () {
      expect(NotificationMethod.email.label, 'Email');
    });

    test('sms.label devuelve "SMS"', () {
      expect(NotificationMethod.sms.label, 'SMS');
    });
  });

  group('TransactionType', () {
    test('contiene subscription y cancellation', () {
      expect(TransactionType.values, [
        TransactionType.subscription,
        TransactionType.cancellation,
      ]);
    });
  });

  group('TransactionModel', () {
    test('almacena todos los campos correctamente', () {
      final date = DateTime(2026);
      final tx = TransactionModel(
        id: 'tx-1',
        fundId: '3',
        fundName: 'DEUDAPRIVADA',
        type: TransactionType.subscription,
        amount: 75000,
        date: date,
        notificationMethod: NotificationMethod.sms,
      );

      expect(tx.id, 'tx-1');
      expect(tx.fundId, '3');
      expect(tx.fundName, 'DEUDAPRIVADA');
      expect(tx.type, TransactionType.subscription);
      expect(tx.amount, 75000.0);
      expect(tx.date, date);
      expect(tx.notificationMethod, NotificationMethod.sms);
    });

    test('notificationMethod es null por defecto', () {
      final tx = TransactionModel(
        id: 'tx-1',
        fundId: '3',
        fundName: 'DEUDAPRIVADA',
        type: TransactionType.cancellation,
        amount: 75000,
        date: DateTime(2026),
      );
      expect(tx.notificationMethod, isNull);
    });
  });
}
