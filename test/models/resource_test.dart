import 'package:flutter_test/flutter_test.dart';
import 'package:hestia/models/resource.dart';
import 'package:hestia/models/resource_category.dart';

void main() {
  group('Resource', () {
    test('creates a Resource with required fields', () {
      const resource = Resource(
        id: '1',
        countyId: 'county-123',
        category: ResourceCategory.shelter,
        organizationName: 'Hope Shelter',
      );

      expect(resource.id, '1');
      expect(resource.countyId, 'county-123');
      expect(resource.category, ResourceCategory.shelter);
      expect(resource.organizationName, 'Hope Shelter');
      expect(resource.isActive, true);
    });

    test('creates a Resource with all fields', () {
      const resource = Resource(
        id: '2',
        countyId: 'county-456',
        category: ResourceCategory.meal,
        organizationName: 'Community Kitchen',
        address: '123 Main St',
        phoneNumber: '555-0100',
        websiteUrl: 'https://example.com',
        isActive: false,
      );

      expect(resource.id, '2');
      expect(resource.countyId, 'county-456');
      expect(resource.category, ResourceCategory.meal);
      expect(resource.organizationName, 'Community Kitchen');
      expect(resource.address, '123 Main St');
      expect(resource.phoneNumber, '555-0100');
      expect(resource.websiteUrl, 'https://example.com');
      expect(resource.isActive, false);
    });

    test('isActive defaults to true', () {
      const resource = Resource(
        id: '3',
        countyId: 'county-789',
        category: ResourceCategory.shelter,
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
        'address': '456 Oak Ave',
        'phone_number': '555-0200',
        'website_url': 'https://sunrise.example.com',
        'is_active': true,
      };

      final resource = Resource.fromJson(json);

      expect(resource.id, '4');
      expect(resource.countyId, 'county-101');
      expect(resource.category, ResourceCategory.shelter);
      expect(resource.organizationName, 'Sunrise Shelter');
      expect(resource.address, '456 Oak Ave');
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
        category: ResourceCategory.shelter,
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
        category: ResourceCategory.shelter,
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
        category: ResourceCategory.shelter,
        organizationName: 'Equal Shelter',
      );

      const resource2 = Resource(
        id: '8',
        countyId: 'county-505',
        category: ResourceCategory.shelter,
        organizationName: 'Equal Shelter',
      );

      expect(resource1, equals(resource2));
    });

    test('all ResourceCategory values round-trip through JSON', () {
      for (final cat in ResourceCategory.values) {
        final json = Resource(
          id: 'x',
          countyId: 'c',
          category: cat,
          organizationName: 'Org',
        ).toJson();
        final restored = Resource.fromJson(json);
        expect(restored.category, cat);
      }
    });
  });
}
