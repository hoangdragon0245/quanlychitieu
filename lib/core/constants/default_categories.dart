class DefaultCategoryItem {
  final String id;
  final String name;
  final String type; // 'expense' or 'income'
  final String iconCode;
  final String colorHex;

  const DefaultCategoryItem({
    required this.id,
    required this.name,
    required this.type,
    required this.iconCode,
    required this.colorHex,
  });
}

class DefaultCategories {
  static const List<DefaultCategoryItem> expenses = [
    DefaultCategoryItem(
      id: 'cat_food',
      name: 'Ăn uống',
      type: 'expense',
      iconCode: 'cart_fill',
      colorHex: '#FF9500',
    ),
    DefaultCategoryItem(
      id: 'cat_transport',
      name: 'Di chuyển',
      type: 'expense',
      iconCode: 'car_fill',
      colorHex: '#007AFF',
    ),
    DefaultCategoryItem(
      id: 'cat_shopping',
      name: 'Mua sắm',
      type: 'expense',
      iconCode: 'bag_fill',
      colorHex: '#FF2D55',
    ),
    DefaultCategoryItem(
      id: 'cat_bills',
      name: 'Hóa đơn & Tiện ích',
      type: 'expense',
      iconCode: 'bolt_fill',
      colorHex: '#FFCC00',
    ),
    DefaultCategoryItem(
      id: 'cat_housing',
      name: 'Nhà cửa',
      type: 'expense',
      iconCode: 'house_fill',
      colorHex: '#5856D6',
    ),
    DefaultCategoryItem(
      id: 'cat_entertainment',
      name: 'Giải trí',
      type: 'expense',
      iconCode: 'game_controller_solid',
      colorHex: '#AF52DE',
    ),
    DefaultCategoryItem(
      id: 'cat_medical',
      name: 'Sức khỏe & Y tế',
      type: 'expense',
      iconCode: 'heart_fill',
      colorHex: '#FF3B30',
    ),
    DefaultCategoryItem(
      id: 'cat_education',
      name: 'Học tập',
      type: 'expense',
      iconCode: 'book_fill',
      colorHex: '#00C7BE',
    ),
    DefaultCategoryItem(
      id: 'cat_other_expense',
      name: 'Khoản chi khác',
      type: 'expense',
      iconCode: 'ellipsis_circle_fill',
      colorHex: '#8E8E93',
    ),
  ];

  static const List<DefaultCategoryItem> incomes = [
    DefaultCategoryItem(
      id: 'cat_salary',
      name: 'Tiền lương',
      type: 'income',
      iconCode: 'money_dollar_circle_fill',
      colorHex: '#34C759',
    ),
    DefaultCategoryItem(
      id: 'cat_bonus',
      name: 'Tiền thưởng',
      type: 'income',
      iconCode: 'gift_fill',
      colorHex: '#FF9500',
    ),
    DefaultCategoryItem(
      id: 'cat_investment',
      name: 'Đầu tư & Lãi',
      type: 'income',
      iconCode: 'graph_circle_fill',
      colorHex: '#007AFF',
    ),
    DefaultCategoryItem(
      id: 'cat_allowance',
      name: 'Thu nhập phụ',
      type: 'income',
      iconCode: 'creditcard_fill',
      colorHex: '#AF52DE',
    ),
    DefaultCategoryItem(
      id: 'cat_other_income',
      name: 'Thu nhập khác',
      type: 'income',
      iconCode: 'plus_circle_fill',
      colorHex: '#30B0C7',
    ),
  ];
}
