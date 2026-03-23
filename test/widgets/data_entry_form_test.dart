import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hestia/models/resource_category.dart';
import 'package:hestia/widgets/data_entry_form.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Wraps [widget] in the minimal Material scaffolding required by form tests.
/// The [SingleChildScrollView] prevents overflow errors caused by the soft
/// keyboard opening during text entry in the test environment.
Widget _wrap(Widget widget) => MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: widget),
      ),
    );

/// Enters text into the nth [TextFormField] in the widget tree (0-based).
Future<void> _enterText(WidgetTester tester, int index, String text) async {
  await tester.enterText(find.byType(TextFormField).at(index), text);
}

/// Opens the category dropdown and selects [category].
Future<void> _selectCategory(
    WidgetTester tester, ResourceCategory category) async {
  await tester
      .tap(find.byType(DropdownButtonFormField<ResourceCategory>));
  await tester.pumpAndSettle();
  final label = category.name[0].toUpperCase() + category.name.substring(1);
  // Use last to target the item in the open overlay, not the button label.
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

/// Taps the "Save Resource" button and processes one frame.
Future<void> _tapSave(WidgetTester tester) async {
  await tester.tap(find.text('Save Resource'));
  await tester.pump();
}

// ---------------------------------------------------------------------------
// Field order constants (matches the Column in DataEntryForm)
// ---------------------------------------------------------------------------
const _orgNameIndex = 0;
const _addressIndex = 1;
const _notesIndex = 2;

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('DataEntryForm', () {
    // -----------------------------------------------------------------------
    // Rendering
    // -----------------------------------------------------------------------

    testWidgets('renders Organization Name field', (tester) async {
      await tester.pumpWidget(_wrap(const DataEntryForm()));

      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('Organization Name'), findsOneWidget);
    });

    testWidgets('renders category dropdown with "Select Category" hint',
        (tester) async {
      await tester.pumpWidget(_wrap(const DataEntryForm()));

      expect(
          find.byType(DropdownButtonFormField<ResourceCategory>),
          findsOneWidget);
      expect(find.text('Select Category'), findsOneWidget);
    });

    testWidgets('renders Address field', (tester) async {
      await tester.pumpWidget(_wrap(const DataEntryForm()));

      expect(find.text('Address'), findsOneWidget);
    });

    testWidgets('renders Notes field', (tester) async {
      await tester.pumpWidget(_wrap(const DataEntryForm()));

      expect(find.text('Notes (e.g., Must bring ID)'), findsOneWidget);
    });

    testWidgets('Notes field has maxLines 3', (tester) async {
      await tester.pumpWidget(_wrap(const DataEntryForm()));

      final notesField = tester.widget<TextField>(
        find.descendant(
          of: find.byType(TextFormField).at(_notesIndex),
          matching: find.byType(TextField),
        ),
      );
      expect(notesField.maxLines, 3);
    });

    testWidgets('renders "Save Resource" button', (tester) async {
      await tester.pumpWidget(_wrap(const DataEntryForm()));

      expect(find.text('Save Resource'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('dropdown lists every ResourceCategory value', (tester) async {
      await tester.pumpWidget(_wrap(const DataEntryForm()));

      await tester
          .tap(find.byType(DropdownButtonFormField<ResourceCategory>));
      await tester.pumpAndSettle();

      for (final cat in ResourceCategory.values) {
        final label =
            cat.name[0].toUpperCase() + cat.name.substring(1);
        expect(find.text(label), findsAtLeastNWidgets(1),
            reason: 'Expected "$label" in dropdown');
      }
    });

    // -----------------------------------------------------------------------
    // Validation — required fields
    // -----------------------------------------------------------------------

    testWidgets(
        'shows "Required" error for Organization Name when submitted empty',
        (tester) async {
      await tester.pumpWidget(_wrap(const DataEntryForm()));
      await _tapSave(tester);

      // At least one "Required" error is shown (org name + category).
      expect(find.text('Required'), findsAtLeastNWidgets(1));
    });

    testWidgets(
        'shows "Required" error for Category when not selected on submit',
        (tester) async {
      await tester.pumpWidget(_wrap(const DataEntryForm()));
      // Fill org name so only the category validator fires alone.
      await _enterText(tester, _orgNameIndex, 'Hope Shelter');
      await _tapSave(tester);

      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets(
        'shows "Required" error for Organization Name when only category is filled',
        (tester) async {
      await tester.pumpWidget(_wrap(const DataEntryForm()));
      await _selectCategory(tester, ResourceCategory.meal);
      await _tapSave(tester);

      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('shows no validation errors when all required fields are filled',
        (tester) async {
      await tester.pumpWidget(_wrap(DataEntryForm(onSaved: (_) {})));
      await _enterText(tester, _orgNameIndex, 'Hope Shelter');
      await _selectCategory(tester, ResourceCategory.shelter);
      await _tapSave(tester);

      expect(find.text('Required'), findsNothing);
    });

    testWidgets(
        'trims whitespace — all-space Organization Name is treated as empty',
        (tester) async {
      await tester.pumpWidget(_wrap(const DataEntryForm()));
      await _enterText(tester, _orgNameIndex, '   ');
      await _tapSave(tester);

      expect(find.text('Required'), findsAtLeastNWidgets(1));
    });

    // -----------------------------------------------------------------------
    // onSaved callback
    // -----------------------------------------------------------------------

    testWidgets('does not call onSaved when form is invalid', (tester) async {
      var called = false;
      await tester
          .pumpWidget(_wrap(DataEntryForm(onSaved: (_) => called = true)));
      await _tapSave(tester);

      expect(called, isFalse);
    });

    testWidgets('calls onSaved with correct data when form is valid',
        (tester) async {
      ResourceFormData? captured;
      await tester.pumpWidget(
          _wrap(DataEntryForm(onSaved: (data) => captured = data)));

      await _enterText(tester, _orgNameIndex, 'Hope Shelter');
      await _selectCategory(tester, ResourceCategory.shelter);
      await _enterText(tester, _addressIndex, '123 Main St');
      await _enterText(tester, _notesIndex, 'Must bring ID');
      await _tapSave(tester);

      expect(captured, isNotNull);
      expect(captured!.organizationName, 'Hope Shelter');
      expect(captured!.category, ResourceCategory.shelter);
      expect(captured!.address, '123 Main St');
      expect(captured!.notes, 'Must bring ID');
    });

    testWidgets('onSaved receives null address and notes when left blank',
        (tester) async {
      ResourceFormData? captured;
      await tester.pumpWidget(
          _wrap(DataEntryForm(onSaved: (data) => captured = data)));

      await _enterText(tester, _orgNameIndex, 'Hope Shelter');
      await _selectCategory(tester, ResourceCategory.shelter);
      await _tapSave(tester);

      expect(captured, isNotNull);
      expect(captured!.address, isNull);
      expect(captured!.notes, isNull);
    });

    testWidgets('onSaved trims leading/trailing whitespace from org name',
        (tester) async {
      ResourceFormData? captured;
      await tester.pumpWidget(
          _wrap(DataEntryForm(onSaved: (data) => captured = data)));

      await _enterText(tester, _orgNameIndex, '  Hope Shelter  ');
      await _selectCategory(tester, ResourceCategory.shelter);
      await _tapSave(tester);

      expect(captured!.organizationName, 'Hope Shelter');
    });

    testWidgets('onSaved works for every ResourceCategory value',
        (tester) async {
      for (final category in ResourceCategory.values) {
        ResourceFormData? captured;
        await tester.pumpWidget(
            _wrap(DataEntryForm(onSaved: (data) => captured = data)));

        await _enterText(tester, _orgNameIndex, 'Test Org');
        await _selectCategory(tester, category);
        await _tapSave(tester);

        expect(captured?.category, category,
            reason: 'Expected category $category');
      }
    });

    // -----------------------------------------------------------------------
    // State management
    // -----------------------------------------------------------------------

    testWidgets('selected category is reflected in the dropdown button',
        (tester) async {
      await tester.pumpWidget(_wrap(const DataEntryForm()));
      await _selectCategory(tester, ResourceCategory.meal);

      // After selection the button label should show "Meal".
      expect(find.text('Meal'), findsOneWidget);
    });

    testWidgets('form does not call onSaved when onSaved is null',
        (tester) async {
      // Verifies that calling _submit without an onSaved callback does not throw.
      await tester.pumpWidget(_wrap(const DataEntryForm()));
      await _enterText(tester, _orgNameIndex, 'Hope Shelter');
      await _selectCategory(tester, ResourceCategory.shelter);
      await _tapSave(tester);
      // No exception expected.
    });
  });
}
