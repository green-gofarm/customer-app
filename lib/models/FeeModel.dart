class FeeModel {
  final String type;
  final int amount;

  FeeModel({required this.type, required this.amount});

  factory FeeModel.fromJson(Map<String, dynamic> json) {
    return FeeModel(
      type: json['type'] as String,
      amount: json['amount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
    };
  }

  @override
  String toString() {
    return 'FeeModel(type: $type, amount: $amount)';
  }
}
