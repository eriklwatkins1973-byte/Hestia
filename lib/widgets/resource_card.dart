import 'package:flutter/material.dart';

import '../models/resource.dart';
import '../models/resource_category.dart';

/// A card widget that displays a summary of a [Resource].
///
/// Shows a category icon, the organization name, and the address (falling
/// back to "No address provided" when absent). Tapping the card invokes the
/// optional [onTap] callback.
class ResourceCard extends StatelessWidget {
  final Resource resource;

  /// Called when the user taps the card. Pass `null` to disable tapping.
  final VoidCallback? onTap;

  const ResourceCard({
    super.key,
    required this.resource,
    this.onTap,
  });

  /// Returns the icon that best represents each [ResourceCategory].
  static IconData iconForCategory(ResourceCategory category) {
    switch (category) {
      case ResourceCategory.meal:
        return Icons.restaurant;
      case ResourceCategory.shelter:
        return Icons.bed;
      case ResourceCategory.healthcare:
        return Icons.local_hospital;
      case ResourceCategory.legal:
        return Icons.gavel;
      case ResourceCategory.other:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: Icon(
          iconForCategory(resource.category),
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          resource.organizationName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(resource.address ?? 'No address provided'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
