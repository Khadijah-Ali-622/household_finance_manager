import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/core/layout/responsive.dart';

void main() {
  group('Responsive breakpoints', () {
    test('mobile under 600', () {
      expect(Responsive.fromWidth(360).isMobile, isTrue);
      expect(Responsive.fromWidth(412).isMobile, isTrue);
      expect(Responsive.fromWidth(599).breakpoint, AppBreakpoint.mobile);
    });

    test('tablet 600–1024', () {
      expect(Responsive.fromWidth(600).isTablet, isTrue);
      expect(Responsive.fromWidth(768).isTablet, isTrue);
      expect(Responsive.fromWidth(1024).isTablet, isTrue);
    });

    test('desktop above 1024', () {
      expect(Responsive.fromWidth(1025).isDesktop, isTrue);
      expect(Responsive.fromWidth(1440).isDesktop, isTrue);
      expect(Responsive.fromWidth(1440).gridColumns, 3);
    });

    test('grid columns by width', () {
      expect(Responsive.fromWidth(360).gridColumns, 1);
      expect(Responsive.fromWidth(768).gridColumns, 2);
      expect(Responsive.fromWidth(1440).gridColumns, 3);
    });
  });
}
