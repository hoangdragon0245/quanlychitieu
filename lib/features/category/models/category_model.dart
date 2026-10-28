class CategoryModel {
  final String id;
  final String name;
  final String type; // 'expense' or 'income'
  final String icon;
  final String colorHex;
  final bool isDefault;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.colorHex,
    required this.isDefault,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'icon': icon,
      'color_hex': colorHex,
      'is_default': isDefault ? 1 : 0,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      icon: map['icon'] as String,
      colorHex: map['color_hex'] as String,
      isDefault: (map['is_default'] as int) == 1,
    );
  }
}
