import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/confirm_dialog.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

class GroupFormPage extends ConsumerStatefulWidget {
  const GroupFormPage({super.key, this.groupId});

  final String? groupId;

  @override
  ConsumerState<GroupFormPage> createState() => _GroupFormPageState();
}

class _GroupFormPageState extends ConsumerState<GroupFormPage> {
  final _nameCtrl = TextEditingController();
  final _selected = <String>{};
  bool _loading = false;
  bool _initialized = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (_initialized || widget.groupId == null) {
      _initialized = true;
      return;
    }
    final group =
        await ref.read(walletGroupRepositoryProvider).getById(widget.groupId!);
    if (group != null && mounted) {
      setState(() {
        _nameCtrl.text = group.name;
        _selected.addAll(group.walletIds);
        _initialized = true;
      });
    }
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty || _selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and at least one wallet required')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(walletGroupRepositoryProvider).save(
            id: widget.groupId,
            name: _nameCtrl.text,
            walletIds: _selected.toList(),
          );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wallets = ref.watch(walletsProvider).value ?? [];
    _load();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupId == null ? l10n.createGroup : l10n.walletGroups),
        actions: [
          if (widget.groupId != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok = await confirmDelete(context);
                if (ok) {
                  await ref
                      .read(walletGroupRepositoryProvider)
                      .delete(widget.groupId!);
                  if (context.mounted) context.pop();
                }
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(labelText: l10n.name),
          ),
          const SizedBox(height: 16),
          Text(l10n.selectWallets, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          ...wallets.map(
            (w) => CheckboxListTile(
              value: _selected.contains(w.id),
              title: Text(w.name),
              onChanged: (v) => setState(() {
                if (v == true) {
                  _selected.add(w.id);
                } else {
                  _selected.remove(w.id);
                }
              }),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _loading ? null : _save,
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
