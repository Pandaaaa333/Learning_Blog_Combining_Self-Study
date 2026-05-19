import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fe_admin_web/core/api_client.dart';
import 'package:fe_admin_web/data/models/subject_model.dart';
import 'package:fe_admin_web/domain/entities/subject_entity.dart';

class SubjectProvider extends ChangeNotifier {
  final Dio _dio = ApiClient().dio;
  
  List<AdminSubjectModel> _subjects = [];
  bool _isLoading = false;
  String? _error;

  List<AdminSubjectModel> get subjects => _subjects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSubjects() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _dio.get('/Subjects');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _subjects = data.map((json) => AdminSubjectModelAdapter.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      _error = 'Failed to load subjects: ${e.message}';
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> deleteSubject(String id) async {
    try {
      await _dio.delete('/Subjects/$id');
      _subjects.removeWhere((s) => s.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addOrUpdateSubject(AdminSubjectModel subject) async {
    try {
      final data = {
        'name': subject.name,
        'description': subject.code, // mapping back
      };

      if (subject.id.isEmpty) {
        final response = await _dio.post('/Subjects', data: data);
        if (response.statusCode == 201 || response.statusCode == 200) {
          _subjects.add(AdminSubjectModelAdapter.fromJson(response.data));
          notifyListeners();
          return true;
        }
      } else {
        final response = await _dio.put('/Subjects/${subject.id}', data: data);
        if (response.statusCode == 200) {
          final index = _subjects.indexWhere((s) => s.id == subject.id);
          if (index != -1) {
            _subjects[index] = AdminSubjectModelAdapter.fromJson(response.data);
            notifyListeners();
          }
          return true;
        }
      }
    } catch (e) {
      print('Error saving subject: $e');
    }
    return false;
  }
}
