enum TransactionType { subscription, cancellation }

enum NotificationMethod { email, sms }

extension NotificationMethodX on NotificationMethod {
  String get label => this == NotificationMethod.email ? 'Email' : 'SMS';
}

class TransactionModel {
  TransactionModel({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.type,
    required this.amount,
    required this.date,
    this.notificationMethod,
  });

  final String id;
  final String fundId;
  final String fundName;
  final TransactionType type;
  final double amount;
  final DateTime date;
  final NotificationMethod? notificationMethod;
}
