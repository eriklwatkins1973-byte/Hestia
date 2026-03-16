import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hestia/screens/county_list_screen.dart';
import 'package:hestia/screens/state_selection_screen.dart';

Widget _wrap(Widget widget) =>
    MaterialApp(home: widget);

/// Wraps [StateSelectionScreen] inside a GoRouter so that navigation calls
/// (context.go) can be exercised without crashing.
Widget _wrapWithRouter() => MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const StateSelectionScreen(),
          ),
          GoRoute(
            path: '/counties/:stateId',
            builder: (_, state) =>
                CountyListScreen(stateId: state.pathParameters['stateId']!),
          ),
        ],
      ),
    );

void main() {
  group('StateSelectionScreen', () {
    testWidgets('renders "Select a State" app bar title', (tester) async {
      await tester.pumpWidget(_wrap(const StateSelectionScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Select a State'), findsOneWidget);
    });

    testWidgets('displays all placeholder state names', (tester) async {
      await tester.pumpWidget(_wrap(const StateSelectionScreen()));
      await tester.pumpAndSettle();

      expect(find.text('California'), findsOneWidget);
      expect(find.text('New York'), findsOneWidget);
      expect(find.text('Texas'), findsOneWidget);
    });

    testWidgets('each state item has a trailing arrow icon', (tester) async {
      await tester.pumpWidget(_wrap(const StateSelectionScreen()));
      await tester.pumpAndSettle();

      final arrows = find.byWidgetPredicate(
        (w) => w is Icon && w.icon == Icons.arrow_forward_ios,
      );
      expect(arrows, findsNWidgets(3));
    });

    testWidgets('tapping a state navigates to /counties/:stateId',
        (tester) async {
      await tester.pumpWidget(_wrapWithRouter());
      await tester.pumpAndSettle();

      await tester.tap(find.text('New York'));
      await tester.pumpAndSettle();

      expect(find.byType(CountyListScreen), findsOneWidget);
      expect(find.textContaining('NY'), findsWidgets);
    });
  });
}
