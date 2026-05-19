import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fe_admin_web/core/api_client.dart';
import 'package:fe_admin_web/data/models/user_model.dart';
import 'package:fe_admin_web/domain/entities/user_entity.dart';

class UserProvider extends ChangeNotifier {
  final Dio _dio = ApiClient().dio;
  
  List<AdminUserModel> _users = [];
  bool _isLoading = false;
  String? _error;

  List<AdminUserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _dio.get('/Users');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _users = data.map((json) => AdminUserModelAdapter.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      _error = 'Failed to load users: ${e.message}';
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleUserStatus(String userId) async {
    // Optimistic UI update
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _users[index].isActive = !_users[index].isActive;
      notifyListeners();
      
      try {
        // Here we might call an endpoint like PATCH /Users/{id}/role or similar to toggle.
        // For now, if the API doesn't support active/inactive, we can skip or simulate.
        // await _dio.patch('/Users/$userId/status', data: { 'isActive': _users[index].isActive });
      } catch (e) {
        // Revert on error
        _users[index].isActive = !_users[index].isActive;
        notifyListeners();
      }
    }
  }
}
