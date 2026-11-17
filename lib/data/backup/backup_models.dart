/// Versioned snapshot of every household-finance record.
///
/// Entity lists are plain maps so a backup file can move between app versions
/// without a generated schema. Dates are epoch milliseconds. Money is integer
/// minor units, the same way it is stored in SQLite.
class BackupPayload {
  const BackupPayload({
    this.schemaVersion = currentSchemaVersion,
    required this.createdAt,
    this.wallets = const [],
    this.categories = const [],
    this.transactions = const [],
    this.groups = const [],
    this.assets = const [],
    this.liabilities = const [],
    this.budgets = const [],
    this.budgetMembers = const [],
    this.recurring = const [],
    this.reminders = const [],
    this.exchangeRates = const [],
    this.settings = const {},
    this.assetValueHistory = const [],
    this.liabilityPayments = const [],
    this.committees = const [],
    this.savingsGoals = const [],
  });

  static const currentSchemaVersion = 1;

  /// Only the `drive.appdata` scope is requested. The app cannot see other
  /// Drive files.
  static const driveAppDataScope =
      'https://www.googleapis.com/auth/drive.appdata';

  final int schemaVersion;
  final DateTime createdAt;
  final List<Map<String, dynamic>> wallets;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> transactions;

  /// Each group map includes a `walletIds` list.
  final List<Map<String, dynamic>> groups;
  final List<Map<String, dynamic>> assets;
  final List<Map<String, dynamic>> liabilities;
  final List<Map<String, dynamic>> budgets;
  final List<Map<String, dynamic>> budgetMembers;
  final List<Map<String, dynamic>> recurring;
  final List<Map<String, dynamic>> reminders;
  final List<Map<String, dynamic>> exchangeRates;
  final Map<String, dynamic> settings;

  /// Kept so Replace does not drop history rows that belong to assets.
  final List<Map<String, dynamic>> assetValueHistory;
  final List<Map<String, dynamic>> liabilityPayments;
  final List<Map<String, dynamic>> committees;
  final List<Map<String, dynamic>> savingsGoals;

  Map<String, dynamic> toJson() => {
        'schemaVersion': schemaVersion,
        'createdAt': createdAt.toUtc().millisecondsSinceEpoch,
        'wallets': wallets,
        'categories': categories,
        'transactions': transactions,
        'groups': groups,
        'assets': assets,
        'liabilities': liabilities,
        'budgets': budgets,
        'budgetMembers': budgetMembers,
        'recurring': recurring,
        'reminders': reminders,
        'exchangeRates': exchangeRates,
        'settings': settings,
        'assetValueHistory': assetValueHistory,
        'liabilityPayments': liabilityPayments,
        'committees': committees,
        'savingsGoals': savingsGoals,
      };

  factory BackupPayload.fromJson(Map<String, dynamic> json) {
    final version = _asInt(json['schemaVersion']);
    if (version == null) {
      throw const BackupCorruptException('Backup is missing schemaVersion.');
    }
    if (version > currentSchemaVersion) {
      throw BackupVersionException(
        'This backup uses schema $version. Update the app before restoring it.',
      );
    }
    final createdRaw = json['createdAt'];
    if (createdRaw == null) {
      throw const BackupCorruptException('Backup is missing createdAt.');
    }
    return BackupPayload(
      schemaVersion: version,
      createdAt: _asDate(createdRaw),
      wallets: _mapList(json['wallets']),
      categories: _mapList(json['categories']),
      transactions: _mapList(json['transactions']),
      groups: _mapList(json['groups']),
      assets: _mapList(json['assets']),
      liabilities: _mapList(json['liabilities']),
      budgets: _mapList(json['budgets']),
      budgetMembers: _mapList(json['budgetMembers']),
      recurring: _mapList(json['recurring']),
      reminders: _mapList(json['reminders']),
      exchangeRates: _mapList(json['exchangeRates']),
      settings: _deepMap(json['settings']),
      assetValueHistory: _mapList(json['assetValueHistory']),
      liabilityPayments: _mapList(json['liabilityPayments']),
      committees: _mapList(json['committees']),
      savingsGoals: _mapList(json['savingsGoals']),
    );
  }
}

enum RestoreMode { replace, merge }

enum AutoBackupFrequency {
  off,
  daily,
  weekly;

  static AutoBackupFrequency fromStorage(String? raw) {
    for (final value in AutoBackupFrequency.values) {
      if (value.name == raw) return value;
    }
    return AutoBackupFrequency.off;
  }

  Duration? get interval => switch (this) {
        AutoBackupFrequency.off => null,
        AutoBackupFrequency.daily => const Duration(days: 1),
        AutoBackupFrequency.weekly => const Duration(days: 7),
      };
}

enum BackupFailureKind {
  offline,
  authExpired,
  quota,
  corrupted,
  unavailable,
  cancelled,
  password,
}

class BackupFailure implements Exception {
  const BackupFailure(this.kind, this.message);

  final BackupFailureKind kind;
  final String message;

  @override
  String toString() => message;
}

class BackupCorruptException implements Exception {
  const BackupCorruptException([this.message = 'Backup file is corrupted.']);

  final String message;

  @override
  String toString() => message;
}

class BackupVersionException implements Exception {
  const BackupVersionException(this.message);

  final String message;

  @override
  String toString() => message;
}

class BackupPasswordException implements Exception {
  const BackupPasswordException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// A file the app wrote under the documents backup folder, or held in memory
/// on web.
class StoredBackup {
  const StoredBackup({
    required this.name,
    required this.modified,
    required this.sizeBytes,
    this.path,
    this.content,
  });

  final String name;
  final DateTime modified;
  final int sizeBytes;
  final String? path;
  final String? content;
}

class DriveBackupInfo {
  const DriveBackupInfo({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.sizeBytes,
  });

  final String id;
  final String name;
  final DateTime createdAt;
  final int sizeBytes;
}

int? _asInt(Object? raw) {
  if (raw is int) return raw;
  if (raw is num) return raw.toInt();
  if (raw is String) return int.tryParse(raw);
  return null;
}

DateTime _asDate(Object? raw) {
  final millis = _asInt(raw);
  if (millis != null) {
    return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
  }
  if (raw is String) {
    final parsed = DateTime.tryParse(raw);
    if (parsed != null) return parsed.toUtc();
  }
  throw const BackupCorruptException('Backup createdAt is invalid.');
}

List<Map<String, dynamic>> _mapList(Object? raw) {
  if (raw is! List) return const [];
  return [
    for (final item in raw)
      if (item is Map) _deepMap(item),
  ];
}

Map<String, dynamic> _deepMap(Object? raw) {
  if (raw is! Map) return const {};
  return raw.map((key, value) => MapEntry(key.toString(), _deep(value)));
}

Object? _deep(Object? value) {
  if (value is Map) return _deepMap(value);
  if (value is List) return [for (final item in value) _deep(item)];
  return value;
}
