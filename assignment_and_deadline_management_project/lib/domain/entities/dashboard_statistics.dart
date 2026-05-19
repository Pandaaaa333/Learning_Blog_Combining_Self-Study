class DashboardStatistics {
  final int totalStudents;
  final int activeDeadlines;
  final int totalPosts;
  final int pendingReports;
  final double deadlineCompletionRate;

  DashboardStatistics({
    required this.totalStudents,
    required this.activeDeadlines,
    required this.totalPosts,
    required this.pendingReports,
    required this.deadlineCompletionRate,
  });

  factory DashboardStatistics.fromJson(Map<String, dynamic> json) {
    return DashboardStatistics(
      totalStudents: json['totalStudents'] ?? 0,
      activeDeadlines: json['activeDeadlines'] ?? 0,
      totalPosts: json['totalPosts'] ?? 0,
      pendingReports: json['pendingReports'] ?? 0,
      deadlineCompletionRate: (json['deadlineCompletionRate'] ?? 0).toDouble(),
    );
  }
}
