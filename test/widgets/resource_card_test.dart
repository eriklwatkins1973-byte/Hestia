import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hestia/models/resource.dart';
import 'package:hestia/models/resource_category.dart';
import 'package:hestia/widgets/resource_card.dart';

/// Wraps [widget] in the minimal Material scaffolding required for widget tests.
Widget _wrap(Widget widget) {
  return MaterialApp(home: Scaffold(body: widget));
}

/// Creates a minimal [Resource] with the given [category] and optional [address].
Resource _resource({
  ResourceCategory category = ResourceCategory.shelter,
  String organizationName = 'Test Org',
  String? address,
}) {
  return Resource(
    id: 'r-1',
    countyId: 'c-1',
    category: category,
    organizationName: organizationName,
    address: address,
  );
}

void main() {
  group('ResourceCard', () {
    testWidgets('renders organisation name in bold', (tester) async {
      await tester.pumpWidget(_wrap(
        ResourceCard(resource: _resource(organizationName: 'Hope Shelter')),
      ));

      final titleFinder = find.text('Hope Shelter');
      expect(titleFinder, findsOneWidget);

      final text = tester.widget<Text>(titleFinder);
      expect(text.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('renders address when present', (tester) async {
      await tester.pumpWidget(_wrap(
        ResourceCard(
          resource: _resource(address: '123 Main St'),
        ),
      ));

      expect(find.text('123 Main St'), findsOneWidget);
    });

    testWidgets('falls back to "No address provided" when address is null',
        (tester) async {
      await tester.pumpWidget(_wrap(
        ResourceCard(resource: _resource()),
      ));

      expect(find.text('No address provided'), findsOneWidget);
    });

    testWidgets('shows restaurant icon for meal category', (tester) async {
      await tester.pumpWidget(_wrap(
        ResourceCard(resource: _resource(category: ResourceCategory.meal)),
      ));

      expect(
        find.byWidgetPredicate(
          (w) => w is Icon && w.icon == Icons.restaurant,
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows bed icon for shelter category', (tester) async {
      await tester.pumpWidget(_wrap(
        ResourceCard(resource: _resource(category: ResourceCategory.shelter)),
      ));

      expect(
        find.byWidgetPredicate(
          (w) => w is Icon && w.icon == Icons.bed,
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows local_hospital icon for healthcare category',
        (tester) async {
      await tester.pumpWidget(_wrap(
        ResourceCard(
            resource: _resource(category: ResourceCategory.healthcare)),
      ));

      expect(
        find.byWidgetPredicate(
          (w) => w is Icon && w.icon == Icons.local_hospital,
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows gavel icon for legal category', (tester) async {
      await tester.pumpWidget(_wrap(
        ResourceCard(resource: _resource(category: ResourceCategory.legal)),
      ));

      expect(
        find.byWidgetPredicate(
          (w) => w is Icon && w.icon == Icons.gavel,
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows help_outline icon for other category', (tester) async {
      await tester.pumpWidget(_wrap(
        ResourceCard(resource: _resource(category: ResourceCategory.other)),
      ));

      expect(
        find.byWidgetPredicate(
          (w) => w is Icon && w.icon == Icons.help_outline,
        ),
        findsOneWidget,
      );
    });

    testWidgets('always shows arrow_forward_ios trailing icon', (tester) async {
      await tester.pumpWidget(_wrap(
        ResourceCard(resource: _resource()),
      ));

      expect(
        find.byWidgetPredicate(
          (w) => w is Icon && w.icon == Icons.arrow_forward_ios,
        ),
        findsOneWidget,
      );
    });

    testWidgets('onTap callback is invoked when card is tapped',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        ResourceCard(
          resource: _resource(),
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.byType(ListTile));
      expect(tapped, isTrue);
    });

    testWidgets('card is not tappable when onTap is null', (tester) async {
      await tester.pumpWidget(_wrap(
        ResourceCard(resource: _resource()),
      ));

      // Tapping should not throw even without an onTap handler.
      await tester.tap(find.byType(ListTile));
      await tester.pump();
    });

    testWidgets('iconForCategory returns correct icon for every category',
        (tester) async {
      const expected = {
        ResourceCategory.meal: Icons.restaurant,
        ResourceCategory.shelter: Icons.bed,
        ResourceCategory.healthcare: Icons.local_hospital,
        ResourceCategory.legal: Icons.gavel,
        ResourceCategory.other: Icons.help_outline,
      };

      for (final entry in expected.entries) {
        expect(
          ResourceCard.iconForCategory(entry.key),
          entry.value,
          reason: 'Wrong icon for ${entry.key}',
        );
      }
    });
  });
}
