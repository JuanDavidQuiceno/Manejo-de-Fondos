import 'package:dashboard/src/common/models/role/role_model.dart';

class UserModel {
  UserModel({
    required this.email,
    required this.name,
    required this.lastName,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role'] != null
          ? RoleModel.fromJson(json['role'] as Map<String, dynamic>)
          : null,
    );
  }
  final String email;
  final String name;
  final String lastName;
  final RoleModel? role;

  UserModel copyWith({
    String? name,
    String? lastName,
    String? email,
    RoleModel? role,
  }) {
    return UserModel(
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'role': role?.toJson()};
  }
}
