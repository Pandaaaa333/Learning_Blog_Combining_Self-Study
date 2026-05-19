import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dashboard_widgets.dart';
import 'package:fe_admin_web/data/providers/user_logs_provider.dart';
import 'package:fe_admin_web/data/providers/user_provider.dart';
import 'package:fe_admin_web/data/providers/post_provider.dart';
import 'package:fe_admin_web/data/providers/statistics_provider.dart';
import 'statistics_chart_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserLogsProvider>().fetchStatistics();
      context.read<UserLogsProvider>().fetchRecentLogs();
      context.read<UserProvider>().fetchUsers();
      context.read<PostProvider>().fetchPosts();
      context.read<StatisticsProvider>().fetchDashboardStatistics();
    });
  }

  String _formatTimeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) return '${difference.inDays} ngày trước';
    if (difference.inHours > 0) return '${difference.inHours} giờ trước';
    if (difference.inMinutes > 0) return '${difference.inMinutes} phút trước';
    return 'Vừa xong';
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final postProvider = context.watch<PostProvider>();
    final userLogsProvider = context.watch<UserLogsProvider>();
    final statisticsProvider = context.watch<StatisticsProvider>();
    
    final stats = statisticsProvider.statistics;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              buildStatCard('Tổng sinh viên', userProvider.users.length.toString(), Icons.people_rounded, const Color(0xFF4A7DFF)),
              const SizedBox(width: 24),
              buildStatCard('Deadline đang chạy', stats?.activeDeadlines.toString() ?? '...', Icons.access_time_rounded, const Color(0xFF10B981)),
              const SizedBox(width: 24),
              buildStatCard('Bài viết cộng đồng', postProvider.posts.length.toString(), Icons.article_rounded, const Color(0xFF8B5CF6)),
              const SizedBox(width: 24),
              buildStatCard('Báo cáo cần xử lý', stats?.pendingReports.toString() ?? '...', Icons.warning_rounded, const Color(0xFFEF4444)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 350,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
                  child: userLogsProvider.isLoading && userLogsProvider.statistics.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : userLogsProvider.errorMessage != null
                          ? Center(child: Text('Error: ${userLogsProvider.errorMessage}'))
                          : StatisticsChartWidget(statistics: userLogsProvider.statistics),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Container(
                  height: 350,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hoàn thành Deadline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 32),
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 150, width: 150,
                              child: CircularProgressIndicator(
                                value: (stats?.deadlineCompletionRate ?? 0) / 100, 
                                strokeWidth: 12, 
                                backgroundColor: Colors.orange[100], 
                                color: const Color(0xFF10B981)
                              ),
                            ),
                            Text('${stats?.deadlineCompletionRate.toInt() ?? 0}%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildLegendDot(const Color(0xFF10B981), 'Đúng hạn'),
                          const SizedBox(width: 16),
                          buildLegendDot(Colors.orange[100]!, 'Trễ hạn'),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hoạt động mới nhất', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                if (userLogsProvider.recentLogs.isEmpty && !userLogsProvider.isLoading)
                  const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Text('Không có hoạt động nào gần đây.', style: TextStyle(color: Colors.grey))),
                ...userLogsProvider.recentLogs.map((log) {
                  return buildActivityRow(
                    log.username ?? 'Người dùng',
                    'vừa thực hiện: ${log.action} ${log.targetEntity != null ? 'trên ${log.targetEntity}' : ''}',
                    _formatTimeAgo(log.createdAt),
                  );
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}

