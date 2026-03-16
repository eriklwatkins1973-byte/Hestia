import 'package:hive_flutter/hive_flutter.dart';

import '../models/resource.dart';
import '../models/tenant_config.dart';
import '../models/location.dart';

// ---------------------------------------------------------------------------
// Box names
// ---------------------------------------------------------------------------
const _kResourcesBox = 'resources';
const _kStatesBox = 'states';
const _kCountiesBox = 'counties';
const _kTenantConfigBox = 'tenant_configs';
const _kMetaBox = 'meta';

// ---------------------------------------------------------------------------
// OfflineCacheService
//
// Wraps Hive to provide offline-first storage for resources, states,
// counties and tenant configuration data.
// ---------------------------------------------------------------------------

class OfflineCacheService {
  OfflineCacheService._();

  // Open all required Hive boxes at startup.
  static Future<void> init() async {
    // Guard against double-registration if init() is called more than once
    if (!Hive.isAdapterRegistered(ResourceAdapter().typeId)) {
      Hive.registerAdapter(ResourceAdapter());
    }

    await Future.wait([
      Hive.openBox<Resource>(_kResourcesBox),
      Hive.openBox<Map>(_kStatesBox),
      Hive.openBox<Map>(_kCountiesBox),
      Hive.openBox<Map>(_kTenantConfigBox),
      Hive.openBox<String>(_kMetaBox),
    ]);
  }

  // -----------------------------------------------------------------------
  // Resources
  // -----------------------------------------------------------------------

  static Box<Resource> get _resourcesBox =>
      Hive.box<Resource>(_kResourcesBox);

  /// Cache a list of resources keyed by their id.
  static Future<void> cacheResources(List<Resource> resources) async {
    final box = _resourcesBox;
    final map = {for (final r in resources) r.id: r};
    await box.putAll(map);
  }

  /// Return all cached resources for a given [stateId], optionally filtered
  /// by [countyId] and/or [category].
  static List<Resource> getCachedResources({
    required String stateId,
    String? countyId,
    String? category,
  }) {
    return _resourcesBox.values.where((r) {
      if (r.stateId != stateId) return false;
      if (countyId != null && r.countyId != countyId) return false;
      if (category != null && r.category != category) return false;
      return true;
    }).toList();
  }

  /// Return a single cached resource by id.
  static Resource? getCachedResource(String id) => _resourcesBox.get(id);

  /// Clear all cached resources for a given state.
  static Future<void> clearResourcesForState(String stateId) async {
    final box = _resourcesBox;
    final keysToDelete = box.keys
        .where((key) => box.get(key as String)?.stateId == stateId)
        .toList();
    await box.deleteAll(keysToDelete);
  }

  // -----------------------------------------------------------------------
  // States
  // -----------------------------------------------------------------------

  static Box<Map> get _statesBox => Hive.box<Map>(_kStatesBox);

  static Future<void> cacheStates(List<StateInfo> states) async {
    final map = {for (final s in states) s.id: s.toJson()};
    await _statesBox.putAll(map);
  }

  static List<StateInfo> getCachedStates() {
    return _statesBox.values
        .map((m) => StateInfo.fromJson(Map<String, dynamic>.from(m)))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  // -----------------------------------------------------------------------
  // Counties
  // -----------------------------------------------------------------------

  static Box<Map> get _countiesBox => Hive.box<Map>(_kCountiesBox);

  static Future<void> cacheCounties(
      String stateId, List<County> counties) async {
    final map = {for (final c in counties) c.id: c.toJson()};
    await _countiesBox.putAll(map);
  }

  static List<County> getCachedCounties(String stateId) {
    return _countiesBox.values
        .map((m) => County.fromJson(Map<String, dynamic>.from(m)))
        .where((c) => c.stateId == stateId)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  // -----------------------------------------------------------------------
  // Tenant config
  // -----------------------------------------------------------------------

  static Box<Map> get _tenantBox => Hive.box<Map>(_kTenantConfigBox);

  static Future<void> cacheTenantConfig(TenantConfig config) async {
    await _tenantBox.put(config.stateCode, {
      'state_code': config.stateCode,
      'state_name': config.stateName,
      'primary_color': config.primaryColor,
      'accent_color': config.accentColor,
      'logo_url': config.logoUrl,
      'support_email': config.supportEmail,
      'resource_categories': config.resourceCategories,
    });
  }

  static TenantConfig? getCachedTenantConfig(String stateCode) {
    final raw = _tenantBox.get(stateCode);
    if (raw == null) return null;
    return TenantConfig.fromJson(Map<String, dynamic>.from(raw));
  }

  // -----------------------------------------------------------------------
  // Sync metadata
  // -----------------------------------------------------------------------

  static Box<String> get _metaBox => Hive.box<String>(_kMetaBox);

  static Future<void> setLastSync(String stateCode, DateTime time) async {
    await _metaBox.put('last_sync_$stateCode', time.toIso8601String());
  }

  static DateTime? getLastSync(String stateCode) {
    final raw = _metaBox.get('last_sync_$stateCode');
    return raw != null ? DateTime.tryParse(raw) : null;
  }
}
