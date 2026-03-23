import 'package:flutter/material.dart';

import '../models/resource_category.dart';

/// Immutable data produced by [DataEntryForm] on a valid submission.
@immutable
class ResourceFormData {
  final String organizationName;
  final ResourceCategory category;

  /// `null` when the user left the Address field blank.
  final String? address;

  /// Additional notes (e.g., "Must bring ID"). `null` when left blank.
  final String? notes;

  const ResourceFormData({
    required this.organizationName,
    required this.category,
    this.address,
    this.notes,
  });
}

/// A form for creating a new resource entry.
///
/// Validates required fields and calls [onSaved] with the collected
/// [ResourceFormData] when the user submits a valid form.
///
/// Organization Name and Category are required; Address and Notes are optional.
class DataEntryForm extends StatefulWidget {
  /// Called with validated form data when the user taps "Save Resource".
  /// Pass `null` if no save action is needed.
  final void Function(ResourceFormData data)? onSaved;

  const DataEntryForm({super.key, this.onSaved});

  @override
  State<DataEntryForm> createState() => _DataEntryFormState();
}

class _DataEntryFormState extends State<DataEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _organizationNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  ResourceCategory? _selectedCategory;

  @override
  void dispose() {
    _organizationNameController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final address = _addressController.text.trim();
      final notes = _notesController.text.trim();
      widget.onSaved?.call(
        ResourceFormData(
          organizationName: _organizationNameController.text.trim(),
          category: _selectedCategory!,
          address: address.isEmpty ? null : address,
          notes: notes.isEmpty ? null : notes,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _organizationNameController,
            decoration:
                const InputDecoration(labelText: 'Organization Name'),
            validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Required' : null,
          ),
          DropdownButtonFormField<ResourceCategory>(
            value: _selectedCategory,
            hint: const Text('Select Category'),
            items: ResourceCategory.values
                .map(
                  (cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(
                      cat.name[0].toUpperCase() + cat.name.substring(1),
                    ),
                  ),
                )
                .toList(),
            onChanged: (val) => setState(() => _selectedCategory = val),
            validator: (value) => value == null ? 'Required' : null,
          ),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Address'),
          ),
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notes (e.g., Must bring ID)',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Save Resource'),
          ),
        ],
      ),
    );
  }
}
