import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/form_page_body.dart';
import '../../../data/backup/backup_models.dart';
import '../../../l10n/app_localizations.dart';
import '../backup_providers.dart';

class BackupPage extends ConsumerStatefulWidget {
  const BackupPage({super.key});

  @override
  ConsumerState<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends ConsumerState<BackupPage> {
  bool _busy = false;
  bool _driveReady = false;
  String? _account;
  bool _encryption = false;
  AutoBackupFrequency _frequency = AutoBackupFrequency.off;
  DateTime? _lastAt;
  int? _lastSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    final settings = ref.read(backupSettingsProvider);
    final drive = ref.read(driveBackupServiceProvider);
    final account = await drive.currentAccountLabel();
    if (!mounted) return;
    setState(() {
      _account = account;
      _driveReady = drive.isConfigured;
      _encryption = settings.encryptionEnabled;
      _frequency = settings.frequency;
      _lastAt = settings.lastBackupAt;
      _lastSize = settings.lastBackupSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final last = _lastAt == null
        ? l10n.backupNever
        : l10n.backupLastSummary(_formatWhen(_lastAt!), _formatSize(_lastSize ?? 0));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.backup)),
      body: FormPageBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(last, style: theme.textTheme.bodyMedium),
            if (_busy) ...[
              const SizedBox(height: AppSpacing.md),
              const LinearProgressIndicator(),
            ],
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.backupGoogleDrive, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!_driveReady)
                      Text(l10n.backupDriveUnavailable)
                    else ...[
                      Text(
                        _account == null
                            ? l10n.backupSignedOut
                            : '${l10n.backupSignedIn}: $_account',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (_account == null)
                        OutlinedButton(
                          onPressed: _busy ? null : _signIn,
                          child: Text(l10n.backupSignIn),
                        )
                      else
                        OutlinedButton(
                          onPressed: _busy ? null : _signOut,
                          child: Text(l10n.backupSignOut),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      FilledButton(
                        onPressed: _busy || _account == null ? null : _backupNow,
                        child: Text(l10n.backupNow),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    FilledButton.tonal(
                      onPressed: _busy ? null : _restoreFromList,
                      child: Text(l10n.backupRestore),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.backupAuto, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(l10n.backupAutoHint, style: theme.textTheme.bodySmall),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: RadioGroup<AutoBackupFrequency>(
                groupValue: _frequency,
                onChanged: (value) {
                  if (_busy || value == null) return;
                  ref.read(backupSettingsProvider).setFrequency(value);
                  setState(() => _frequency = value);
                },
                child: Column(
                  children: [
                    for (final option in AutoBackupFrequency.values)
                      RadioListTile<AutoBackupFrequency>(
                        title: Text(_frequencyLabel(l10n, option)),
                        value: option,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.backupEncryption, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(l10n.backupEncryption),
                    subtitle: Text(
                      _encryption
                          ? l10n.backupEncryptionOn
                          : l10n.backupEncryptionOff,
                    ),
                    value: _encryption,
                    onChanged: _busy ? null : _setEncryption,
                  ),
                  if (_encryption)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        0,
                        AppSpacing.lg,
                        AppSpacing.md,
                      ),
                      child: Text(
                        l10n.backupEncryptionWarning,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.backupLocal, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(l10n.backupExportJson),
                    trailing: const Icon(Icons.upload_file),
                    onTap: _busy ? null : _exportJson,
                  ),
                  ListTile(
                    title: Text(l10n.backupImportJson),
                    trailing: const Icon(Icons.download),
                    onTap: _busy ? null : _importJson,
                  ),
                  ListTile(
                    title: Text(l10n.backupExportCsv),
                    trailing: const Icon(Icons.table_chart_outlined),
                    onTap: _busy ? null : _exportCsv,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signIn() => _guard(() async {
        final label = await ref.read(driveBackupServiceProvider).signIn();
        if (!mounted) return;
        setState(() => _account = label);
      });

  Future<void> _signOut() => _guard(() async {
        await ref.read(driveBackupServiceProvider).signOut();
        if (!mounted) return;
        setState(() => _account = null);
      });

  Future<void> _backupNow() => _guard(() async {
        await ref.read(backupCoordinatorProvider).backupToDrive();
        await _reload();
        if (mounted) _snack(AppLocalizations.of(context).backupSuccess);
      });

  Future<void> _exportJson() => _guard(() async {
        final result = await ref.read(backupCoordinatorProvider).exportJson();
        await _reload();
        if (!mounted) return;
        final l10n = AppLocalizations.of(context);
        _snack(result.shared ? l10n.backupSuccess : l10n.backupShareFailed);
      });

  Future<void> _exportCsv() => _guard(() async {
        final result = await ref.read(backupCoordinatorProvider).exportCsv();
        if (!mounted) return;
        final l10n = AppLocalizations.of(context);
        _snack(result.shared ? l10n.backupSuccess : l10n.backupShareFailed);
      });

  Future<void> _importJson() async {
    try {
      final json = await ref.read(backupCoordinatorProvider).pickJson();
      if (json == null || !mounted) return;
      await _restoreContents(json);
    } catch (error) {
      if (mounted) _showError(error);
    }
  }

  Future<void> _restoreFromList() async {
    final l10n = AppLocalizations.of(context);
    try {
      final choices = await _choices();
      if (!mounted) return;
      if (choices.isEmpty) {
        _snack(l10n.backupEmptyList);
        return;
      }
      final picked = await showModalBottomSheet<_RestoreChoice>(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(title: Text(l10n.backupChooseBackup)),
                for (final choice in choices)
                  ListTile(
                    title: Text(choice.title),
                    subtitle: Text(choice.subtitle),
                    onTap: () => Navigator.pop(ctx, choice),
                  ),
              ],
            ),
          );
        },
      );
      if (picked == null || !mounted) return;
      final json = await picked.load();
      if (!mounted) return;
      await _restoreContents(json);
    } catch (error) {
      if (mounted) _showError(error);
    }
  }

  Future<void> _restoreContents(String json) async {
    final mode = await _askMode();
    if (mode == null || !mounted) return;
    String? password;
    final coordinator = ref.read(backupCoordinatorProvider);
    if (coordinator.fileIsEncrypted(json)) {
      password = await _askPassword(confirm: false);
      if (password == null || !mounted) return;
    }
    await _guard(() async {
      final payload = await ref.read(backupCoordinatorProvider).restoreJson(
            json: json,
            mode: mode,
            password: password,
          );
      if (mode == RestoreMode.replace) {
        await applyReplacedSettings(ref, payload.settings);
      }
      refreshFinanceProviders(ref);
      await _reload();
      if (mounted) {
        _snack(AppLocalizations.of(context).backupRestoreSuccess);
      }
    });
  }

  Future<List<_RestoreChoice>> _choices() async {
    final l10n = AppLocalizations.of(context);
    final drive = ref.read(driveBackupServiceProvider);
    final local = ref.read(localBackupServiceProvider);
    final choices = <_RestoreChoice>[];
    if (_driveReady && _account != null) {
      final remote = await drive.listBackups();
      for (final file in remote) {
        choices.add(
          _RestoreChoice(
            title: file.name,
            subtitle:
                '${l10n.backupGoogleDrive} · ${_formatWhen(file.createdAt)} · ${_formatSize(file.sizeBytes)}',
            load: () => drive.download(file.id),
          ),
        );
      }
    }
    final safety = await local.listSafetyCopies();
    final exports = await local.listExports();
    for (final file in [...safety, ...exports]) {
      choices.add(
        _RestoreChoice(
          title: file.name,
          subtitle:
              '${l10n.backupLocal} · ${_formatWhen(file.modified)} · ${_formatSize(file.sizeBytes)}',
          load: () => local.read(file),
        ),
      );
    }
    return choices;
  }

  Future<RestoreMode?> _askMode() {
    final l10n = AppLocalizations.of(context);
    return showDialog<RestoreMode>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.backupRestoreTitle),
        content: Text(l10n.backupRestoreBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, RestoreMode.merge),
            child: Text(l10n.backupMerge),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, RestoreMode.replace),
            child: Text(l10n.backupReplace),
          ),
        ],
      ),
    );
  }

  Future<void> _setEncryption(bool enabled) async {
    final coordinator = ref.read(backupCoordinatorProvider);
    if (enabled) {
      final password = await _askPassword(confirm: true);
      if (password == null) return;
      await _guard(() async {
        await coordinator.enableEncryption(password);
        if (mounted) setState(() => _encryption = true);
      });
      return;
    }
    await _guard(() async {
      await coordinator.disableEncryption();
      if (mounted) setState(() => _encryption = false);
    });
  }

  Future<String?> _askPassword({required bool confirm}) async {
    final l10n = AppLocalizations.of(context);
    final first = TextEditingController();
    final second = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) {
        var error = '';
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return AlertDialog(
              title: Text(l10n.backupPassword),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.backupEncryptionWarning),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: first,
                    obscureText: true,
                    autofocus: true,
                    decoration: InputDecoration(labelText: l10n.backupPassword),
                  ),
                  if (confirm) ...[
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      controller: second,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l10n.backupConfirmPassword,
                      ),
                    ),
                  ],
                  if (error.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      error,
                      style: TextStyle(color: Theme.of(ctx).colorScheme.error),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    final password = first.text;
                    if (password.trim().length < 4) {
                      setLocal(() => error = l10n.backupPasswordTooShort);
                      return;
                    }
                    if (confirm && password != second.text) {
                      setLocal(() => error = l10n.backupPasswordMismatch);
                      return;
                    }
                    Navigator.pop(ctx, password);
                  },
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );
    first.dispose();
    second.dispose();
    return result;
  }

  Future<void> _guard(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (error) {
      if (mounted) _showError(error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(Object error) {
    if (error is BackupFailure && error.kind == BackupFailureKind.cancelled) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    final message = switch (error) {
      BackupPasswordException() => l10n.backupErrorPassword,
      BackupCorruptException() => l10n.backupErrorCorrupt,
      BackupVersionException() => l10n.backupErrorCorrupt,
      BackupFailure(:final kind) => switch (kind) {
          BackupFailureKind.offline => l10n.backupErrorOffline,
          BackupFailureKind.authExpired => l10n.backupErrorAuth,
          BackupFailureKind.quota => l10n.backupErrorQuota,
          BackupFailureKind.corrupted => l10n.backupErrorCorrupt,
          BackupFailureKind.password => l10n.backupErrorPassword,
          BackupFailureKind.unavailable => l10n.backupDriveUnavailable,
          BackupFailureKind.cancelled => null,
        },
      _ => l10n.errorGeneric,
    };
    if (message != null) _snack(message);
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _frequencyLabel(AppLocalizations l10n, AutoBackupFrequency value) {
    return switch (value) {
      AutoBackupFrequency.off => l10n.backupAutoOff,
      AutoBackupFrequency.daily => l10n.backupAutoDaily,
      AutoBackupFrequency.weekly => l10n.backupAutoWeekly,
    };
  }

  String _formatWhen(DateTime time) {
    return DateFormat.yMMMd().add_jm().format(time.toLocal());
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class _RestoreChoice {
  const _RestoreChoice({
    required this.title,
    required this.subtitle,
    required this.load,
  });

  final String title;
  final String subtitle;
  final Future<String> Function() load;
}
