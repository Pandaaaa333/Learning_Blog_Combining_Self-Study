import 'package:dio/dio.dart';
import 'package:fe_admin_web/core/api_client.dart';
import 'package:fe_admin_web/data/models/user_model.dart';
import 'package:fe_admin_web/domain/entities/user_entity.dart';
import 'package:fe_admin_web/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final Dio _dio = ApiClient().dio;

  @override
  Future<List<AdminUserModel>> getUsers() async {
    final response = await _dio.get('/Users');
    final List<dynamic> data = response.data;
    return data.map((json) => AdminUserModelAdapter.fromJson(json)).toList();
  }

  @override
  Future<void> toggleUserStatus(String userId) async {
    await _dio.patch('/Users/$userId/status');
  }

  @override
  Future<void> addUser(AdminUserModel user) async {
    final data = AdminUserModelAdapter(
      id: user.id,
      name: user.name,
      email: user.email,
      major: user.major,
      joinDate: user.joinDate,
      isActive: user.isActive,
      avatarUrl: user.avatarUrl,
      role: user.role,
    ).toJson();
    await _dio.post('/Users', data: data);
  }
}
