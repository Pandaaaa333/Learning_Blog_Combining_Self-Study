import 'package:fe_admin_web/domain/entities/subject_entity.dart';

class AdminSubjectModelAdapter extends AdminSubjectModel {
  AdminSubjectModelAdapter({
    required super.id,
    required super.name,
    required super.code,
    required super.themeColor,
    required super.enrolledStudents,
  });

  factory AdminSubjectModelAdapter.fromJson(Map<String, dynamic> json) {
    return AdminSubjectModelAdapter(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      code: json['description'] ?? 'No Code', // Map Description to code or default
      themeColor: '0xFF4A7DFF', // Default color if backend doesn't provide
      enrolledStudents: 0, // Default if backend doesn't provide
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': code, // Map back to description
    };
  }
}
