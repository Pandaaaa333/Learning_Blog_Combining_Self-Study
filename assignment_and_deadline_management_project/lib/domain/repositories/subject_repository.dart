import 'package:fe_admin_web/domain/entities/subject_entity.dart';

abstract class SubjectRepository {
  Future<List<AdminSubjectModel>> getSubjects();
  Future<void> saveSubject(AdminSubjectModel subject);
  Future<void> deleteSubject(String id);
}
