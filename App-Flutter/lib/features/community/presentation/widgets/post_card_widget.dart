import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/viewmodels/feed_viewmodel.dart';
import 'comments_bottom_sheet.dart';

class PostCardWidget extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onLike;

  const PostCardWidget({
    Key? key,
    required this.post,
    this.onLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF52B794).withOpacity(0.18), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF52B794).withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER: Avatar, Name, Time, Subject Tag
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF52B794).withOpacity(0.3), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF52B794).withOpacity(0.1),
                    backgroundImage: post.avatarUrl != null && post.avatarUrl!.isNotEmpty 
                        ? NetworkImage(post.avatarUrl!) 
                        : null,
                    child: (post.avatarUrl == null || post.avatarUrl!.isEmpty) 
                        ? const Icon(Icons.person, color: Color(0xFF52B794)) 
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            post.timeAgo,
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                          ),
                          if (post.subjectName.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF52B794).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                post.subjectName,
                                style: const TextStyle(
                                  color: Color(0xFF3EA380),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.grey),
                  onPressed: () {
                    final viewModel = context.read<FeedViewModel>();
                    final currentUserId = viewModel.currentUserId;
                    final isMyPost = post.authorId == currentUserId;

                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            if (isMyPost) ...[
                              ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                                ),
                                title: const Text(
                                  'Xóa bài viết',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: const Text('Bài viết sẽ bị xóa vĩnh viễn khỏi hệ thống'),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  _showDeleteConfirmationDialog(context, viewModel, post.id);
                                },
                              ),
                            ] else ...[
                              ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.report_problem_outlined, color: Colors.amber),
                                ),
                                title: const Text(
                                  'Báo cáo vi phạm',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: const Text('Báo cáo nội dung không phù hợp hoặc vi phạm chính sách'),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  _showReportBottomSheet(context, viewModel, post.id);
                                },
                              ),
                            ],
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // CONTENT: Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              post.content,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Color(0xFF334155),
                height: 1.5,
              ),
            ),
          ),
          
          // CONTENT: Image (Optional)
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(post.imageUrl!),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            
          const SizedBox(height: 16),
          
          // FOOTER: Actions
          if (onLike != null) ...[
            Divider(height: 1, color: Colors.grey.shade100, thickness: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  _buildActionButton(
                    icon: post.isLikedByMe ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    label: '${post.likes}',
                    color: post.isLikedByMe ? Colors.redAccent : Colors.grey.shade600,
                    backgroundColor: post.isLikedByMe ? Colors.redAccent.withOpacity(0.1) : Colors.transparent,
                    onTap: onLike!,
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: '${post.commentCount}',
                    color: Colors.grey.shade600,
                    backgroundColor: Colors.transparent,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => CommentsBottomSheet(postId: post.id),
                      );
                    },
                  ),
                  const Spacer(),
                  _buildActionButton(
                    icon: Icons.share_outlined,
                    label: '',
                    color: Colors.grey.shade600,
                    backgroundColor: Colors.transparent,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon, 
    required String label, 
    required Color color, 
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600, 
                  fontSize: 14, 
                  color: color
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, FeedViewModel viewModel, String postId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Xóa bài viết?'),
          ],
        ),
        content: const Text('Bạn có chắc chắn muốn xóa bài viết này không? Thao tác này không thể hoàn tác.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Hủy', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx); // Đóng dialog
              try {
                await viewModel.deletePost(postId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Đã xóa bài viết thành công'),
                        ],
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lỗi khi xóa bài viết: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Xóa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showReportBottomSheet(BuildContext context, FeedViewModel viewModel, String postId) {
    final reasons = [
      'Spam / Quảng cáo quá đà',
      'Nội dung phản cảm, đồi trụy',
      'Ngôn từ gây thù ghét, quấy rối',
      'Thông tin sai lệch, lừa đảo',
      'Khác'
    ];
    String selectedReason = reasons.first;
    final otherReasonController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (stateContext, setSheetState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(stateContext).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  'Báo cáo vi phạm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Vui lòng chọn lý do báo cáo bài viết này. Phản hồi của bạn giúp chúng tôi xây dựng cộng đồng tốt hơn.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ...reasons.map((reason) => RadioListTile<String>(
                      activeColor: const Color(0xFF52B794),
                      title: Text(reason, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      value: reason,
                      groupValue: selectedReason,
                      onChanged: (val) {
                        if (val != null) {
                          setSheetState(() => selectedReason = val);
                        }
                      },
                    )),
                if (selectedReason == 'Khác') ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      controller: otherReasonController,
                      maxLength: 100,
                      decoration: InputDecoration(
                        hintText: 'Nhập lý do báo cáo của bạn...',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text('Hủy', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          String finalReason = selectedReason;
                          if (selectedReason == 'Khác') {
                            finalReason = otherReasonController.text.trim();
                            if (finalReason.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Vui lòng nhập lý do báo cáo khác'),
                                  backgroundColor: Colors.amber,
                                ),
                              );
                              return;
                            }
                          }
                          
                          Navigator.pop(ctx); // Close sheet
                          
                          try {
                            await viewModel.reportPost(postId, finalReason);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text('Cảm ơn bạn đã báo cáo. Chúng tôi sẽ xem xét sớm nhất!'),
                                    ],
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Lỗi khi gửi báo cáo: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF52B794),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Gửi báo cáo',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
