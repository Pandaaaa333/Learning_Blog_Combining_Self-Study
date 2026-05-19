import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/feed_viewmodel.dart';

class LeaderboardWidget extends StatefulWidget {
  const LeaderboardWidget({Key? key}) : super(key: key);

  @override
  State<LeaderboardWidget> createState() => _LeaderboardWidgetState();
}

class _LeaderboardWidgetState extends State<LeaderboardWidget> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<FeedViewModel>().fetchLeaderboard();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedVM = context.watch<FeedViewModel>();
    const primaryColor = Color(0xFF52B794);

    if (feedVM.isLeaderboardLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      );
    }

    if (feedVM.leaderboardError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              feedVM.leaderboardError!,
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => feedVM.fetchLeaderboard(),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Tải lại', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    final users = feedVM.leaderboardUsers;

    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Chưa có dữ liệu bảng xếp hạng',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => feedVM.fetchLeaderboard(),
      color: primaryColor,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final name = user['name'] ?? 'Sinh viên';
          final level = user['level'] ?? 1;
          final points = user['points'] ?? 0;
          final avatarUrl = user['avatarUrl'];
          final rank = index + 1;

          // Rank styles
          Color? rankColor;
          Widget? rankBadge;

          if (rank == 1) {
            rankColor = const Color(0xFFFFF9C4); // Light Gold background for number 1
            rankBadge = const Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 28);
          } else if (rank == 2) {
            rankBadge = const Icon(Icons.emoji_events, color: Color(0xFFC0C0C0), size: 26);
          } else if (rank == 3) {
            rankBadge = const Icon(Icons.emoji_events, color: Color(0xCDCD7F32), size: 24);
          } else {
            rankBadge = CircleAvatar(
              radius: 12,
              backgroundColor: Colors.grey[200],
              child: Text(
                '$rank',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: rank == 1 ? const Color(0xFFFDFFF0) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: rank == 1 ? const Color(0xFFFFE082) : const Color(0xFFEEEEEE),
                width: rank == 1 ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(rank == 1 ? 0.04 : 0.01),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: SizedBox(
                width: 85,
                child: Row(
                  children: [
                    SizedBox(width: 32, child: Center(child: rankBadge)),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFFF3F4F6),
                      backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                          ? NetworkImage(avatarUrl)
                          : null,
                      child: avatarUrl == null || avatarUrl.isEmpty
                          ? Icon(Icons.person, color: Colors.grey[400])
                          : null,
                    ),
                  ],
                ),
              ),
              title: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: rank <= 3 ? FontWeight.bold : FontWeight.w600,
                  fontSize: 15,
                  color: rank == 1 ? const Color(0xFF8D6E63) : Colors.black87,
                ),
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Cấp $level',
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$points XP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: rank <= 3 ? primaryColor : Colors.grey[700],
                    ),
                  ),
                  const Text(
                    'tích lũy',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
