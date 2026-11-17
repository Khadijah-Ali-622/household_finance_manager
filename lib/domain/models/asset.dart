import '../enums/asset_type.dart';
import 'money_amount.dart';

class Asset {
  const Asset({
    required this.id,
    required this.name,
    required this.type,
    this.purchasePrice,
    this.purchaseDate,
    required this.currentValue,
    this.currency = 'PKR',
    this.quantity,
    this.unit,
    this.notes,
    this.photoPath,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final AssetType type;
  final MoneyAmount? purchasePrice;
  final DateTime? purchaseDate;
  final MoneyAmount currentValue;
  final String currency;
  final String? quantity;
  final String? unit;
  final String? notes;
  final String? photoPath;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
}
