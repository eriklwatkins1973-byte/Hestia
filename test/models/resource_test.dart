import 'package:flutter_test/flutter_test.dart';
import 'package:hestia/models/resource.dart';

void main() {
  group('Resource', () {
    test('creates a Resource with required fields', () {
      const resource = Resource(
        id: '1',
        countyId: 'county-123',
        category: 'shelter',
        organizationName: 'Hope Shelter',
      );

      expect(resource.id, '1');
      expect(resource.countyId, 'county-123');
      expect(resource.category, 'shelter');
      expect(resource.organizationName, 'Hope Shelter');
      expect(resource.isActive, true);
    });

    test('creates a Resource with all fields', () {
      const resource = Resource(
        id: '2',
        countyId: 'county-456',
        category: 'meal',
        organizationName: 'Community Kitchen',
        description: 'Hot meals served daily',
        address: '123 Main St',
        latitude: 37.7749,
        longitude: -122.4194,
        phoneNumber: '555-0100',
        websiteUrl: 'https://example.com',
        isActive: false,
      );

      expect(resource.id, '2');
      expect(resource.countyId, 'county-456');
      expect(resource.category, 'meal');
      expect(resource.organizationName, 'Community Kitchen');
      expect(resource.description, 'Hot meals served daily');
      expect(resource.address, '123 Main St');
      expect(resource.latitude, 37.7749);
      expect(resource.longitude, -122.4194);
      expect(resource.phoneNumber, '555-0100');
      expect(resource.websiteUrl, 'https://example.com');
      expect(resource.isActive, false);
    });

    test('isActive defaults to true', () {
      const resource = Resource(
        id: '3',
        countyId: 'county-789',
        category: 'shelter',
        organizationName: 'Safe Haven',
      );

      expect(resource.isActive, true);
    });

    test('Resource.fromJson deserializes correctly', () {
      final json = {
        'id': '4',
        'county_id': 'county-101',
        'category': 'shelter',
        'organization_name': 'Sunrise Shelter',
        'description': 'Safe overnight stay',
        'address': '456 Oak Ave',
        'latitude': 34.0522,
        'longitude': -118.2437,
        'phone_number': '555-0200',
        'website_url': 'https://sunrise.example.com',
        'is_active': true,
      };

      final resource = Resource.fromJson(json);

      expect(resource.id, '4');
      expect(resource.countyId, 'county-101');
      expect(resource.category, 'shelter');
      expect(resource.organizationName, 'Sunrise Shelter');
      expect(resource.description, 'Safe overnight stay');
      expect(resource.address, '456 Oak Ave');
      expect(resource.latitude, 34.0522);
      expect(resource.longitude, -118.2437);
      expect(resource.phoneNumber, '555-0200');
      expect(resource.websiteUrl, 'https://sunrise.example.com');
      expect(resource.isActive, true);
    });

    test('Resource.fromJson uses default isActive=true when missing', () {
      final json = {
        'id': '5',
        'county_id': 'county-202',
        'category': 'meal',
        'organization_name': 'Daily Bread',
      };

      final resource = Resource.fromJson(json);

      expect(resource.isActive, true);
    });

    test('toJson serializes correctly', () {
      const resource = Resource(
        id: '6',
        countyId: 'county-303',
        category: 'shelter',
        organizationName: 'Harbor House',
        phoneNumber: '555-0300',
        websiteUrl: 'https://harbor.example.com',
      );

      final json = resource.toJson();

      expect(json['id'], '6');
      expect(json['county_id'], 'county-303');
      expect(json['category'], 'shelter');
      expect(json['organization_name'], 'Harbor House');
      expect(json['phone_number'], '555-0300');
      expect(json['website_url'], 'https://harbor.example.com');
      expect(json['is_active'], true);
    });

    test('copyWith creates a modified copy', () {
      const resource = Resource(
        id: '7',
        countyId: 'county-404',
        category: 'shelter',
        organizationName: 'City Shelter',
      );

      final updated = resource.copyWith(
        organizationName: 'City Shelter Updated',
        isActive: false,
      );

      expect(updated.id, '7');
      expect(updated.organizationName, 'City Shelter Updated');
      expect(updated.isActive, false);
      expect(updated.countyId, 'county-404');
    });

    test('equality comparison works correctly', () {
      const resource1 = Resource(
        id: '8',
        countyId: 'county-505',
        category: 'shelter',
        organizationName: 'Equal Shelter',
      );

      const resource2 = Resource(
        id: '8',
        countyId: 'county-505',
        category: 'shelter',
        organizationName: 'Equal Shelter',
      );

      expect(resource1, equals(resource2));
    });
  });
}
