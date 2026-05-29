import 'package:flutter_test/flutter_test.dart';
import 'package:fe_admin_web/data/models/subject_model.dart';

void main() {
  group('AdminSubjectModelAdapter Unit Tests', () {
    test('ADM_S_01: Should parse JSON with custom mappings and defaults successfully', () {
      final json = {
        'id': 's1',
        'name': 'Kiểm thử phần mềm',
        'description': 'SE303',
      };

      final model = AdminSubjectModelAdapter.fromJson(json);

      expect(model.id, 's1');
      expect(model.name, 'Kiểm thử phần mềm');
      expect(model.code, 'SE303'); // description parsed into code
      expect(model.themeColor, '0xFF4A7DFF'); // fallback default color
      expect(model.enrolledStudents, 0); // fallback default enrolled students
    });

    test('ADM_S_02: Should handle null/missing fields gracefully during fromJson', () {
      final json = {
        'id': null,
        'name': null,
        'description': null,
      };

      final model = AdminSubjectModelAdapter.fromJson(json);

      expect(model.id, '');
      expect(model.name, 'Unknown');
      expect(model.code, 'No Code');
    });

    test('ADM_S_03: Should serialize back to backend JSON format correctly', () {
      final model = AdminSubjectModelAdapter(
        id: 's2',
        name: 'Hệ thống thông tin',
        code: 'IS201',
        themeColor: '0xFF112233',
        enrolledStudents: 45,
      );

      final json = model.toJson();

      expect(json['id'], 's2');
      expect(json['name'], 'Hệ thống thông tin');
      expect(json['description'], 'IS201'); // code serialized back into description
    });
  });
}
