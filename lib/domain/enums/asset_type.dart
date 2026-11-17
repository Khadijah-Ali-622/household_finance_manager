enum AssetType {
  property,
  vehicle,
  gold,
  investment,
  receivable,
  business,
  other;

  String get storageValue => name;

  static AssetType fromStorage(String value) => switch (value) {
        'property' => AssetType.property,
        'vehicle' => AssetType.vehicle,
        'gold' => AssetType.gold,
        'investment' => AssetType.investment,
        'receivable' => AssetType.receivable,
        'business' => AssetType.business,
        _ => AssetType.other,
      };

  String get label => switch (this) {
        AssetType.property => 'Property',
        AssetType.vehicle => 'Vehicle',
        AssetType.gold => 'Gold',
        AssetType.investment => 'Investment',
        AssetType.receivable => 'Receivable',
        AssetType.business => 'Business',
        AssetType.other => 'Other',
      };
}
