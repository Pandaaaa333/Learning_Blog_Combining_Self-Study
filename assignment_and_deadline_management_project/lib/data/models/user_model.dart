import 'package:fe_admin_web/domain/entities/user_entity.dart';

class AdminUserModelAdapter extends AdminUserModel {
  AdminUserModelAdapter({
    required super.id,
    required super.name,
    required super.email,
    super.major,
    super.joinDate,
    required super.isActive,
    super.avatarUrl,
    required super.role,
  });

  factory AdminUserModelAdapter.fromJson(Map<String, dynamic> json) {
    return AdminUserModelAdapter(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      major: json['major'] ?? 'CNTT', // default or mapped from role later
      joinDate: json['joinDate'] ?? DateTime.now().toIso8601String().substring(0, 10),
      isActive: json['isActive'] ?? true,
      avatarUrl: json['avatarUrl'],
      role: json['role'] ?? 'User',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'major': major,
      'joinDate': joinDate,
      'isActive': isActive,
      'avatarUrl': avatarUrl,
      'role': role,
    };
  }
}
