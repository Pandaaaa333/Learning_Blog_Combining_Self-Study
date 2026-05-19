class SubjectModel {
  final String id;
  final String name;
  final String? description;
  final String iconPath;

  SubjectModel({
    required this.id,
    required this.name,
    this.description,
    this.iconPath = '📚',
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      iconPath: '📚', // Default icon for now
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SubjectModel && id == other.id;
  @override
  int get hashCode => id.hashCode;
}
