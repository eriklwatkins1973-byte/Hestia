// ---------------------------------------------------------------------------
// TenantConfig model — per-state branding & feature flags
// ---------------------------------------------------------------------------

class TenantConfig {
  final String stateCode;
  final String stateName;
  final String primaryColor;
  final String accentColor;
  final String? logoUrl;
  final String? supportEmail;
  final List<String> resourceCategories;

  const TenantConfig({
    required this.stateCode,
    required this.stateName,
    required this.primaryColor,
    required this.accentColor,
    this.logoUrl,
    this.supportEmail,
    required this.resourceCategories,
  });

  factory TenantConfig.fromJson(Map<String, dynamic> json) {
    final rawCategories = json['resource_categories'];
    final categories = rawCategories is List
        ? rawCategories.cast<String>()
        : <String>[];

    return TenantConfig(
      stateCode: json['state_code'] as String,
      stateName: json['state_name'] as String,
      primaryColor: json['primary_color'] as String? ?? '#1976D2',
      accentColor: json['accent_color'] as String? ?? '#FF9800',
      logoUrl: json['logo_url'] as String?,
      supportEmail: json['support_email'] as String?,
      resourceCategories: categories,
    );
  }

  /// Fallback configuration used when state config is not yet loaded
  static const TenantConfig defaultConfig = TenantConfig(
    stateCode: '',
    stateName: 'Hestia',
    primaryColor: '#1976D2',
    accentColor: '#FF9800',
    resourceCategories: [
      'shelter',
      'food',
      'healthcare',
      'mental_health',
      'substance_use',
      'employment',
      'legal',
      'transportation',
    ],
  );
}
