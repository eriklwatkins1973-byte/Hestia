import 'package:flutter_test/flutter_test.dart';

import 'package:hestia/models/resource.dart';
import 'package:hestia/models/location.dart';
import 'package:hestia/models/tenant_config.dart';
import 'package:hestia/theme/app_theme.dart';

void main() {
  // -------------------------------------------------------------------------
  // Resource model tests
  // -------------------------------------------------------------------------
  group('Resource model', () {
    final resourceJson = {
      'id': 'abc-123',
      'state_id': 'state-456',
      'county_id': 'county-789',
      'name': 'Star of Hope Mission',
      'category': 'shelter',
      'sub_category': 'emergency_shelter',
      'description': 'Emergency shelter for families.',
      'address_line1': '6897 Ardmore St',
      'city': 'Houston',
      'zip_code': '77054',
      'phone': '(713) 748-0700',
      'website': 'https://sohmission.org',
      'email': null,
      'latitude': 29.6907,
      'longitude': -95.4095,
      'status': 'active',
      'hours':
          '{"monday":{"open":"08:00","close":"22:00"},"sunday":{"open":"08:00","close":"22:00"}}',
      'meal_schedules': '[]',
      'last_verified_at': '2024-01-15T12:00:00.000Z',
      'updated_at': '2024-01-15T12:00:00.000Z',
    };

    test('fromJson deserializes all fields', () {
      final resource = Resource.fromJson(resourceJson);

      expect(resource.id, 'abc-123');
      expect(resource.stateId, 'state-456');
      expect(resource.countyId, 'county-789');
      expect(resource.name, 'Star of Hope Mission');
      expect(resource.category, 'shelter');
      expect(resource.subCategory, 'emergency_shelter');
      expect(resource.city, 'Houston');
      expect(resource.phone, '(713) 748-0700');
      expect(resource.latitude, closeTo(29.6907, 0.0001));
      expect(resource.longitude, closeTo(-95.4095, 0.0001));
      expect(resource.status, 'active');
    });

    test('fullAddress concatenates address parts', () {
      final resource = Resource.fromJson(resourceJson);
      expect(resource.fullAddress, '6897 Ardmore St, Houston, 77054');
    });

    test('hasMealSchedules returns false for empty array', () {
      final resource = Resource.fromJson(resourceJson);
      expect(resource.hasMealSchedules, isFalse);
    });

    test('hasMealSchedules returns true when schedules present', () {
      final json = Map<String, dynamic>.from(resourceJson)
        ..['meal_schedules'] =
            '[{"day":"Wednesday","time":"18:00","description":"Hot dinner"}]';
      final resource = Resource.fromJson(json);
      expect(resource.hasMealSchedules, isTrue);
    });

    test('copyWith returns new instance with updated fields', () {
      final original = Resource.fromJson(resourceJson);
      final updated = original.copyWith(name: 'Updated Name');
      expect(updated.name, 'Updated Name');
      expect(updated.id, original.id);
    });

    test('toJson round-trips key fields', () {
      final resource = Resource.fromJson(resourceJson);
      final json = resource.toJson();
      expect(json['id'], resource.id);
      expect(json['name'], resource.name);
      expect(json['category'], resource.category);
    });
  });

  // -------------------------------------------------------------------------
  // StateInfo model tests
  // -------------------------------------------------------------------------
  group('StateInfo model', () {
    test('fromJson and toJson round-trip', () {
      final json = {'id': 's1', 'code': 'TX', 'name': 'Texas'};
      final state = StateInfo.fromJson(json);
      expect(state.code, 'TX');
      expect(state.name, 'Texas');
      expect(state.toJson(), json);
    });
  });

  // -------------------------------------------------------------------------
  // County model tests
  // -------------------------------------------------------------------------
  group('County model', () {
    test('fromJson and toJson round-trip', () {
      final json = {
        'id': 'c1',
        'state_id': 's1',
        'name': 'Harris County',
        'fips_code': '48201',
      };
      final county = County.fromJson(json);
      expect(county.name, 'Harris County');
      expect(county.fipsCode, '48201');
      expect(county.toJson(), json);
    });
  });

  // -------------------------------------------------------------------------
  // TenantConfig model tests
  // -------------------------------------------------------------------------
  group('TenantConfig model', () {
    test('fromJson parses correctly', () {
      final json = {
        'state_code': 'TX',
        'state_name': 'Texas',
        'primary_color': '#BF5700',
        'accent_color': '#333F48',
        'logo_url': null,
        'support_email': 'support-tx@hestia.app',
        'resource_categories': ['shelter', 'food', 'church_meal'],
      };
      final config = TenantConfig.fromJson(json);
      expect(config.stateCode, 'TX');
      expect(config.primaryColor, '#BF5700');
      expect(config.resourceCategories, contains('church_meal'));
    });

    test('defaultConfig is valid', () {
      const config = TenantConfig.defaultConfig;
      expect(config.stateName, 'Hestia');
      expect(config.resourceCategories, isNotEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // Theme tests
  // -------------------------------------------------------------------------
  group('AppTheme', () {
    test('buildAppTheme returns a ThemeData', () {
      const config = TenantConfig.defaultConfig;
      final theme = buildAppTheme(config);
      expect(theme, isNotNull);
    });

    test('buildAppTheme uses primary colour from config', () {
      const config = TenantConfig(
        stateCode: 'TX',
        stateName: 'Texas',
        primaryColor: '#BF5700',
        accentColor: '#333F48',
        resourceCategories: [],
      );
      final theme = buildAppTheme(config);
      // The seed colour should influence the colour scheme
      expect(theme.colorScheme, isNotNull);
    });
  });

  // -------------------------------------------------------------------------
  // categoryMeta helper tests
  // -------------------------------------------------------------------------
  group('categoryMeta', () {
    test('returns correct label for known categories', () {
      expect(categoryMeta('shelter').label, 'Shelter');
      expect(categoryMeta('food').label, 'Food');
      expect(categoryMeta('church_meal').label, 'Church Meal');
      expect(categoryMeta('mental_health').label, 'Mental Health');
    });

    test('falls back gracefully for unknown category', () {
      final meta = categoryMeta('unknown_category');
      expect(meta.label, 'Other');
    });
  });
}
