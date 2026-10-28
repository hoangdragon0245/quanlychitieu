class TransactionModel {
  final String id;
  final double amount;
  final String type; // 'expense', 'income', 'transfer'
  final String? categoryId;
  final String walletId;
  final String? toWalletId;
  final DateTime dateTime;
  final String? note;
  final String? imagePath;
  final DateTime createdAt;

  // Joined fields for display
  final String? categoryName;
  final String? categoryIcon;
  final String? categoryColor;
  final String? walletName;
  final String? toWalletName;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    this.categoryId,
    required this.walletId,
    this.toWalletId,
    required this.dateTime,
    this.note,
    this.imagePath,
    required this.createdAt,
    this.categoryName,
    this.categoryIcon,
    this.categoryColor,
    this.walletName,
    this.toWalletName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'category_id': categoryId,
      'wallet_id': walletId,
      'to_wallet_id': toWalletId,
      'date_time': dateTime.toIso8601String(),
      'note': note,
      'image_path': imagePath,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: map['type'] as String,
      categoryId: map['category_id'] as String?,
      walletId: map['wallet_id'] as String,
      toWalletId: map['to_wallet_id'] as String?,
      dateTime: DateTime.parse(map['date_time'] as String),
      note: map['note'] as String?,
      imagePath: map['image_path'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      categoryName: map['category_name'] as String?,
      categoryIcon: map['category_icon'] as String?,
      categoryColor: map['category_color'] as String?,
      walletName: map['wallet_name'] as String?,
      toWalletName: map['to_wallet_name'] as String?,
    );
  }
}
