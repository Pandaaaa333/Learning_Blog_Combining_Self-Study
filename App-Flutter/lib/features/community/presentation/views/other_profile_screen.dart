import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/feed_viewmodel.dart';
import '../widgets/post_card_widget.dart';

class OtherProfileScreen extends StatelessWidget {
  final String userId;
  final String userName;

  const OtherProfileScreen({super.key, required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FeedViewModel>();
    final userPosts = viewModel.getPostsByUser(userId);
    final isFollowing = viewModel.isFollowing(userId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, leading: const BackButton(color: Colors.black)),
      body: Column(
        children: [
          // Header: Avatar, Tên, Nút theo dõi
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const CircleAvatar(radius: 50, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 50, color: Colors.white)),
                const SizedBox(height: 16),
                Text(userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () => viewModel.toggleFollow(userId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFollowing ? Colors.grey[200] : const Color(0xFF52B794),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      isFollowing ? 'Đang theo dõi' : 'Theo dõi',
                      style: TextStyle(color: isFollowing ? Colors.black87 : Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Danh sách bài đăng của họ
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userPosts.length,
              itemBuilder: (context, index) => PostCardWidget(post: userPosts[index]),
            ),
          ),
        ],
      ),
    );
  }
}
