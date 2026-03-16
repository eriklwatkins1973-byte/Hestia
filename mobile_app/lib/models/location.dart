// ---------------------------------------------------------------------------
// County model
// ---------------------------------------------------------------------------

class County {
  final String id;
  final String stateId;
  final String name;
  final String? fipsCode;

  const County({
    required this.id,
    required this.stateId,
    required this.name,
    this.fipsCode,
  });

  factory County.fromJson(Map<String, dynamic> json) {
    return County(
      id: json['id'] as String,
      stateId: json['state_id'] as String,
      name: json['name'] as String,
      fipsCode: json['fips_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'state_id': stateId,
        'name': name,
        'fips_code': fipsCode,
      };
}

// ---------------------------------------------------------------------------
// StateInfo model
// ---------------------------------------------------------------------------

class StateInfo {
  final String id;
  final String code;
  final String name;

  const StateInfo({
    required this.id,
    required this.code,
    required this.name,
  });

  factory StateInfo.fromJson(Map<String, dynamic> json) {
    return StateInfo(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
      };
}
