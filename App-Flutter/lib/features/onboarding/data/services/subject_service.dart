import 'package:dio/dio.dart';
import 'package:fe_mobile/core/network/api_client.dart';
import 'package:fe_mobile/core/models/subject_model.dart';

class SubjectService {
  final ApiClient _apiClient = ApiClient();

  Future<List<SubjectModel>> getAllSubjects() async {
    try {
      final response = await _apiClient.dio.get('/Subjects');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => SubjectModel(
          id: json['id'].toString(),
          name: json['name'],
          iconPath: '📚', // Backend doesn't have iconPath yet, using default
        )).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching subjects: $e');
      return [];
    }
  }

  Future<List<SubjectModel>> getMySubjects() async {
    try {
      final response = await _apiClient.dio.get('/Subjects/my');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => SubjectModel(
          id: json['id'].toString(),
          name: json['name'],
          iconPath: '📚',
        )).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching my subjects: $e');
      return [];
    }
  }

  Future<bool> updatePreferences(List<String> subjectIds) async {
    try {
      final response = await _apiClient.dio.post(
        '/Subjects/preferences',
        data: subjectIds,
        options: Options(
          contentType: 'application/json',
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating preferences: $e');
      return false;
    }
  }
}
