import 'package:flutter/material.dart';
import 'package:fe_admin_web/domain/entities/admin_post_model.dart';
import 'package:fe_admin_web/presentation/widgets/feed/post_data_table.dart';
import 'package:fe_admin_web/presentation/widgets/feed/post_detail_modal.dart';
import 'package:provider/provider.dart';
import 'package:fe_admin_web/data/providers/post_provider.dart';

class FeedManagementScreen extends StatefulWidget {
  const FeedManagementScreen({super.key});

  @override
  State<FeedManagementScreen> createState() => _FeedManagementScreenState();
}

class _FeedManagementScreenState extends State<FeedManagementScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Tất cả';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().fetchPosts();
    });
  }

  void _confirmDeletePost(String postId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa bài viết?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Bạn có chắc chắn muốn xóa bài viết này không? Hành động này không thể hoàn tác.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await context.read<PostProvider>().deletePost(postId);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa bài viết khỏi hệ thống!'), backgroundColor: Colors.red));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa ngay', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPostDetailModal(AdminPostModel post) {
    showDialog(
      context: context,
      builder: (ctx) => PostDetailModal(
        post: post,
        onDelete: () => _confirmDeletePost(post.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        final filteredPosts = postProvider.posts.where((post) {
          final matchesSearch = post.authorName.toLowerCase().contains(_searchQuery.toLowerCase()) || post.contentSnippet.toLowerCase().contains(_searchQuery.toLowerCase());
          final matchesFilter = _selectedFilter == 'Tất cả' || (_selectedFilter == 'Bị báo cáo' && post.isReported) || (_selectedFilter == 'An toàn' && !post.isReported);
          return matchesSearch && matchesFilter;
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 350,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: const InputDecoration(hintText: 'Tìm theo người đăng hoặc nội dung...', prefixIcon: Icon(Icons.search, color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      items: ['Tất cả', 'An toàn', 'Bị báo cáo'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: e == 'Bị báo cáo' ? Colors.red : Colors.black87, fontWeight: e == 'Bị báo cáo' ? FontWeight.bold : FontWeight.normal)))).toList(),
                      onChanged: (value) => setState(() => _selectedFilter = value!),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: postProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : postProvider.error != null
                      ? Center(child: Text(postProvider.error!, style: const TextStyle(color: Colors.red)))
                      : PostDataTable(
                          posts: filteredPosts,
                          onShowDetail: _showPostDetailModal,
                          onDelete: _confirmDeletePost,
                        ),
            ),
          ],
        );
      },
    );
  }
}