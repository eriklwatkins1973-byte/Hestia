import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../models/resource.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/offline_banner.dart';
import '../widgets/resource_card.dart';

// ---------------------------------------------------------------------------
// ResourceListScreen — shows filtered resources for a state/county/category
// ---------------------------------------------------------------------------

class ResourceListScreen extends ConsumerWidget {
  final String stateCode;
  final String? countyId;
  final String? category;

  const ResourceListScreen({
    super.key,
    required this.stateCode,
    this.countyId,
    this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = (
      stateCode: stateCode,
      countyId: countyId,
      category: category,
    );
    final resourcesAsync = ref.watch(resourcesProvider(params));
    final theme = Theme.of(context);

    final title = category != null
        ? categoryMeta(category!).label
        : 'Resources';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: BackButton(onPressed: () => context.pop()),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onPressed: () => _showFilterSheet(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          _ActiveFilterChips(
            stateCode: stateCode,
            countyId: countyId,
            category: category,
          ),
          Expanded(
            child: resourcesAsync.when(
              data: (resources) {
                if (resources.isEmpty) {
                  return const _EmptyState();
                }
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(resourcesProvider(params).future),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: resources.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ResourceCard(
                        resource: resources[index],
                        onTap: () => context.push(
                          '/resources/${resources[index].id}',
                          extra: resources[index],
                        ),
                      ),
                    ),
                  ),
                );
              },
              loading: () => _ShimmerList(theme: theme),
              error: (e, _) => _ErrorState(message: e.toString()),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _FilterSheet(
        stateCode: stateCode,
        currentCountyId: countyId,
        currentCategory: category,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Active filter chips — shows which filters are currently applied
// ---------------------------------------------------------------------------

class _ActiveFilterChips extends ConsumerWidget {
  final String stateCode;
  final String? countyId;
  final String? category;

  const _ActiveFilterChips({
    required this.stateCode,
    this.countyId,
    this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chips = <Widget>[];

    chips.add(Chip(
      avatar: const Icon(Icons.map, size: 16),
      label: Text(stateCode),
    ));

    if (countyId != null) {
      chips.add(Chip(
        avatar: const Icon(Icons.location_on, size: 16),
        label: const Text('County filtered'),
      ));
    }

    if (category != null) {
      final meta = categoryMeta(category!);
      chips.add(Chip(
        avatar: Icon(meta.icon, size: 16),
        label: Text(meta.label),
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(spacing: 8, children: chips),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter bottom sheet
// ---------------------------------------------------------------------------

class _FilterSheet extends ConsumerWidget {
  final String stateCode;
  final String? currentCountyId;
  final String? currentCategory;

  const _FilterSheet({
    required this.stateCode,
    this.currentCountyId,
    this.currentCategory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(tenantConfigProvider(stateCode));
    final categories = configAsync.maybeWhen(
      data: (c) => c.resourceCategories,
      orElse: () => const <String>[],
    );

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Resources',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'Category',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((cat) {
              final meta = categoryMeta(cat);
              final selected = currentCategory == cat;
              return FilterChip(
                avatar: Icon(meta.icon, size: 16),
                label: Text(meta.label),
                selected: selected,
                onSelected: (isSelected) {
                  context.pop();
                  context.pushReplacement(
                    '/resources',
                    extra: {
                      'stateCode': stateCode,
                      'countyId': currentCountyId,
                      'category': isSelected ? cat : null,
                    },
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty, error and shimmer states
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off,
              size: 64, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 16),
          const Text('No resources found for the selected filters.'),
          const SizedBox(height: 8),
          const Text('Try removing the county or category filter.'),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off,
                size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            const Text(
              'Could not load resources.\nShowing cached data if available.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerList extends StatelessWidget {
  final ThemeData theme;
  const _ShimmerList({required this.theme});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Shimmer.fromColors(
          baseColor: theme.colorScheme.surfaceContainerHighest,
          highlightColor: theme.colorScheme.surface,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
