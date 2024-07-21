class SQLModel {
  final int? id;
  final String? name;
  final String? mobile;
  final String? email;
  final String? createdAt;
  final String? updatedAt;

  SQLModel({
     this.id,
     this.name,
     this.mobile,
     this.email,
     this.createdAt,
    this.updatedAt,
  });

  factory SQLModel.fromSqfliteDatabase(Map<String, dynamic> map) => SQLModel(
    id: map['id']?.toInt() ?? 0,
    name: map['name'] ?? '',
    mobile: map['mobile'] ?? '',
    email: map['email'] ?? '',
    createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'])
        .toIso8601String(),
    updatedAt: map['updated_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
        .toIso8601String(),
  );
}
