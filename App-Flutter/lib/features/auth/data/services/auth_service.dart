import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fe_mobile/core/network/api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post('/Auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'];
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
        }
        return data;
      }
      throw Exception('Đăng nhập thất bại');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await _apiClient.dio.post('/Auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Đăng ký thất bại');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get('/Auth/me');
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<Map<String, dynamic>> uploadAvatar(List<int> bytes, String fileName) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: fileName),
      });

      final response = await _apiClient.dio.post('/Users/avatar', data: formData);

      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Tải ảnh đại diện thất bại');
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? 'Lỗi kết nối server';
      throw Exception(message);
    } catch (e) {
      rethrow;
    }
  }
}
