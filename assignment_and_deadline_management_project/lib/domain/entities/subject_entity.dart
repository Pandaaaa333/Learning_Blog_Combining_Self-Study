class AdminSubjectModel {
  final String id;
  String name;
  String code;
  final String themeColor;
  final int enrolledStudents;

  AdminSubjectModel({
    required this.id,
    required this.name,
    required this.code,
    required this.themeColor,
    required this.enrolledStudents,
  });
}
