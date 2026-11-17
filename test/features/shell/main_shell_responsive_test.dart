import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart'
    hide GlobalMaterialLocalizations;

import 'package:household_finance_manager/core/layout/responsive.dart';
import 'package:household_finance_manager/l10n/app_localizations.dart';

void main() {
  Widget wrap(
    Size size, {
    required Locale locale,
    required Widget child,
  }) {
    return MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
  }

  for (final size in const [
    Size(360, 640),
    Size(412, 915),
    Size(768, 1024),
    Size(1440, 900),
  ]) {
    testWidgets('no overflow smoke EN ${size.width}x${size.height}', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final r = Responsive.fromWidth(size.width);

      await tester.pumpWidget(
        wrap(
          size,
          locale: const Locale('en'),
          child: Scaffold(
            body: ListView(
              padding: EdgeInsets.all(r.pagePadding),
              children: [
                Text('Dashboard ${r.breakpoint.name}'),
                ResponsiveGrid(
                  columns: r.gridColumns,
                  children: List.generate(
                    4,
                    (i) => const Card(
                      child: ListTile(
                        title: Text('Wallet'),
                        trailing: Text('Rs 12,345.00'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: r.isMobile
                ? NavigationBar(
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.more_horiz),
                        label: 'More',
                      ),
                    ],
                    selectedIndex: 0,
                    onDestinationSelected: (_) {},
                  )
                : null,
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      if (r.isMobile) {
        expect(find.byType(NavigationBar), findsOneWidget);
      }
    });

    testWidgets('no overflow smoke UR RTL ${size.width}x${size.height}', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final r = Responsive.fromWidth(size.width);

      // Material may not fully ship `ur`; force RTL to validate layout mirroring.
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: size),
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => Directionality(
              textDirection: TextDirection.rtl,
              child: child ?? const SizedBox.shrink(),
            ),
            home: Scaffold(
              body: ListView(
                padding: EdgeInsets.all(r.pagePadding),
                children: [
                  const ListTile(
                    title: Text('والٹ'),
                    trailing: Text('روپیہ 1,000'),
                  ),
                  ResponsiveGrid(
                    columns: r.gridColumns,
                    children: const [
                      Card(child: ListTile(title: Text('آمدنی'))),
                      Card(child: ListTile(title: Text('خرچ'))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        Directionality.of(tester.element(find.byType(Scaffold))),
        TextDirection.rtl,
      );
      expect(AppLocalizations.supportedLocales, contains(const Locale('ur')));
    });
  }
}
