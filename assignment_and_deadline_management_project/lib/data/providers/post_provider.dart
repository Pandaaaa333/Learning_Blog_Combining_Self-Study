import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fe_admin_web/core/api_client.dart';
import 'package:fe_admin_web/domain/entities/admin_post_model.dart';

class PostProvider extends ChangeNotifier {
  final Dio _dio = ApiClient().dio;
  
  List<AdminPostModel> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<AdminPostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _dio.get('/Posts', queryParameters: {
        'page': 1,
        'pageSize': 100, // Fetch up to 100 posts for admin panel
      });
      if (response.statusCode == 200) {
        // Assume API returns a paginated structure or a list
        final data = response.data;
        List<dynamic> items = data is List ? data : (data['items'] ?? []);
        _posts = items.map((json) => AdminPostModel.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      _error = 'Failed to load posts: ${e.message}';
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> deletePost(String id) async {
    try {
      await _dio.delete('/Posts/$id');
      _posts.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
