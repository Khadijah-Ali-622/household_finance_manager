import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../providers.dart';
import 'combined_view_page.dart';

class QuickSelectPage extends ConsumerStatefulWidget {
  const QuickSelectPage({super.key});

  @override
  ConsumerState<QuickSelectPage> createState() => _QuickSelectPageState();
}

class _QuickSelectPageState extends ConsumerState<QuickSelectPage> {
  final _selected = <String>{};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wallets = ref.watch(walletsProvider).value ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.quickSelect)),
      body: ListView(
        children: [
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: _selected.isEmpty
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => CombinedViewPage(
                            walletIds: _selected.toList(),
                          ),
                        ),
                      );
                    },
              child: Text(l10n.combinedView),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: _selected.isEmpty
                  ? null
                  : () => context.push('/wallets/groups/add'),
              child: Text(l10n.createGroup),
            ),
          ),
        ],
      ),
    );
  }
}
