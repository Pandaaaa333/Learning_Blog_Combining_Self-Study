import 'package:fe_admin_web/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<List<AdminUserModel>> getUsers();
  Future<void> toggleUserStatus(String userId);
  Future<void> addUser(AdminUserModel user);
}
