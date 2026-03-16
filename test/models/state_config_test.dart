import 'package:flutter_test/flutter_test.dart';
import 'package:hestia/models/state_config.dart';

void main() {
  group('StateConfig', () {
    test('creates instance with required fields', () {
      const config = StateConfig(
        id: '1',
        name: 'California',
        abbreviation: 'CA',
      );

      expect(config.id, '1');
      expect(config.name, 'California');
      expect(config.abbreviation, 'CA');
      expect(config.primaryColor, '#1A73E8');
      expect(config.logoUrl, isNull);
    });

    test('creates instance with all fields', () {
      const config = StateConfig(
        id: '2',
        name: 'Texas',
        abbreviation: 'TX',
        primaryColor: '#BF5700',
        logoUrl: 'https://example.com/tx-logo.png',
      );

      expect(config.id, '2');
      expect(config.name, 'Texas');
      expect(config.abbreviation, 'TX');
      expect(config.primaryColor, '#BF5700');
      expect(config.logoUrl, 'https://example.com/tx-logo.png');
    });

    group('fromJson', () {
      test('deserializes all fields from JSON', () {
        final json = {
          'id': '1',
          'name': 'California',
          'abbreviation': 'CA',
          'primary_color': '#3A7CA5',
          'logo_url': 'https://example.com/ca-logo.png',
        };

        final config = StateConfig.fromJson(json);

        expect(config.id, '1');
        expect(config.name, 'California');
        expect(config.abbreviation, 'CA');
        expect(config.primaryColor, '#3A7CA5');
        expect(config.logoUrl, 'https://example.com/ca-logo.png');
      });

      test('uses default primaryColor when primary_color is absent', () {
        final json = {
          'id': '1',
          'name': 'California',
          'abbreviation': 'CA',
        };

        final config = StateConfig.fromJson(json);

        expect(config.primaryColor, '#1A73E8');
      });

      test('allows null logoUrl when logo_url is absent', () {
        final json = {
          'id': '1',
          'name': 'California',
          'abbreviation': 'CA',
        };

        final config = StateConfig.fromJson(json);

        expect(config.logoUrl, isNull);
      });
    });

    group('toJson', () {
      test('serializes all fields to JSON', () {
        const config = StateConfig(
          id: '1',
          name: 'California',
          abbreviation: 'CA',
          primaryColor: '#3A7CA5',
          logoUrl: 'https://example.com/ca-logo.png',
        );

        final json = config.toJson();

        expect(json['id'], '1');
        expect(json['name'], 'California');
        expect(json['abbreviation'], 'CA');
        expect(json['primary_color'], '#3A7CA5');
        expect(json['logo_url'], 'https://example.com/ca-logo.png');
      });

      test('serializes null logoUrl correctly', () {
        const config = StateConfig(
          id: '1',
          name: 'California',
          abbreviation: 'CA',
        );

        final json = config.toJson();

        expect(json['logo_url'], isNull);
      });

      test('uses snake_case keys for primaryColor and logoUrl', () {
        const config = StateConfig(
          id: '1',
          name: 'California',
          abbreviation: 'CA',
          primaryColor: '#1A73E8',
          logoUrl: 'https://example.com/logo.png',
        );

        final json = config.toJson();

        expect(json.containsKey('primary_color'), isTrue);
        expect(json.containsKey('logo_url'), isTrue);
        expect(json.containsKey('primaryColor'), isFalse);
        expect(json.containsKey('logoUrl'), isFalse);
      });
    });

    group('copyWith', () {
      test('creates a new instance with updated fields', () {
        const original = StateConfig(
          id: '1',
          name: 'California',
          abbreviation: 'CA',
        );

        final updated = original.copyWith(name: 'New California');

        expect(updated.id, '1');
        expect(updated.name, 'New California');
        expect(updated.abbreviation, 'CA');
        expect(updated.primaryColor, '#1A73E8');
      });

      test('copyWith preserves unchanged fields', () {
        const original = StateConfig(
          id: '1',
          name: 'California',
          abbreviation: 'CA',
          primaryColor: '#FF0000',
          logoUrl: 'https://example.com/logo.png',
        );

        final updated = original.copyWith(id: '2');

        expect(updated.id, '2');
        expect(updated.name, 'California');
        expect(updated.abbreviation, 'CA');
        expect(updated.primaryColor, '#FF0000');
        expect(updated.logoUrl, 'https://example.com/logo.png');
      });
    });

    group('equality', () {
      test('two instances with same fields are equal', () {
        const config1 = StateConfig(
          id: '1',
          name: 'California',
          abbreviation: 'CA',
        );
        const config2 = StateConfig(
          id: '1',
          name: 'California',
          abbreviation: 'CA',
        );

        expect(config1, equals(config2));
      });

      test('two instances with different fields are not equal', () {
        const config1 = StateConfig(
          id: '1',
          name: 'California',
          abbreviation: 'CA',
        );
        const config2 = StateConfig(
          id: '2',
          name: 'Texas',
          abbreviation: 'TX',
        );

        expect(config1, isNot(equals(config2)));
      });
    });

    test('toString includes all field values', () {
      const config = StateConfig(
        id: '1',
        name: 'California',
        abbreviation: 'CA',
        primaryColor: '#1A73E8',
        logoUrl: null,
      );

      final str = config.toString();

      expect(str, contains('id: 1'));
      expect(str, contains('name: California'));
      expect(str, contains('abbreviation: CA'));
      expect(str, contains('primaryColor: #1A73E8'));
      expect(str, contains('logoUrl: null'));
    });
  });
}
