import 'package:flutter/material.dart';
import 'package:fe_admin_web/domain/entities/admin_post_model.dart';

class PostDataTable extends StatelessWidget {
  final List<AdminPostModel> posts;
  final Function(AdminPostModel) onShowDetail;
  final Function(String) onDelete;

  const PostDataTable({
    super.key,
    required this.posts,
    required this.onShowDetail,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.resolveWith(
                  (states) => const Color(0xFFF9FAFB)),
              dataRowMinHeight: 70,
              dataRowMaxHeight: 70,
              horizontalMargin: 24,
              columnSpacing: 32,
              columns: const [
                DataColumn(
                    label: Text('Người đăng',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Nội dung tóm tắt',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Tương tác',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Thời gian',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Trạng thái',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Hành động',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: posts.map((post) => _buildDataRow(post)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(AdminPostModel post) {
    return DataRow(
      color: WidgetStateProperty.resolveWith(
          (states) => post.isReported ? Colors.red[50] : Colors.white),
      cells: [
        DataCell(
          Row(
            children: [
              const CircleAvatar(
                  radius: 16, 
                  backgroundColor: Color(0xFFE0E0E0),
                  child: Icon(Icons.person, color: Colors.grey)),
              const SizedBox(width: 8),
              Text(post.authorName,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        DataCell(
          SizedBox(
            width: 250,
            child: Text(post.contentSnippet,
                overflow: TextOverflow.ellipsis, maxLines: 1),
          ),
        ),
        DataCell(
          Row(
            children: [
              const Icon(Icons.favorite_rounded,
                  size: 16, color: Colors.redAccent),
              const SizedBox(width: 4),
              Text('${post.likes}'),
              const SizedBox(width: 16),
              const Icon(Icons.chat_bubble_rounded,
                  size: 16, color: Colors.blueAccent),
              const SizedBox(width: 4),
              Text('${post.commentsCount}'),
            ],
          ),
        ),
        DataCell(Text(post.postDate,
            style: const TextStyle(color: Colors.black54))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: post.isReported ? Colors.red : const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              post.isReported ? 'Bị báo cáo' : 'An toàn',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_red_eye_rounded,
                    color: Color(0xFF4A7DFF)),
                tooltip: 'Xem chi tiết',
                onPressed: () => onShowDetail(post),
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded, color: Colors.red),
                tooltip: 'Xóa bài viết',
                onPressed: () => onDelete(post.id),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
