import 'package:hive/hive.dart';

part 'resource.g.dart';

// ---------------------------------------------------------------------------
// Resource model
// ---------------------------------------------------------------------------

@HiveType(typeId: 0)
class Resource extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String stateId;

  @HiveField(2)
  final String? countyId;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String? subCategory;

  @HiveField(6)
  final String? description;

  @HiveField(7)
  final String? addressLine1;

  @HiveField(8)
  final String? city;

  @HiveField(9)
  final String? zipCode;

  @HiveField(10)
  final String? phone;

  @HiveField(11)
  final String? website;

  @HiveField(12)
  final String? email;

  @HiveField(13)
  final double? latitude;

  @HiveField(14)
  final double? longitude;

  @HiveField(15)
  final String status;

  /// Raw JSON string for operating hours
  @HiveField(16)
  final String? hoursJson;

  /// Raw JSON string for meal schedules (church / non-profit focused)
  @HiveField(17)
  final String? mealSchedulesJson;

  @HiveField(18)
  final DateTime? lastVerifiedAt;

  @HiveField(19)
  final DateTime updatedAt;

  const Resource({
    required this.id,
    required this.stateId,
    this.countyId,
    required this.name,
    required this.category,
    this.subCategory,
    this.description,
    this.addressLine1,
    this.city,
    this.zipCode,
    this.phone,
    this.website,
    this.email,
    this.latitude,
    this.longitude,
    required this.status,
    this.hoursJson,
    this.mealSchedulesJson,
    this.lastVerifiedAt,
    required this.updatedAt,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'] as String,
      stateId: json['state_id'] as String,
      countyId: json['county_id'] as String?,
      name: json['name'] as String,
      category: json['category'] as String,
      subCategory: json['sub_category'] as String?,
      description: json['description'] as String?,
      addressLine1: json['address_line1'] as String?,
      city: json['city'] as String?,
      zipCode: json['zip_code'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      email: json['email'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'active',
      hoursJson: json['hours'] != null
          ? (json['hours'] is String
              ? json['hours'] as String
              : json['hours'].toString())
          : null,
      mealSchedulesJson: json['meal_schedules'] != null
          ? (json['meal_schedules'] is String
              ? json['meal_schedules'] as String
              : json['meal_schedules'].toString())
          : null,
      lastVerifiedAt: json['last_verified_at'] != null
          ? DateTime.parse(json['last_verified_at'] as String)
          : null,
      updatedAt: DateTime.parse(
          json['updated_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'state_id': stateId,
        'county_id': countyId,
        'name': name,
        'category': category,
        'sub_category': subCategory,
        'description': description,
        'address_line1': addressLine1,
        'city': city,
        'zip_code': zipCode,
        'phone': phone,
        'website': website,
        'email': email,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
        'hours': hoursJson,
        'meal_schedules': mealSchedulesJson,
        'last_verified_at': lastVerifiedAt?.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  /// Full address string for display
  String get fullAddress {
    final parts = <String>[
      if (addressLine1 != null) addressLine1!,
      if (city != null) city!,
      if (zipCode != null) zipCode!,
    ];
    return parts.join(', ');
  }

  /// True when the resource has at least one meal schedule entry
  bool get hasMealSchedules {
    return mealSchedulesJson != null &&
        mealSchedulesJson!.isNotEmpty &&
        mealSchedulesJson != '[]';
  }

  Resource copyWith({
    String? id,
    String? stateId,
    String? countyId,
    String? name,
    String? category,
    String? subCategory,
    String? description,
    String? addressLine1,
    String? city,
    String? zipCode,
    String? phone,
    String? website,
    String? email,
    double? latitude,
    double? longitude,
    String? status,
    String? hoursJson,
    String? mealSchedulesJson,
    DateTime? lastVerifiedAt,
    DateTime? updatedAt,
  }) {
    return Resource(
      id: id ?? this.id,
      stateId: stateId ?? this.stateId,
      countyId: countyId ?? this.countyId,
      name: name ?? this.name,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      description: description ?? this.description,
      addressLine1: addressLine1 ?? this.addressLine1,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      email: email ?? this.email,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      hoursJson: hoursJson ?? this.hoursJson,
      mealSchedulesJson: mealSchedulesJson ?? this.mealSchedulesJson,
      lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
