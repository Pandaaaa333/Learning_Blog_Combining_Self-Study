import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5080/api';
    }
    return 'http://10.0.2.2:5080/api'; // Cho Android Emulator
  }
  
  final Dio _dio;

  ApiClient() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        if (e.response?.statusCode == 401) {
          // Xử lý khi token hết hạn (ví dụ: đăng xuất)
        }
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}
