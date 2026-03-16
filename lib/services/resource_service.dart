import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/resource.dart';

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
  }
}
