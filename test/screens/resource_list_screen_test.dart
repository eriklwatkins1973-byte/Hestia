import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hestia/screens/resource_list_screen.dart';
import 'package:hestia/services/resource_service.dart';
import 'package:hestia/widgets/resource_card.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(Widget widget) => MaterialApp(home: widget);

const _countyId = 'county-001';
const _testUrl = 'https://test.supabase.co';
const _testKey = 'fake-anon-key';

final _sampleResourceJson = {
  'id': 'res-1',
  'county_id': _countyId,
  'category': 'shelter',
  'organization_name': 'Hope Shelter',
  'address': '123 Main St',
  'is_active': true,
};

final _secondResourceJson = {
  'id': 'res-2',
  'county_id': _countyId,
  'category': 'meal',
  'organization_name': 'Community Kitchen',
  'is_active': true,
};

/// Tracks every [SupabaseClient] created during the current test so they can
/// be disposed in [tearDown].
final _activeClients = <SupabaseClient>[];

/// Creates a [SupabaseClient] backed by [mockHttp], records it for cleanup,
/// and wraps it in a [ResourceService].
ResourceService _serviceWith(http.Client mockHttp) {
  final supabase = SupabaseClient(_testUrl, _testKey, httpClient: mockHttp);
  _activeClients.add(supabase);
  return ResourceService(client: supabase);
}

ResourceService _serviceReturning(List<Map<String, dynamic>> resources) =>
    _serviceWith(
      MockClient(
        (_) async => http.Response(
          jsonEncode(resources),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      ),
    );

ResourceService _serviceReturningError() => _serviceWith(
      MockClient(
        (_) async => http.Response(
          '{"message":"Internal Server Error"}',
          500,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      ),
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  tearDown(() async {
    for (final client in _activeClients) {
      await client.dispose();
    }
    _activeClients.clear();
  });

  group('ResourceListScreen', () {
    testWidgets('shows a loading indicator while fetching', (tester) async {
      // Use a delayed response so the future never settles during this test.
      final service = _serviceWith(
        MockClient((_) async {
          await Future<void>.delayed(const Duration(seconds: 10));
          return http.Response(
            '[]',
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }),
      );

      await tester.pumpWidget(
        _wrap(ResourceListScreen(countyId: _countyId, resourceService: service)),
      );
      // Only pump once – the future is still pending.
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows "No resources found." when list is empty',
        (tester) async {
      await tester.pumpWidget(
        _wrap(ResourceListScreen(
          countyId: _countyId,
          resourceService: _serviceReturning([]),
        )),
      );
      await tester.pumpAndSettle();

      expect(find.text('No resources found.'), findsOneWidget);
    });

    testWidgets('renders a ResourceCard for each returned resource',
        (tester) async {
      await tester.pumpWidget(
        _wrap(ResourceListScreen(
          countyId: _countyId,
          resourceService: _serviceReturning(
            [_sampleResourceJson, _secondResourceJson],
          ),
        )),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ResourceCard), findsNWidgets(2));
      expect(find.text('Hope Shelter'), findsOneWidget);
      expect(find.text('Community Kitchen'), findsOneWidget);
    });

    testWidgets('renders a single ResourceCard for a single resource',
        (tester) async {
      await tester.pumpWidget(
        _wrap(ResourceListScreen(
          countyId: _countyId,
          resourceService: _serviceReturning([_sampleResourceJson]),
        )),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ResourceCard), findsOneWidget);
      expect(find.text('Hope Shelter'), findsOneWidget);
    });

    testWidgets('shows an error message when the service throws',
        (tester) async {
      await tester.pumpWidget(
        _wrap(ResourceListScreen(
          countyId: _countyId,
          resourceService: _serviceReturningError(),
        )),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Error:'), findsOneWidget);
    });

    testWidgets('shows "Resources" in the app bar', (tester) async {
      await tester.pumpWidget(
        _wrap(ResourceListScreen(
          countyId: _countyId,
          resourceService: _serviceReturning([]),
        )),
      );
      await tester.pumpAndSettle();

      expect(find.text('Resources'), findsOneWidget);
    });
  });
}

