class Admin {
  final String name;
  final String email;
  final String avatar;
  final bool isSuperAdmin;

  Admin({
    required this.name,
    required this.email,
    required this.avatar,
    this.isSuperAdmin = false,
  });
}
