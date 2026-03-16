import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tenant_config.dart';
import '../services/supabase_service.dart';

// ---------------------------------------------------------------------------
// Category metadata — icons and human-readable labels
// ---------------------------------------------------------------------------

class CategoryMeta {
  final String label;
  final IconData icon;
  const CategoryMeta({required this.label, required this.icon});
}

const Map<String, CategoryMeta> kCategoryMeta = {
  'shelter': CategoryMeta(label: 'Shelter', icon: Icons.home),
  'food': CategoryMeta(label: 'Food', icon: Icons.restaurant),
  'church_meal':
      CategoryMeta(label: 'Church Meal', icon: Icons.church),
  'healthcare':
      CategoryMeta(label: 'Healthcare', icon: Icons.local_hospital),
  'mental_health':
      CategoryMeta(label: 'Mental Health', icon: Icons.psychology),
  'substance_use':
      CategoryMeta(label: 'Substance Use', icon: Icons.healing),
  'employment':
      CategoryMeta(label: 'Employment', icon: Icons.work),
  'legal': CategoryMeta(label: 'Legal Aid', icon: Icons.gavel),
  'transportation':
      CategoryMeta(label: 'Transportation', icon: Icons.directions_bus),
  'clothing':
      CategoryMeta(label: 'Clothing', icon: Icons.checkroom),
  'drop_in_center':
      CategoryMeta(label: 'Drop-In Center', icon: Icons.meeting_room),
};

CategoryMeta categoryMeta(String category) =>
    kCategoryMeta[category] ??
    const CategoryMeta(label: 'Other', icon: Icons.info_outline);

// ---------------------------------------------------------------------------
// AppTheme — builds a ThemeData from a TenantConfig colour scheme
// ---------------------------------------------------------------------------

ThemeData buildAppTheme(TenantConfig config) {
  final primary = _hexToColor(config.primaryColor);
  final accent = _hexToColor(config.accentColor);

  final colorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    secondary: accent,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      selectedColor: colorScheme.primaryContainer,
      labelStyle: const TextStyle(fontSize: 13),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

Color _hexToColor(String hex) {
  final sanitized = hex.replaceAll('#', '');
  final value = int.tryParse('FF$sanitized', radix: 16) ?? 0xFF1976D2;
  return Color(value);
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final appThemeProvider = Provider<ThemeData>((ref) {
  final stateCode = ref.watch(selectedStateCodeProvider);
  if (stateCode == null) return buildAppTheme(TenantConfig.defaultConfig);

  final configAsync = ref.watch(tenantConfigProvider(stateCode));
  return configAsync.maybeWhen(
    data: buildAppTheme,
    orElse: () => buildAppTheme(TenantConfig.defaultConfig),
  );
});
