import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hestia/screens/county_list_screen.dart';

Widget _wrap(Widget widget) =>
    MaterialApp(home: widget);

void main() {
  group('CountyListScreen', () {
    testWidgets('shows stateId in the app bar', (tester) async {
      await tester.pumpWidget(
        _wrap(const CountyListScreen(stateId: 'CA')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Counties – CA'), findsOneWidget);
    });

    testWidgets('shows stateId in the body text', (tester) async {
      await tester.pumpWidget(
        _wrap(const CountyListScreen(stateId: 'TX')),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('TX'), findsWidgets);
    });

    testWidgets('renders correctly for different stateIds', (tester) async {
      for (final id in ['CA', 'NY', 'TX']) {
        await tester.pumpWidget(_wrap(CountyListScreen(stateId: id)));
        await tester.pumpAndSettle();

        expect(find.textContaining(id), findsWidgets,
            reason: 'Expected stateId $id to appear on screen');
      }
    });
  });
}
