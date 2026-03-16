import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hestia/models/resource_category.dart';
import 'package:hestia/services/resource_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Supabase project URL used for all test clients.
const _testUrl = 'https://test.supabase.co';

/// Fake anon key — value does not matter for unit tests.
const _testKey = 'fake-anon-key';

/// Tracks the most recently created [SupabaseClient] so it can be disposed
/// in [tearDown].
SupabaseClient? _activeClient;

/// Creates a [SupabaseClient] backed by [httpClient] and records it for
/// cleanup.
SupabaseClient _supabaseWith(http.Client httpClient) {
  _activeClient = SupabaseClient(_testUrl, _testKey, httpClient: httpClient);
  return _activeClient!;
}

/// Creates a [ResourceService] whose HTTP layer is a [MockClient] that always
/// returns [body] with [statusCode].
ResourceService _serviceReturning(
  String body, {
  int statusCode = 200,
}) {
  final mockHttp = MockClient(
    (_) async => http.Response(
      body,
      statusCode,
      headers: {'content-type': 'application/json; charset=utf-8'},
    ),
  );
  return ResourceService(client: _supabaseWith(mockHttp));
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await _activeClient?.dispose();
    _activeClient = null;
  });

  group('ResourceService', () {
    const countyId = 'some-county-uuid';

    final sampleResourceJson = {
      'id': 'res-1',
      'county_id': countyId,
      'category': 'shelter',
      'organization_name': 'Hope Shelter',
      'address': '123 Main St',
      'phone_number': '555-0100',
      'website_url': 'https://hope.example.com',
      'is_active': true,
    };

    test('getResourcesByCounty returns a list of Resources on 200', () async {
      final mockHttp = MockClient((request) async {
        // Verify the PostgREST filter is present in the URL.
        expect(
          request.url.queryParameters['county_id'],
          'eq.$countyId',
        );
        return http.Response(
          jsonEncode([sampleResourceJson]),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = ResourceService(client: _supabaseWith(mockHttp));
      final resources = await service.getResourcesByCounty(countyId);

      expect(resources.length, 1);
      expect(resources.first.id, 'res-1');
      expect(resources.first.countyId, countyId);
      expect(resources.first.category, ResourceCategory.shelter);
      expect(resources.first.organizationName, 'Hope Shelter');
      expect(resources.first.isActive, true);
    });

    test('getResourcesByCounty returns an empty list when no resources',
        () async {
      final service = _serviceReturning('[]');
      final resources = await service.getResourcesByCounty(countyId);

      expect(resources, isEmpty);
    });

    test('getResourcesByCounty returns multiple resources', () async {
      final secondResource = {
        'id': 'res-2',
        'county_id': countyId,
        'category': 'meal',
        'organization_name': 'Community Kitchen',
        'is_active': true,
      };

      final service = _serviceReturning(
        jsonEncode([sampleResourceJson, secondResource]),
      );
      final resources = await service.getResourcesByCounty(countyId);

      expect(resources.length, 2);
      expect(resources[0].id, 'res-1');
      expect(resources[1].id, 'res-2');
      expect(resources[1].category, ResourceCategory.meal);
    });

    test('getResourcesByCounty throws on non-200 response', () async {
      final service = _serviceReturning(
        '{"message":"Not Found","code":"PGRST301"}',
        statusCode: 404,
      );

      await expectLater(
        service.getResourcesByCounty(countyId),
        throwsA(isA<Exception>()),
      );
    });

    test('getResourcesByCounty throws on server error', () async {
      final service = _serviceReturning(
        '{"message":"Internal Server Error"}',
        statusCode: 500,
      );

      await expectLater(
        service.getResourcesByCounty(countyId),
        throwsA(isA<Exception>()),
      );
    });

    test('getResourcesByCounty URL-encodes countyId in PostgREST eq filter',
        () async {
      const specialCountyId = 'county with spaces/and-slashes';

      final mockHttp = MockClient((request) async {
        // PostgREST encodes `.eq('county_id', value)` as
        // county_id=eq.{value} in the query string.
        expect(
          request.url.queryParameters['county_id'],
          'eq.$specialCountyId',
        );
        return http.Response(
          '[]',
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = ResourceService(client: _supabaseWith(mockHttp));
      final resources = await service.getResourcesByCounty(specialCountyId);

      expect(resources, isEmpty);
    });

    test('ResourceService can be instantiated without parameters', () {
      // Supabase.instance.client is accessed lazily — instantiation alone
      // must not throw even before Supabase.initialize() has been called.
      expect(() => ResourceService(), returnsNormally);
    });
  });
}

