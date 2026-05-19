import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class CommunityService {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> getSubjects() async {
    try {
      final response = await _apiClient.dio.get('/Subjects');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getUserSubjects() async {
    try {
      final response = await _apiClient.dio.get('/Subjects/my');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserSubjects(List<String> subjectIds) async {
    try {
      await _apiClient.dio.post('/Subjects/preferences', data: subjectIds);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getPosts({String? subjectId, int page = 1, int pageSize = 10}) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'pageSize': pageSize,
      };
      if (subjectId != null) {
        queryParams['subjectId'] = subjectId;
      }
      final response = await _apiClient.dio.get('/Posts', queryParameters: queryParams);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> likePost(String postId) async {
    try {
      await _apiClient.dio.post('/Posts/$postId/like');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unlikePost(String postId) async {
    try {
      await _apiClient.dio.post('/Posts/$postId/unlike');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addComment(String postId, String content) async {
    try {
      final response = await _apiClient.dio.post('/Posts/$postId/comments', data: {'content': content});
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getComments(String postId) async {
    try {
      final response = await _apiClient.dio.get('/Posts/$postId/comments');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createPost({
    required String content,
    required String subjectId,
    List<int>? imageBytes,
    String? imageName,
  }) async {
    try {
      if (imageBytes != null && imageName != null) {
        final formData = FormData.fromMap({
          'content': content,
          'subjectId': subjectId,
          'image': MultipartFile.fromBytes(imageBytes, filename: imageName),
        });
        final response = await _apiClient.dio.post('/Posts/with-image', data: formData);
        return response.data;
      } else {
        final response = await _apiClient.dio.post('/Posts', data: {
          'content': content,
          'subjectId': subjectId,
        });
        return response.data;
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? 'Lỗi kết nối server';
      throw Exception(message);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getLeaderboard({int limit = 10}) async {
    try {
      final response = await _apiClient.dio.get('/Users/leaderboard', queryParameters: {'limit': limit});
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _apiClient.dio.delete('/Posts/$postId');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reportPost(String postId, String reason) async {
    try {
      await _apiClient.dio.post('/Reports', data: {
        'targetEntity': 'Post',
        'targetId': postId,
        'reason': reason,
      });
    } catch (e) {
      rethrow;
    }
  }
}
