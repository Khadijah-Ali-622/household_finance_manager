import 'package:package_info_plus/package_info_plus.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/form_page_body.dart';
import '../../../l10n/app_localizations.dart';

/// Placeholder links. Replace them before publishing the app.
class AboutLinks {
  static const feedback =
      'mailto:feedback@example.com?subject=Household%20Finance%20Manager%20feedback';
  static const privacyPolicy = 'https://example.com/privacy';
  static const terms = 'https://example.com/terms';
}

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final build = info.buildNumber.isEmpty ? '' : ' (${info.buildNumber})';
      if (!mounted) return;
      setState(() => _version = '${info.version}$build');
    } catch (_) {
      if (!mounted) return;
      setState(() => _version = '1.0.0');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final features = [
      l10n.aboutFeatureWallets,
      l10n.aboutFeatureTransactions,
      l10n.aboutFeatureBudgets,
      l10n.aboutFeatureRecurring,
      l10n.aboutFeatureBackup,
      l10n.aboutFeatureDevices,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.about)),
      body: FormPageBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.aboutAppName, style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              _version.isEmpty ? l10n.loading : l10n.aboutVersion(_version),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            _section(
              context,
              title: l10n.aboutWhatTitle,
              child: Text(l10n.aboutWhatBody),
            ),
            const SizedBox(height: AppSpacing.md),
            _section(
              context,
              title: l10n.aboutFeaturesTitle,
              child: Column(
                children: [
                  for (final feature in features)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.check_circle_outline,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(feature),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _section(
              context,
              title: l10n.aboutPrivacyTitle,
              child: Text(l10n.aboutPrivacyBody),
            ),
            const SizedBox(height: AppSpacing.md),
            _section(
              context,
              title: l10n.aboutDeveloperTitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.aboutDeveloperCredit),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      OutlinedButton(
                        onPressed: () => _open(AboutLinks.feedback),
                        child: Text(l10n.aboutFeedback),
                      ),
                      OutlinedButton(
                        onPressed: () => _open(AboutLinks.privacyPolicy),
                        child: Text(l10n.aboutPrivacyPolicy),
                      ),
                      OutlinedButton(
                        onPressed: () => _open(AboutLinks.terms),
                        child: Text(l10n.aboutTerms),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            child,
          ],
        ),
      ),
    );
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).errorGeneric)),
      );
    }
  }
}
