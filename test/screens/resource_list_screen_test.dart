import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:hestia/screens/resource_list_screen.dart';
import 'package:hestia/services/resource_service.dart';
import 'package:hestia/widgets/resource_card.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(Widget widget) => MaterialApp(home: widget);

const _countyId = 'county-001';

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

ResourceService _serviceReturning(List<Map<String, dynamic>> resources) =>
    ResourceService(
      client: MockClient(
        (_) async => http.Response(jsonEncode(resources), 200),
      ),
    );

ResourceService _serviceReturningError() => ResourceService(
      client: MockClient(
        (_) async => http.Response('Internal Server Error', 500),
      ),
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('ResourceListScreen', () {
    testWidgets('shows a loading indicator while fetching', (tester) async {
      // Use a completer so the future never settles during this test.
      final service = ResourceService(
        client: MockClient((_) async {
          await Future<void>.delayed(const Duration(seconds: 10));
          return http.Response('[]', 200);
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
