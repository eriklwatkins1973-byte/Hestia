import 'package:flutter_test/flutter_test.dart';
import 'package:hestia/models/app_state.dart';

void main() {
  group('AppState', () {
    test('creates an AppState with required fields', () {
      const state = AppState(
        id: 'state-1',
        name: 'California',
        abbreviation: 'CA',
      );

      expect(state.id, 'state-1');
      expect(state.name, 'California');
      expect(state.abbreviation, 'CA');
      expect(state.primaryColor, '#1A73E8');
      expect(state.logoUrl, isNull);
      expect(state.createdAt, isNull);
    });

    test('creates an AppState with all fields', () {
      final createdAt = DateTime(2024, 1, 15);
      final state = AppState(
        id: 'state-2',
        name: 'Texas',
        abbreviation: 'TX',
        primaryColor: '#BF5700',
        logoUrl: 'https://texas.example.com/logo.png',
        createdAt: createdAt,
      );

      expect(state.id, 'state-2');
      expect(state.name, 'Texas');
      expect(state.abbreviation, 'TX');
      expect(state.primaryColor, '#BF5700');
      expect(state.logoUrl, 'https://texas.example.com/logo.png');
      expect(state.createdAt, createdAt);
    });

    test('primaryColor defaults to #1A73E8', () {
      const state = AppState(
        id: 'state-3',
        name: 'Oregon',
        abbreviation: 'OR',
      );

      expect(state.primaryColor, '#1A73E8');
    });

    test('AppState.fromJson deserializes correctly', () {
      final json = {
        'id': 'state-4',
        'name': 'New York',
        'abbreviation': 'NY',
        'primary_color': '#003087',
        'logo_url': 'https://ny.example.com/logo.png',
        'created_at': '2024-03-01T00:00:00.000',
      };

      final state = AppState.fromJson(json);

      expect(state.id, 'state-4');
      expect(state.name, 'New York');
      expect(state.abbreviation, 'NY');
      expect(state.primaryColor, '#003087');
      expect(state.logoUrl, 'https://ny.example.com/logo.png');
      expect(state.createdAt, DateTime.parse('2024-03-01T00:00:00.000'));
    });

    test('AppState.fromJson uses default primaryColor when missing', () {
      final json = {
        'id': 'state-5',
        'name': 'Florida',
        'abbreviation': 'FL',
      };

      final state = AppState.fromJson(json);

      expect(state.primaryColor, '#1A73E8');
      expect(state.logoUrl, isNull);
      expect(state.createdAt, isNull);
    });

    test('toJson serializes correctly', () {
      final createdAt = DateTime(2024, 6, 1);
      final state = AppState(
        id: 'state-6',
        name: 'Washington',
        abbreviation: 'WA',
        primaryColor: '#4B2E83',
        logoUrl: 'https://wa.example.com/logo.png',
        createdAt: createdAt,
      );

      final json = state.toJson();

      expect(json['id'], 'state-6');
      expect(json['name'], 'Washington');
      expect(json['abbreviation'], 'WA');
      expect(json['primary_color'], '#4B2E83');
      expect(json['logo_url'], 'https://wa.example.com/logo.png');
      expect(json['created_at'], createdAt.toIso8601String());
    });

    test('copyWith creates a modified copy', () {
      const state = AppState(
        id: 'state-7',
        name: 'Colorado',
        abbreviation: 'CO',
      );

      final updated = state.copyWith(
        primaryColor: '#002868',
        logoUrl: 'https://co.example.com/logo.png',
      );

      expect(updated.id, 'state-7');
      expect(updated.name, 'Colorado');
      expect(updated.abbreviation, 'CO');
      expect(updated.primaryColor, '#002868');
      expect(updated.logoUrl, 'https://co.example.com/logo.png');
    });

    test('equality comparison works correctly', () {
      const state1 = AppState(
        id: 'state-8',
        name: 'Nevada',
        abbreviation: 'NV',
      );

      const state2 = AppState(
        id: 'state-8',
        name: 'Nevada',
        abbreviation: 'NV',
      );

      expect(state1, equals(state2));
    });
  });
}
