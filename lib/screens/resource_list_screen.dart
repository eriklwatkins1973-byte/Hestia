import 'package:flutter/material.dart';

import '../models/resource.dart';
import '../services/resource_service.dart';
import '../widgets/resource_card.dart';

/// Screen that lists all active resources for a given [countyId].
///
/// Fetches data via [ResourceService] and renders each result with a
/// [ResourceCard].
class ResourceListScreen extends StatefulWidget {
  final String countyId;

  /// Service used to fetch resources. Defaults to a [ResourceService] with
  /// its standard configuration; callers may supply an alternative instance
  /// (e.g. with a mock HTTP client) for testing.
  final ResourceService resourceService;

  ResourceListScreen({
    super.key,
    required this.countyId,
    ResourceService? resourceService,
  }) : resourceService = resourceService ?? ResourceService();

  @override
  State<ResourceListScreen> createState() => _ResourceListScreenState();
}

class _ResourceListScreenState extends State<ResourceListScreen> {
  late final Future<List<Resource>> _resourcesFuture;

  @override
  void initState() {
    super.initState();
    _resourcesFuture =
        widget.resourceService.getResourcesByCounty(widget.countyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resources')),
      body: FutureBuilder<List<Resource>>(
        future: _resourcesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final resources = snapshot.data ?? [];

          if (resources.isEmpty) {
            return const Center(child: Text('No resources found.'));
          }

          return ListView.builder(
            itemCount: resources.length,
            itemBuilder: (context, index) =>
                ResourceCard(resource: resources[index]),
          );
        },
      ),
    );
  }
}
