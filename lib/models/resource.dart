/// Represents a homelessness resource (e.g., shelter, meal program, support
/// service) associated with a specific county.
class Resource {
  final String id;
  final String name;
  final String description;
  final String countyId;
  final String type;
  final String? address;
  final String? phone;
  final String? website;
  final String? hours;

  const Resource({
    required this.id,
    required this.name,
    required this.description,
    required this.countyId,
    required this.type,
    this.address,
    this.phone,
    this.website,
    this.hours,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    String require(String key) {
      final value = json[key];
      if (value == null) {
        throw FormatException("Resource.fromJson: missing required field '$key'");
      }
      return value as String;
    }

    return Resource(
      id: require('id'),
      name: require('name'),
      description: require('description'),
      countyId: require('county_id'),
      type: require('type'),
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      hours: json['hours'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'county_id': countyId,
      'type': type,
      'address': address,
      'phone': phone,
      'website': website,
      'hours': hours,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Resource &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Resource(id: $id, name: $name, countyId: $countyId)';
}
