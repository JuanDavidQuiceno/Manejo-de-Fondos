class FundModel {
  FundModel({
    required this.id,
    required this.name,
    required this.minAmount,
    required this.category,
    this.isSubscribed = false,
    this.subscribedAmount,
  });

  final String id;
  final String name;
  final double minAmount;
  final String category; // 'FPV' | 'FIC'
  final bool isSubscribed;
  final double? subscribedAmount;

  FundModel copyWith({
    String? id,
    String? name,
    double? minAmount,
    String? category,
    bool? isSubscribed,
    Object? subscribedAmount = _sentinel,
  }) {
    return FundModel(
      id: id ?? this.id,
      name: name ?? this.name,
      minAmount: minAmount ?? this.minAmount,
      category: category ?? this.category,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      subscribedAmount: subscribedAmount == _sentinel
          ? this.subscribedAmount
          : subscribedAmount as double?,
    );
  }
}

const Object _sentinel = Object();
