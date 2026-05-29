import 'package:flutter_test/flutter_test.dart';
import 'package:fe_admin_web/data/models/user_model.dart';

void main() {
  group('AdminUserModelAdapter Unit Tests', () {
    test('ADM_U_01: Should parse JSON with all fields successfully', () {
      final json = {
        'id': 'u1',
        'name': 'Lê Văn A',
        'email': 'a@gmail.com',
        'major': 'CNTT',
        'joinDate': '2026-05-01',
        'isActive': true,
        'avatarUrl': 'http://avatar-url.com/a.png',
        'role': 'Admin',
      };

      final model = AdminUserModelAdapter.fromJson(json);

      expect(model.id, 'u1');
      expect(model.name, 'Lê Văn A');
      expect(model.email, 'a@gmail.com');
      expect(model.major, 'CNTT');
      expect(model.joinDate, '2026-05-01');
      expect(model.isActive, isTrue);
      expect(model.avatarUrl, 'http://avatar-url.com/a.png');
      expect(model.role, 'Admin');
    });

    test('ADM_U_02: Should parse JSON with missing optional fields and fallback to defaults', () {
      final json = {
        'id': 'u2',
        'name': 'Nguyễn Văn B',
        'email': 'b@gmail.com',
      };

      final model = AdminUserModelAdapter.fromJson(json);

      expect(model.id, 'u2');
      expect(model.name, 'Nguyễn Văn B');
      expect(model.email, 'b@gmail.com');
      expect(model.major, 'CNTT'); // Fallback major
      expect(model.isActive, isTrue); // Fallback active status
      expect(model.role, 'User'); // Fallback role
      expect(model.avatarUrl, isNull);
      expect(model.joinDate, isNotNull); // Current date YYYY-MM-DD format
      expect(model.joinDate!.length, 10);
    });

    test('ADM_U_03: Should serialize back to JSON correctly', () {
      final model = AdminUserModelAdapter(
        id: 'u3',
        name: 'Trần Thị C',
        email: 'c@gmail.com',
        major: 'Kinh Tế',
        joinDate: '2026-04-20',
        isActive: false,
        avatarUrl: 'http://avatar-url.com/c.png',
        role: 'Moderator',
      );

      final json = model.toJson();

      expect(json['id'], 'u3');
      expect(json['name'], 'Trần Thị C');
      expect(json['email'], 'c@gmail.com');
      expect(json['major'], 'Kinh Tế');
      expect(json['joinDate'], '2026-04-20');
      expect(json['isActive'], isFalse);
      expect(json['avatarUrl'], 'http://avatar-url.com/c.png');
      expect(json['role'], 'Moderator');
    });
  });
}
