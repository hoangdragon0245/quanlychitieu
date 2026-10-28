class WalletModel {
  final String id;
  final String name;
  final String type; // 'cash', 'bank', 'ewallet'
  final double initialBalance;
  final double currentBalance;
  final String icon;
  final String colorHex;
  final DateTime createdAt;

  WalletModel({
    required this.id,
    required this.name,
    required this.type,
    required this.initialBalance,
    required this.currentBalance,
    required this.icon,
    required this.colorHex,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'initial_balance': initialBalance,
      'current_balance': currentBalance,
      'icon': icon,
      'color_hex': colorHex,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      initialBalance: (map['initial_balance'] as num).toDouble(),
      currentBalance: (map['current_balance'] as num).toDouble(),
      icon: map['icon'] as String,
      colorHex: map['color_hex'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  WalletModel copyWith({
    String? id,
    String? name,
    String? type,
    double? initialBalance,
    double? currentBalance,
    String? icon,
    String? colorHex,
    DateTime? createdAt,
  }) {
    return WalletModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      initialBalance: initialBalance ?? this.initialBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
