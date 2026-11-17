import 'package:material_ui/material_ui.dart';

/// Seed household categories (Urdu-friendly names kept as requested).
class DefaultCategorySpec {
  const DefaultCategorySpec({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    this.parentId,
    required this.sortOrder,
  });

  final String id;
  final String name;
  final String icon;
  final int color;
  final String type; // income | expense
  final String? parentId;
  final int sortOrder;
}

List<DefaultCategorySpec> defaultCategories() {
  const expense = 'expense';
  const income = 'income';

  return const [
    // Expense
    DefaultCategorySpec(
      id: 'cat-rashan',
      name: 'Rashan',
      icon: 'shopping_cart',
      color: 0xFF2E7D32,
      type: expense,
      sortOrder: 1,
    ),
    DefaultCategorySpec(
      id: 'cat-sabzi',
      name: 'Sabzi',
      icon: 'eco',
      color: 0xFF66BB6A,
      type: expense,
      sortOrder: 2,
    ),
    DefaultCategorySpec(
      id: 'cat-bijli',
      name: 'Bijli',
      icon: 'bolt',
      color: 0xFFF9A825,
      type: expense,
      sortOrder: 3,
    ),
    DefaultCategorySpec(
      id: 'cat-gas',
      name: 'Gas',
      icon: 'local_fire_department',
      color: 0xFFEF6C00,
      type: expense,
      sortOrder: 4,
    ),
    DefaultCategorySpec(
      id: 'cat-kiraya',
      name: 'Kiraya',
      icon: 'home',
      color: 0xFF5D4037,
      type: expense,
      sortOrder: 5,
    ),
    DefaultCategorySpec(
      id: 'cat-school',
      name: 'School Fees',
      icon: 'school',
      color: 0xFF1565C0,
      type: expense,
      sortOrder: 6,
    ),
    DefaultCategorySpec(
      id: 'cat-dawai',
      name: 'Dawai',
      icon: 'medical_services',
      color: 0xFFC62828,
      type: expense,
      sortOrder: 7,
    ),
    DefaultCategorySpec(
      id: 'cat-petrol',
      name: 'Petrol',
      icon: 'local_gas_station',
      color: 0xFF455A64,
      type: expense,
      sortOrder: 8,
    ),
    DefaultCategorySpec(
      id: 'cat-internet',
      name: 'Internet',
      icon: 'wifi',
      color: 0xFF0277BD,
      type: expense,
      sortOrder: 9,
    ),
    DefaultCategorySpec(
      id: 'cat-mobile',
      name: 'Mobile Load',
      icon: 'phone_android',
      color: 0xFF00838F,
      type: expense,
      sortOrder: 10,
    ),
    DefaultCategorySpec(
      id: 'cat-eid',
      name: 'Eid/Shopping',
      icon: 'card_giftcard',
      color: 0xFF6A1B9A,
      type: expense,
      sortOrder: 11,
    ),
    DefaultCategorySpec(
      id: 'cat-transport',
      name: 'Transport',
      icon: 'directions_bus',
      color: 0xFF37474F,
      type: expense,
      sortOrder: 12,
    ),
    DefaultCategorySpec(
      id: 'cat-eating',
      name: 'Eating Out',
      icon: 'restaurant',
      color: 0xFFD84315,
      type: expense,
      sortOrder: 13,
    ),
    DefaultCategorySpec(
      id: 'cat-other-expense',
      name: 'Other Expense',
      icon: 'more_horiz',
      color: 0xFF757575,
      type: expense,
      sortOrder: 99,
    ),
    // Income
    DefaultCategorySpec(
      id: 'cat-salary',
      name: 'Salary',
      icon: 'payments',
      color: 0xFF2E7D32,
      type: income,
      sortOrder: 1,
    ),
    DefaultCategorySpec(
      id: 'cat-bonus',
      name: 'Bonus',
      icon: 'celebration',
      color: 0xFF00897B,
      type: income,
      sortOrder: 2,
    ),
    DefaultCategorySpec(
      id: 'cat-business',
      name: 'Business Income',
      icon: 'storefront',
      color: 0xFF6A1B9A,
      type: income,
      sortOrder: 3,
    ),
    DefaultCategorySpec(
      id: 'cat-other-income',
      name: 'Other Income',
      icon: 'more_horiz',
      color: 0xFF546E7A,
      type: income,
      sortOrder: 99,
    ),
  ];
}

IconData iconFromKey(String key) {
  return switch (key) {
    'shopping_cart' => Icons.shopping_cart_outlined,
    'eco' => Icons.eco_outlined,
    'bolt' => Icons.bolt_outlined,
    'local_fire_department' => Icons.local_fire_department_outlined,
    'home' => Icons.home_outlined,
    'school' => Icons.school_outlined,
    'medical_services' => Icons.medical_services_outlined,
    'local_gas_station' => Icons.local_gas_station_outlined,
    'wifi' => Icons.wifi,
    'phone_android' => Icons.phone_android_outlined,
    'card_giftcard' => Icons.card_giftcard_outlined,
    'directions_bus' => Icons.directions_bus_outlined,
    'restaurant' => Icons.restaurant_outlined,
    'more_horiz' => Icons.more_horiz,
    'payments' => Icons.payments_outlined,
    'celebration' => Icons.celebration_outlined,
    'storefront' => Icons.storefront_outlined,
    'account_balance_wallet' => Icons.account_balance_wallet_outlined,
    'account_balance' => Icons.account_balance_outlined,
    'credit_card' => Icons.credit_card_outlined,
    'savings' => Icons.savings_outlined,
    'directions_car' => Icons.directions_car_outlined,
    'diamond' => Icons.diamond_outlined,
    'apartment' => Icons.apartment_outlined,
    _ => Icons.circle_outlined,
  };
}
