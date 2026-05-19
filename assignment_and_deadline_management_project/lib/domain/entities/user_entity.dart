class AdminUserModel {
  final String id;
  final String name;
  final String email;
  final String? major;
  final String? joinDate;
  bool isActive;
  final String? avatarUrl;
  final String role;

  AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.major,
    this.joinDate,
    required this.isActive,
    this.avatarUrl,
    required this.role,
  });
}
