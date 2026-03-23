import 'package:flutter_test/flutter_test.dart';
import 'package:hestia/models/county.dart';

void main() {
  group('County', () {
    test('creates a County with all required fields', () {
      const county = County(
        id: 'county-1',
        stateId: 'state-ca',
        name: 'Los Angeles',
      );

      expect(county.id, 'county-1');
      expect(county.stateId, 'state-ca');
      expect(county.name, 'Los Angeles');
    });

    test('County.fromJson deserializes correctly', () {
      final json = {
        'id': 'county-2',
        'state_id': 'state-tx',
        'name': 'Harris',
      };

      final county = County.fromJson(json);

      expect(county.id, 'county-2');
      expect(county.stateId, 'state-tx');
      expect(county.name, 'Harris');
    });

    test('toJson serializes correctly', () {
      const county = County(
        id: 'county-3',
        stateId: 'state-ny',
        name: 'Kings',
      );

      final json = county.toJson();

      expect(json['id'], 'county-3');
      expect(json['state_id'], 'state-ny');
      expect(json['name'], 'Kings');
    });

    test('copyWith creates a modified copy', () {
      const county = County(
        id: 'county-4',
        stateId: 'state-fl',
        name: 'Miami-Dade',
      );

      final updated = county.copyWith(name: 'Broward');

      expect(updated.id, 'county-4');
      expect(updated.stateId, 'state-fl');
      expect(updated.name, 'Broward');
    });

    test('equality comparison works correctly', () {
      const county1 = County(
        id: 'county-5',
        stateId: 'state-wa',
        name: 'King',
      );

      const county2 = County(
        id: 'county-5',
        stateId: 'state-wa',
        name: 'King',
      );

      expect(county1, equals(county2));
    });
  });
}
