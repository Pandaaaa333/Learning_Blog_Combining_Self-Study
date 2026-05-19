class UserActivityLogStatistics {
  final DateTime date;
  final int totalActions;
  final List<ActionCount> actionCounts;

  UserActivityLogStatistics({
    required this.date,
    required this.totalActions,
    required this.actionCounts,
  });

  factory UserActivityLogStatistics.fromJson(Map<String, dynamic> json) {
    return UserActivityLogStatistics(
      date: DateTime.parse(json['date']),
      totalActions: json['totalActions'] ?? 0,
      actionCounts: (json['actionCounts'] as List<dynamic>?)
              ?.map((item) => ActionCount.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class ActionCount {
  final String action;
  final int count;

  ActionCount({
    required this.action,
    required this.count,
  });

  factory ActionCount.fromJson(Map<String, dynamic> json) {
    return ActionCount(
      action: json['action'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}
