import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/location.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/offline_banner.dart';

// ---------------------------------------------------------------------------
// HomeScreen — state & county picker (the entry point of the app)
// ---------------------------------------------------------------------------

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  StateInfo? _selectedState;
  County? _selectedCounty;

  @override
  Widget build(BuildContext context) {
    final statesAsync = ref.watch(statesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.home, color: theme.colorScheme.onPrimary),
            const SizedBox(width: 8),
            const Text('Hestia'),
          ],
        ),
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero section
                  _HeroCard(theme: theme),
                  const SizedBox(height: 32),

                  // State picker
                  Text(
                    'Find resources near you',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  statesAsync.when(
                    data: (states) => _StateDropdown(
                      states: states,
                      selected: _selectedState,
                      onChanged: (state) {
                        setState(() {
                          _selectedState = state;
                          _selectedCounty = null;
                        });
                        if (state != null) {
                          ref
                              .read(selectedStateCodeProvider.notifier)
                              .state = state.code;
                        }
                      },
                    ),
                    loading: () =>
                        const LinearProgressIndicator(),
                    error: (e, _) => Text(
                      'Could not load states. Please check your connection.',
                      style:
                          TextStyle(color: theme.colorScheme.error),
                    ),
                  ),

                  // County picker (shown after state is selected)
                  if (_selectedState != null) ...[
                    const SizedBox(height: 16),
                    _CountyDropdown(
                      stateId: _selectedState!.id,
                      selected: _selectedCounty,
                      onChanged: (county) =>
                          setState(() => _selectedCounty = county),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Search button
                  ElevatedButton.icon(
                    onPressed: _selectedState == null
                        ? null
                        : () => _navigateToResources(context),
                    icon: const Icon(Icons.search),
                    label: const Text('Find Resources'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Category quick-picks
                  if (_selectedState != null) _QuickCategoryGrid(
                    stateCode: _selectedState!.code,
                    countyId: _selectedCounty?.id,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToResources(BuildContext context) {
    context.push(
      '/resources',
      extra: {
        'stateCode': _selectedState!.code,
        'countyId': _selectedCounty?.id,
        'category': null,
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Hero card
// ---------------------------------------------------------------------------

class _HeroCard extends StatelessWidget {
  final ThemeData theme;
  const _HeroCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Housing & Community\nResources',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Find shelters, meals, healthcare, and more — even offline.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// State dropdown
// ---------------------------------------------------------------------------

class _StateDropdown extends StatelessWidget {
  final List<StateInfo> states;
  final StateInfo? selected;
  final ValueChanged<StateInfo?> onChanged;

  const _StateDropdown({
    required this.states,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<StateInfo>(
      decoration: const InputDecoration(
        labelText: 'Select State',
        prefixIcon: Icon(Icons.map),
        border: OutlineInputBorder(),
      ),
      value: selected,
      items: states
          .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
          .toList(),
      onChanged: onChanged,
    );
  }
}

// ---------------------------------------------------------------------------
// County dropdown
// ---------------------------------------------------------------------------

class _CountyDropdown extends ConsumerWidget {
  final String stateId;
  final County? selected;
  final ValueChanged<County?> onChanged;

  const _CountyDropdown({
    required this.stateId,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countiesAsync = ref.watch(countiesProvider(stateId));

    return countiesAsync.when(
      data: (counties) => DropdownButtonFormField<County>(
        decoration: const InputDecoration(
          labelText: 'Select County (optional)',
          prefixIcon: Icon(Icons.location_on),
          border: OutlineInputBorder(),
        ),
        value: selected,
        items: [
          const DropdownMenuItem<County>(
              value: null, child: Text('All Counties')),
          ...counties.map(
            (c) => DropdownMenuItem(value: c, child: Text(c.name)),
          ),
        ],
        onChanged: onChanged,
      ),
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

// ---------------------------------------------------------------------------
// Quick category grid
// ---------------------------------------------------------------------------

class _QuickCategoryGrid extends ConsumerWidget {
  final String stateCode;
  final String? countyId;

  const _QuickCategoryGrid({
    required this.stateCode,
    this.countyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(tenantConfigProvider(stateCode));
    final theme = Theme.of(context);

    final categories = configAsync.maybeWhen(
      data: (c) => c.resourceCategories,
      orElse: () => const <String>[
        'shelter', 'food', 'healthcare', 'mental_health',
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Browse by Category',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((cat) {
            final meta = categoryMeta(cat);
            return ActionChip(
              avatar: Icon(meta.icon, size: 16),
              label: Text(meta.label),
              onPressed: () => context.push(
                '/resources',
                extra: {
                  'stateCode': stateCode,
                  'countyId': countyId,
                  'category': cat,
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
