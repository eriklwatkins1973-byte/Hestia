import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/location.dart';
import '../models/resource.dart';
import '../models/tenant_config.dart';
import 'offline_cache_service.dart';

// ---------------------------------------------------------------------------
// Connectivity provider
// ---------------------------------------------------------------------------

final connectivityProvider = StreamProvider<bool>((ref) {
  return Connectivity()
      .onConnectivityChanged
      .map((results) => !results.contains(ConnectivityResult.none) &&
          results.isNotEmpty);
});

// ---------------------------------------------------------------------------
// ResourceService — loads resources from Supabase with offline fallback
// ---------------------------------------------------------------------------

class ResourceService {
  final _supabase = Supabase.instance.client;

  /// Fetches all active resources for a specific county, with offline fallback.
  Future<List<Resource>> getResourcesByCounty(String countyId) async {
    try {
      final response = await _supabase
          .from('resources')
          .select()
          .eq('county_id', countyId)
          .eq('status', 'active')
          .order('name');
      final resources =
          (response as List).map((r) => Resource.fromJson(r)).toList();
      await OfflineCacheService.cacheResources(resources);
      return resources;
    } catch (_) {
      return OfflineCacheService.getCachedResources(countyId: countyId);
    }
  }

  /// Fetches resources filtered by state, optionally county and category.
  /// Falls back to local Hive cache when the device is offline.
  Future<List<Resource>> getResources({
    required String stateCode,
    String? countyId,
    String? category,
    DateTime? updatedAfter,
  }) async {
    // Resolve state id from local cache first to avoid extra network calls
    final states = OfflineCacheService.getCachedStates();
    final stateInfo = states.firstWhere(
      (s) => s.code == stateCode,
      orElse: () => const StateInfo(id: '', code: '', name: ''),
    );

    try {
      var query = _supabase
          .from('resources')
          .select()
          .eq('status', 'active');

      if (stateInfo.id.isNotEmpty) {
        query = query.eq('state_id', stateInfo.id);
      }
      if (countyId != null) {
        query = query.eq('county_id', countyId);
      }
      if (category != null) {
        query = query.eq('category', category);
      }
      if (updatedAfter != null) {
        query = query.gt('updated_at', updatedAfter.toIso8601String());
      }

      final response = await query.order('name');
      final resources =
          (response as List).map((r) => Resource.fromJson(r)).toList();

      // Update local cache
      await OfflineCacheService.cacheResources(resources);
      if (stateInfo.id.isNotEmpty) {
        await OfflineCacheService.setLastSync(stateCode, DateTime.now());
      }

      return resources;
    } catch (_) {
      // Offline fallback — return whatever is in the local cache
      if (stateInfo.id.isEmpty) return [];
      return OfflineCacheService.getCachedResources(
        stateId: stateInfo.id,
        countyId: countyId,
        category: category,
      );
    }
  }

  /// Fetches a single resource by id (with offline fallback).
  Future<Resource?> getResource(String id) async {
    try {
      final response =
          await _supabase.from('resources').select().eq('id', id).single();
      final resource = Resource.fromJson(response);
      await OfflineCacheService.cacheResources([resource]);
      return resource;
    } catch (_) {
      return OfflineCacheService.getCachedResource(id);
    }
  }
}

// ---------------------------------------------------------------------------
// LocationService — loads states and counties
// ---------------------------------------------------------------------------

class LocationService {
  static final _supabase = Supabase.instance.client;

  static Future<List<StateInfo>> getStates() async {
    try {
      final response =
          await _supabase.from('states').select().order('name');
      final states =
          (response as List).map((s) => StateInfo.fromJson(s)).toList();
      await OfflineCacheService.cacheStates(states);
      return states;
    } catch (_) {
      return OfflineCacheService.getCachedStates();
    }
  }

  static Future<List<County>> getCounties(String stateId) async {
    try {
      final response = await _supabase
          .from('counties')
          .select()
          .eq('state_id', stateId)
          .order('name');
      final counties =
          (response as List).map((c) => County.fromJson(c)).toList();
      await OfflineCacheService.cacheCounties(stateId, counties);
      return counties;
    } catch (_) {
      return OfflineCacheService.getCachedCounties(stateId);
    }
  }
}

// ---------------------------------------------------------------------------
// TenantService — loads per-state branding / configuration
// ---------------------------------------------------------------------------

class TenantService {
  static final _supabase = Supabase.instance.client;

  static Future<TenantConfig> getTenantConfig(String stateCode) async {
    try {
      final response = await _supabase
          .from('tenant_configs')
          .select()
          .eq('state_code', stateCode)
          .eq('is_active', true)
          .single();
      final config = TenantConfig.fromJson(response);
      await OfflineCacheService.cacheTenantConfig(config);
      return config;
    } catch (_) {
      return OfflineCacheService.getCachedTenantConfig(stateCode) ??
          TenantConfig.defaultConfig;
    }
  }
}

// ---------------------------------------------------------------------------
// Riverpod providers
// ---------------------------------------------------------------------------

// Selected state code (persisted in the ProviderScope)
final selectedStateCodeProvider = StateProvider<String?>((ref) => null);

// Selected county id
final selectedCountyIdProvider = StateProvider<String?>((ref) => null);

// Selected resource category filter
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Singleton ResourceService instance
final resourceServiceProvider = Provider<ResourceService>((ref) {
  return ResourceService();
});

// Tenant config for the selected state
final tenantConfigProvider =
    FutureProvider.family<TenantConfig, String>((ref, stateCode) async {
  return TenantService.getTenantConfig(stateCode);
});

// List of all states
final statesProvider = FutureProvider<List<StateInfo>>((ref) async {
  return LocationService.getStates();
});

// Counties for a given state id
final countiesProvider =
    FutureProvider.family<List<County>, String>((ref, stateId) async {
  return LocationService.getCounties(stateId);
});

// Resources filtered by state / county / category
final resourcesProvider = FutureProvider.family<List<Resource>,
    ({String stateCode, String? countyId, String? category})>((ref, params) async {
  return ref.read(resourceServiceProvider).getResources(
    stateCode: params.stateCode,
    countyId: params.countyId,
    category: params.category,
  );
});

// Resources for a specific county (uses the dedicated getResourcesByCounty method)
final resourcesByCountyProvider =
    FutureProvider.family<List<Resource>, String>((ref, countyId) async {
  return ref.read(resourceServiceProvider).getResourcesByCounty(countyId);
});

