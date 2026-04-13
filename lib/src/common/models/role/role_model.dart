class RoleModel {
  RoleModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.createdAt,
    this.deletedAt,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'] as String)
          : null,
    );
  }

  final String id;
  final String name;
  final String slug;
  final String? description;
  final DateTime? createdAt;
  final DateTime? deletedAt;

  RoleModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) {
    return RoleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'RoleModel(id: $id, name: $name, slug: $slug)';
  }
}
