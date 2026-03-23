import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/resource.dart';

copilot/fetch-resources-by-county-id
/// Service for fetching [Resource] records from the Supabase backend.
class ResourceService {
  final SupabaseClient _supabase;

  ResourceService(this._supabase);

  /// Fetches all resources belonging to the given [countyId].
  ///
  /// Returns a list of [Resource] objects.  Throws a [PostgrestException] if
  /// the query fails.
  Future<List<Resource>> fetchResourcesByCountyId(String countyId) async {
    final data = await _supabase
        .from('resources')
        .select()
        .eq('county_id', countyId);

    final resources = data.map((json) => Resource.fromJson(json)).toList();
    return resources;
=======
/// Service for fetching [Resource] data from Supabase.
class ResourceService {
  /// Optional [SupabaseClient] injected at construction time.
  ///
  /// When `null`, [Supabase.instance.client] is used at call-time so that the
  /// class can be instantiated before [Supabase.initialize] is called (e.g.
  /// in tests that only instantiate but never invoke the service).
  final SupabaseClient? _client;

  ResourceService({SupabaseClient? client}) : _client = client;

  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  /// Returns all active resources belonging to [countyId].
  ///
  /// Throws a [PostgrestException] if the Supabase query fails.
  Future<List<Resource>> getResourcesByCounty(String countyId) async {
    final data = await _supabase
        .from('resources')
        .select()
        .eq('county_id', countyId)
        .eq('is_active', true);

    return data.map((json) => Resource.fromJson(json)).toList();
 main
  }
}
