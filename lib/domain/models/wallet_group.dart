class WalletGroup {
  const WalletGroup({
    required this.id,
    required this.name,
    this.icon,
    required this.walletIds,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String? icon;
  final List<String> walletIds;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
}
