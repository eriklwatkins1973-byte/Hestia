import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/resource.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/offline_banner.dart';

// ---------------------------------------------------------------------------
// ResourceDetailScreen — full detail view for a single resource
// ---------------------------------------------------------------------------

class ResourceDetailScreen extends StatelessWidget {
  /// Pre-loaded resource passed via GoRouter extras (avoids redundant fetch)
  final Resource? resource;
  final String resourceId;

  const ResourceDetailScreen({
    super.key,
    this.resource,
    required this.resourceId,
  });

  @override
  Widget build(BuildContext context) {
    if (resource != null) {
      return _DetailView(resource: resource!);
    }

    // If no resource was passed, load it from cache or network
    return FutureBuilder<Resource?>(
      future: ResourceService.getResource(resourceId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return _DetailView(resource: snapshot.data!);
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Resource')),
          body: const Center(child: Text('Resource not found.')),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Detail view
// ---------------------------------------------------------------------------

class _DetailView extends StatelessWidget {
  final Resource resource;
  const _DetailView({required this.resource});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meta = categoryMeta(resource.category);

    return Scaffold(
      appBar: AppBar(
        title: Text(resource.name),
        actions: [
          if (resource.phone != null)
            IconButton(
              icon: const Icon(Icons.phone),
              tooltip: 'Call',
              onPressed: () => _launch('tel:${resource.phone}'),
            ),
          if (resource.website != null)
            IconButton(
              icon: const Icon(Icons.open_in_browser),
              tooltip: 'Website',
              onPressed: () => _launch(resource.website!),
            ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Chip(
                    avatar: Icon(meta.icon, size: 16),
                    label: Text(meta.label),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  if (resource.description != null) ...[
                    Text(
                      resource.description!,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Address
                  if (resource.fullAddress.isNotEmpty) ...[
                    _SectionHeader(icon: Icons.location_on, title: 'Address'),
                    InkWell(
                      onTap: () => _launch(
                        'https://maps.google.com/?q=${Uri.encodeComponent(resource.fullAddress)}',
                      ),
                      child: Text(
                        resource.fullAddress,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Contact
                  if (resource.phone != null || resource.email != null) ...[
                    _SectionHeader(icon: Icons.contact_phone, title: 'Contact'),
                    if (resource.phone != null)
                      _ContactRow(
                        icon: Icons.phone,
                        text: resource.phone!,
                        onTap: () => _launch('tel:${resource.phone}'),
                      ),
                    if (resource.email != null)
                      _ContactRow(
                        icon: Icons.email,
                        text: resource.email!,
                        onTap: () => _launch('mailto:${resource.email}'),
                      ),
                    const SizedBox(height: 20),
                  ],

                  // Hours
                  if (resource.hoursJson != null) ...[
                    _SectionHeader(
                        icon: Icons.access_time, title: 'Hours'),
                    _HoursTable(hoursJson: resource.hoursJson!),
                    const SizedBox(height: 20),
                  ],

                  // Meal schedules (church / non-profit specific)
                  if (resource.hasMealSchedules) ...[
                    _SectionHeader(
                      icon: Icons.restaurant,
                      title: 'Meal Schedule',
                    ),
                    _MealScheduleList(
                        mealSchedulesJson: resource.mealSchedulesJson!),
                    const SizedBox(height: 20),
                  ],

                  // Last verified
                  if (resource.lastVerifiedAt != null)
                    Text(
                      'Last verified: ${_formatDate(resource.lastVerifiedAt!)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  String _formatDate(DateTime dt) =>
      '${dt.month}/${dt.day}/${dt.year}';
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Contact row
// ---------------------------------------------------------------------------

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ContactRow(
      {required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hours table
// ---------------------------------------------------------------------------

class _HoursTable extends StatelessWidget {
  final String hoursJson;
  const _HoursTable({required this.hoursJson});

  @override
  Widget build(BuildContext context) {
    late Map<String, dynamic> hours;
    try {
      hours = jsonDecode(hoursJson) as Map<String, dynamic>;
    } catch (_) {
      return const Text('Hours not available.');
    }

    const dayOrder = [
      'monday', 'tuesday', 'wednesday', 'thursday',
      'friday', 'saturday', 'sunday',
    ];

    final rows = dayOrder
        .where((d) => hours.containsKey(d))
        .map((d) {
          final h = hours[d] as Map<String, dynamic>?;
          if (h == null) {
            return DataRow(cells: [
              DataCell(Text(_capitalize(d))),
              const DataCell(Text('Closed')),
            ]);
          }
          return DataRow(cells: [
            DataCell(Text(_capitalize(d))),
            DataCell(Text('${h['open']} – ${h['close']}')),
          ]);
        })
        .toList();

    return DataTable(
      columns: const [
        DataColumn(label: Text('Day')),
        DataColumn(label: Text('Hours')),
      ],
      rows: rows,
      headingRowHeight: 36,
      dataRowMinHeight: 32,
      dataRowMaxHeight: 32,
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ---------------------------------------------------------------------------
// Meal schedule list (community-powered)
// ---------------------------------------------------------------------------

class _MealScheduleList extends StatelessWidget {
  final String mealSchedulesJson;
  const _MealScheduleList({required this.mealSchedulesJson});

  @override
  Widget build(BuildContext context) {
    late List<dynamic> schedules;
    try {
      schedules = jsonDecode(mealSchedulesJson) as List<dynamic>;
    } catch (_) {
      return const Text('Schedule not available.');
    }

    if (schedules.isEmpty) return const SizedBox.shrink();

    return Column(
      children: schedules.map((s) {
        final entry = s as Map<String, dynamic>;
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.restaurant_menu),
          title: Text('${entry['day']} at ${entry['time']}'),
          subtitle: entry['description'] != null
              ? Text(entry['description'] as String)
              : null,
        );
      }).toList(),
    );
  }
}
