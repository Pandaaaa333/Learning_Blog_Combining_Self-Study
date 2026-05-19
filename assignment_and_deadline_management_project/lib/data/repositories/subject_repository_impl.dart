import 'package:dio/dio.dart';
import 'package:fe_admin_web/core/api_client.dart';
import 'package:fe_admin_web/data/models/subject_model.dart';
import 'package:fe_admin_web/domain/entities/subject_entity.dart';
import 'package:fe_admin_web/domain/repositories/subject_repository.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final Dio _dio = ApiClient().dio;

  @override
  Future<List<AdminSubjectModel>> getSubjects() async {
    final response = await _dio.get('/Subjects');
    final List<dynamic> data = response.data;
    return data.map((json) => AdminSubjectModelAdapter.fromJson(json)).toList();
  }

  @override
  Future<void> saveSubject(AdminSubjectModel subject) async {
    final data = {
      'name': subject.name,
      'description': subject.code,
    };

    if (subject.id.isEmpty) {
      await _dio.post('/Subjects', data: data);
    } else {
      await _dio.put('/Subjects/${subject.id}', data: data);
    }
  }

  @override
  Future<void> deleteSubject(String id) async {
    await _dio.delete('/Subjects/$id');
  }
}
