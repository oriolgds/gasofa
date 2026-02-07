/// Province model for dropdown selection

class Province {
  final String code;
  final String name;

  const Province({required this.code, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      code: json['IDPovincia'] ?? json['IDCCAA'] ?? '',
      name: json['Provincia'] ?? json['CCAA'] ?? '',
    );
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Province &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
