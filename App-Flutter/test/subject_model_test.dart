import 'package:flutter_test/flutter_test.dart';
import 'package:fe_mobile/core/models/subject_model.dart';

void main() {
  group('SubjectModel Unit Tests', () {
    test('SUB_M_01: Should parse JSON with all fields correctly', () {
      final json = {
        'id': '123',
        'name': 'Lập trình Flutter',
        'description': 'Môn học nâng cao',
      };

      final model = SubjectModel.fromJson(json);

      expect(model.id, '123');
      expect(model.name, 'Lập trình Flutter');
      expect(model.description, 'Môn học nâng cao');
      expect(model.iconPath, '📚');
    });

    test('SUB_M_02: Should parse JSON with missing optional description', () {
      final json = {
        'id': '456',
        'name': 'Cơ sở dữ liệu',
      };

      final model = SubjectModel.fromJson(json);

      expect(model.id, '456');
      expect(model.name, 'Cơ sở dữ liệu');
      expect(model.description, isNull);
      expect(model.iconPath, '📚');
    });

    test('SUB_M_03: Should parse JSON and stringify numeric id correctly', () {
      final json = {
        'id': 789,
        'name': 'Hệ điều hành',
      };

      final model = SubjectModel.fromJson(json);

      expect(model.id, '789');
      expect(model.name, 'Hệ điều hành');
    });

    test('SUB_M_04: Should evaluate equality operator (==) correctly based on id', () {
      final model1 = SubjectModel(id: '123', name: 'Lập trình Flutter', description: 'Môn A');
      final model2 = SubjectModel(id: '123', name: 'Lập trình Di Động', description: 'Môn B');
      final model3 = SubjectModel(id: '456', name: 'Lập trình Flutter', description: 'Môn A');

      expect(model1 == model2, isTrue);
      expect(model1 == model3, isFalse);
    });

    test('SUB_M_05: Should evaluate hashCode correctly based on id', () {
      final model1 = SubjectModel(id: '123', name: 'Lập trình Flutter');
      final model2 = SubjectModel(id: '123', name: 'Lập trình Di Động');

      expect(model1.hashCode, model2.hashCode);
    });
  });
}
