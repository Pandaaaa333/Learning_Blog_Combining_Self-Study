class UserActivityLog {
  final String id;
  final String action;
  final String? targetEntity;
  final String? targetId;
  final String? dataChange;
  final DateTime createdAt;
  final String userId;
  final String? username;

  UserActivityLog({
    required this.id,
    required this.action,
    this.targetEntity,
    this.targetId,
    this.dataChange,
    required this.createdAt,
    required this.userId,
    this.username,
  });

  factory UserActivityLog.fromJson(Map<String, dynamic> json) {
    return UserActivityLog(
      id: json['id'] ?? '',
      action: json['action'] ?? '',
      targetEntity: json['targetEntity'],
      targetId: json['targetId'],
      dataChange: json['dataChange'],
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'] ?? '',
      username: json['username'],
    );
  }
}
