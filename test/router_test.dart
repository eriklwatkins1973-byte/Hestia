import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hestia/screens/county_list_screen.dart';
import 'package:hestia/screens/resource_list_screen.dart';
import 'package:hestia/screens/state_selection_screen.dart';
import 'package:hestia/services/resource_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _testUrl = 'https://test.supabase.co';
const _testKey = 'fake-anon-key';

Widget _appWithRouter(GoRouter router) =>
    MaterialApp.router(routerConfig: router);

/// Tracks every [SupabaseClient] created during the current test so they can
/// be disposed in [tearDown].
final _activeClients = <SupabaseClient>[];

/// Creates a [SupabaseClient] backed by a [MockClient] that returns `[]` and
/// records it for cleanup.
ResourceService _emptyResourceService() {
  final supabase = SupabaseClient(
    _testUrl,
    _testKey,
    httpClient: MockClient(
      (_) async => http.Response(
        '[]',
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      ),
    ),
  );
  _activeClients.add(supabase);
  return ResourceService(client: supabase);
}

/// Creates a [GoRouter] initialised at [initialLocation], wiring the three
/// application routes.  The [ResourceListScreen] is injected with a mock
/// service that returns an empty list so that tests are not coupled to the
/// network.
GoRouter _routerAt(String initialLocation) => GoRouter(
      initialLocation: initialLocation,
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
        GoRoute(
          path: '/resources/:countyId',
          builder: (_, state) => ResourceListScreen(
            countyId: state.pathParameters['countyId']!,
            resourceService: _emptyResourceService(),
          ),
        ),
      ],
    );

void main() {
  tearDown(() async {
    for (final client in _activeClients) {
      await client.dispose();
    }
    _activeClients.clear();
  });

  // -------------------------------------------------------------------------
  // StateSelectionScreen routing
  // -------------------------------------------------------------------------

  group('StateSelectionScreen routing', () {
    testWidgets('/ renders StateSelectionScreen', (tester) async {
      await tester.pumpWidget(_appWithRouter(_routerAt('/')));
      await tester.pumpAndSettle();

      expect(find.byType(StateSelectionScreen), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // CountyListScreen routing
  // -------------------------------------------------------------------------

  group('CountyListScreen routing', () {
    testWidgets('/counties/:stateId renders CountyListScreen', (tester) async {
      await tester.pumpWidget(_appWithRouter(_routerAt('/counties/CA')));
      await tester.pumpAndSettle();

      expect(find.byType(CountyListScreen), findsOneWidget);
    });

    testWidgets('/counties/:stateId passes stateId to CountyListScreen',
        (tester) async {
      await tester.pumpWidget(_appWithRouter(_routerAt('/counties/TX')));
      await tester.pumpAndSettle();

      expect(find.textContaining('TX'), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // ResourceListScreen routing
  // -------------------------------------------------------------------------

  group('ResourceListScreen routing', () {
    testWidgets('/resources/:countyId renders ResourceListScreen',
        (tester) async {
      await tester
          .pumpWidget(_appWithRouter(_routerAt('/resources/county-123')));
      await tester.pumpAndSettle();

      expect(find.byType(ResourceListScreen), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // Navigation integration
  // -------------------------------------------------------------------------

  group('Navigation integration', () {
    testWidgets(
        'tapping a state in StateSelectionScreen navigates to CountyListScreen',
        (tester) async {
      await tester.pumpWidget(_appWithRouter(_routerAt('/')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('California'));
      await tester.pumpAndSettle();

      expect(find.byType(CountyListScreen), findsOneWidget);
      expect(find.textContaining('CA'), findsWidgets);
    });
  });
}

