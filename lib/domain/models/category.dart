import '../enums/category_type.dart';

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    this.parentId,
    required this.isDefault,
    required this.sortOrder,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String icon;
  final int color;
  final CategoryType type;
  final String? parentId;
  final bool isDefault;
  final int sortOrder;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isSubCategory => parentId != null;
}
