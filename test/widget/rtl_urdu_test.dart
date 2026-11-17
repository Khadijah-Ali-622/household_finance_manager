import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/l10n/app_localizations.dart';

void main() {
  testWidgets('RTL layout renders for Urdu', (tester) async {
    late TextDirection direction;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ur'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Builder(
          builder: (context) {
            direction = Directionality.of(context);
            final l10n = AppLocalizations.of(context);
            return Scaffold(
              appBar: AppBar(title: Text(l10n.navDashboard)),
              body: Text(l10n.totalBalance),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(direction, TextDirection.rtl);
    expect(find.textContaining('بیلنس'), findsWidgets);
  });
}
