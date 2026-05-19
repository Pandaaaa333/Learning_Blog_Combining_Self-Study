import 'package:flutter/material.dart';
import 'package:fe_admin_web/domain/entities/admin_post_model.dart';

class PostDetailModal extends StatelessWidget {
  final AdminPostModel post;
  final VoidCallback onDelete;

  const PostDetailModal({
    super.key,
    required this.post,
    required this.onDelete,
  });

  void _showInteractionList(
      BuildContext context, String title, List<String> names) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: names.length > 10 ? 11 : names.length,
              itemBuilder: (context, index) {
                if (index == 10) {
                  return Text('và ${names.length - 10} người khác...');
                }
                return Text(names[index]);
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mock data for likes and comments
    final List<String> likers =
        List.generate(post.likes, (index) => 'Người dùng ${index + 1}');
    final List<String> commenters = List.generate(
        post.commentsCount, (index) => 'Người bình luận ${index + 1}');

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFFF9FAFB),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Chi tiết bài viết',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints()),
          ],
        ),
      ),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                    radius: 20, 
                    backgroundColor: Color(0xFFE0E0E0),
                    child: Icon(Icons.person, color: Colors.grey)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.authorName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(post.postDate,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(post.fullContent,
                style: const TextStyle(fontSize: 15, height: 1.5)),
            const SizedBox(height: 24),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () =>
                          _showInteractionList(context, 'Lượt thích', likers),
                      child: Text('${post.likes} Lượt thích',
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600)),
                    ),
                    const Text('•',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w600)),
                    TextButton(
                      onPressed: () => _showInteractionList(
                          context, 'Bình luận', commenters),
                      child: Text('${post.commentsCount} Bình luận',
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Xóa bài này'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
