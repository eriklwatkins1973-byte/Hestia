import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:hestia/models/resource_category.dart';
import 'package:hestia/services/resource_service.dart';

void main() {
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
      final mockClient = MockClient((request) async {
        expect(
          request.url.toString(),
          contains('county_id=some-county-uuid'),
        );
        return http.Response(jsonEncode([sampleResourceJson]), 200);
      });

      final service = ResourceService(client: mockClient);
      final resources = await service.getResourcesByCounty(countyId);

      expect(resources.length, 1);
      expect(resources.first.id, 'res-1');
      expect(resources.first.countyId, countyId);
      expect(resources.first.category, ResourceCategory.shelter);
      expect(resources.first.organizationName, 'Hope Shelter');
      expect(resources.first.isActive, true);
    });

    test('getResourcesByCounty returns an empty list when no resources', () async {
      final mockClient = MockClient((_) async => http.Response('[]', 200));

      final service = ResourceService(client: mockClient);
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

      final mockClient = MockClient((_) async =>
          http.Response(jsonEncode([sampleResourceJson, secondResource]), 200));

      final service = ResourceService(client: mockClient);
      final resources = await service.getResourcesByCounty(countyId);

      expect(resources.length, 2);
      expect(resources[0].id, 'res-1');
      expect(resources[1].id, 'res-2');
      expect(resources[1].category, ResourceCategory.meal);
    });

    test('getResourcesByCounty throws on non-200 response', () async {
      final mockClient = MockClient(
        (_) async => http.Response('Not Found', 404),
      );

      final service = ResourceService(client: mockClient);

      expect(
        () => service.getResourcesByCounty(countyId),
        throwsException,
      );
    });

    test('getResourcesByCounty throws on server error', () async {
      final mockClient = MockClient(
        (_) async => http.Response('Internal Server Error', 500),
      );

      final service = ResourceService(client: mockClient);

      expect(
        () => service.getResourcesByCounty(countyId),
        throwsException,
      );
    });

    test('getResourcesByCounty URL-encodes countyId', () async {
      const specialCountyId = 'county with spaces/and-slashes';

      final mockClient = MockClient((request) async {
        expect(request.url.queryParameters['county_id'], specialCountyId);
        return http.Response('[]', 200);
      });

      final service = ResourceService(client: mockClient);
      final resources = await service.getResourcesByCounty(specialCountyId);

      expect(resources, isEmpty);
    });

    test('ResourceService can be instantiated without parameters', () {
      expect(() => ResourceService(), returnsNormally);
    });
  });
}
