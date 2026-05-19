import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fe_mobile/features/community/presentation/viewmodels/feed_viewmodel.dart';
import 'package:fe_mobile/features/community/presentation/views/other_profile_screen.dart';
import 'package:fe_mobile/features/profile/presentation/viewmodels/profile_viewmodel.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FeedViewModel>();
    final profileViewModel = context.watch<ProfileViewModel>();
    final userAvatar = profileViewModel.user?['avatarUrl'];
    const primaryColor = Color(0xFF52B794);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 16,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(4)),
            child: const Text('Avata', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.notifications_none_rounded, color: Colors.black, size: 28), onPressed: () {}),
            const SizedBox(width: 8),
          ],
          bottom: const TabBar(
            labelColor: primaryColor,
            unselectedLabelColor: Colors.black87,
            indicatorColor: primaryColor,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            tabs: [Tab(text: 'Bảng tin'), Tab(text: 'Theo dõi'), Tab(text: 'Của tôi')],
          ),
        ),
        body: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator(color: primaryColor))
            : TabBarView(
                children: [
                  _buildPostList(context, viewModel.feedPosts, showHeader: true),
                  _buildPostList(context, viewModel.followingPosts),
                  _buildPostList(context, viewModel.myPosts),
                ],
              ),
      ),
    );
  }

  Widget _buildPostList(BuildContext context, List<PostModel> posts, {bool showHeader = false}) {
    final profileViewModel = context.watch<ProfileViewModel>();
    final userAvatar = profileViewModel.user?['avatarUrl'];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: posts.length + (showHeader ? 1 : 0),
      itemBuilder: (context, index) {
        if (showHeader && index == 0) {
          return Column(
            children: [
              _buildSubjectSelectionHeader(context),
              _buildCreatePostHeader(context, userAvatar),
            ],
          );
        }
        
        final post = posts[showHeader ? index - 1 : index];
        return PostCardWidget(post: post);
      },
    );
  }

  Widget _buildCreatePostHeader(BuildContext context, String? userAvatar) {
    final viewModel = context.read<FeedViewModel>();
    return GestureDetector(
      onTap: () => _showAddPostBottomSheet(context, viewModel, userAvatar),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[300]!)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: userAvatar != null ? NetworkImage(userAvatar) : const NetworkImage('https://i.pravatar.cc/150?u=me_123'),
              backgroundColor: Colors.grey[200],
              child: userAvatar == null ? const Icon(Icons.person, color: Colors.grey) : null,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text('Bạn có bài tập nào cần hỏi?', style: TextStyle(color: Colors.grey[600], fontSize: 15))),
            const Icon(Icons.image_outlined, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectSelectionHeader(BuildContext context) {
    final viewModel = context.watch<FeedViewModel>();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Môn học quan tâm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => _showSubjectSelectionDialog(context, viewModel),
                child: const Text('Chỉnh sửa', style: TextStyle(color: Color(0xFF52B794))),
              ),
            ],
          ),
          SizedBox(
            height: 40,
            child: viewModel.userSubjects.isEmpty
                ? const Text('Chưa chọn môn học nào', style: TextStyle(color: Colors.grey, fontSize: 14))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: viewModel.userSubjects.length,
                    itemBuilder: (context, index) {
                      final subject = viewModel.userSubjects[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF52B794).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF52B794).withOpacity(0.3)),
                        ),
                        child: Center(
                          child: Text(subject.name, style: const TextStyle(color: Color(0xFF52B794), fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showSubjectSelectionDialog(BuildContext context, FeedViewModel viewModel) {
    List<String> selectedIds = viewModel.userSubjects.map((s) => s.id).toList();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Chọn môn học yêu thích'),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: viewModel.allSubjects.map((subject) {
                      final isSelected = selectedIds.contains(subject.id);
                      return FilterChip(
                        label: Text(subject.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedIds.add(subject.id);
                            } else {
                              selectedIds.remove(subject.id);
                            }
                          });
                        },
                        selectedColor: const Color(0xFF52B794).withOpacity(0.2),
                        checkmarkColor: const Color(0xFF52B794),
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
                ElevatedButton(
                  onPressed: () {
                    viewModel.updateUserSubjects(selectedIds);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF52B794)),
                  child: const Text('Lưu', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddPostBottomSheet(BuildContext context, FeedViewModel viewModel, String? userAvatar) {
    final contentController = TextEditingController();
    String? selectedSubjectId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20, right: 20, top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tạo bài viết', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () async {
                          final content = contentController.text.trim();
                          if (content.isEmpty) return;
                          Navigator.pop(context);
                          await viewModel.createPost(
                            content: content,
                            subjectId: selectedSubjectId ?? '',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF52B794),
                          elevation: 0,
                        ),
                        child: const Text('Đăng', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Author row
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: userAvatar != null ? NetworkImage(userAvatar) : null,
                          backgroundColor: Colors.grey[200],
                          child: userAvatar == null ? const Icon(Icons.person) : null,
                        ),
                        const SizedBox(width: 12),
                        const Text('Tôi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // Content field
                  TextField(
                    controller: contentController,
                    autofocus: true,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Nhập nội dung bài viết...',
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(),

                  // Subject selection
                  const Text('Chọn môn học', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 8),
                  viewModel.allSubjects.isEmpty
                      ? const Text('Không có môn học', style: TextStyle(color: Colors.grey, fontSize: 13))
                      : Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: viewModel.allSubjects.map((subject) {
                            final isSelected = selectedSubjectId == subject.id;
                            return ChoiceChip(
                              label: Text(
                                subject.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected ? Colors.white : const Color(0xFF52B794),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (_) {
                                setSheetState(() {
                                  selectedSubjectId = isSelected ? null : subject.id;
                                });
                              },
                              selectedColor: const Color(0xFF52B794),
                              backgroundColor: const Color(0xFF52B794).withOpacity(0.08),
                              side: BorderSide(
                                color: isSelected ? const Color(0xFF52B794) : const Color(0xFF52B794).withOpacity(0.3),
                              ),
                              showCheckmark: false,
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class PostCardWidget extends StatelessWidget {
  final PostModel post;

  const PostCardWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<FeedViewModel>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (post.authorId != viewModel.currentUserId) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => OtherProfileScreen(userId: post.authorId, userName: post.authorName)),
                );
              }
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20, 
                  backgroundImage: post.avatarUrl != null ? NetworkImage(post.avatarUrl!) : null, 
                  child: post.avatarUrl == null ? const Icon(Icons.person) : null,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Row(
                      children: [
                        Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        if (post.subjectName.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                            child: Text(post.subjectName, style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                    Text(post.timeAgo, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  ]
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Text(post.content, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4)),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => viewModel.toggleLike(post.id),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 4.0, bottom: 4.0),
                  child: Row(
                    children: [
                      Icon(post.isLikedByMe ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 24, color: post.isLikedByMe ? Colors.red : Colors.black87),
                      const SizedBox(width: 6),
                      Text('${post.likes}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _showCommentsBottomSheet(context, viewModel),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded, size: 22, color: Colors.black87),
                      const SizedBox(width: 6),
                      Text('${post.commentCount}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, FeedViewModel viewModel) {
    final commentController = TextEditingController();
    final profileViewModel = context.read<ProfileViewModel>();
    final userAvatar = profileViewModel.user?['avatarUrl'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6, 
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('${post.commentCount} Bình luận', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const Divider(height: 1),
                
                Expanded(
                  child: FutureBuilder<List<CommentModel>>(
                    future: viewModel.fetchComments(post.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (snapshot.hasError) {
                        return Center(child: Text('Lỗi: ${snapshot.error}'));
                      }

                      final comments = snapshot.data ?? [];
                      
                      if (comments.isEmpty) {
                        return const Center(child: Text('Chưa có bình luận nào.\nHãy là người đầu tiên!', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)));
                      }

                      return ListView.builder(
                        itemCount: comments.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 16, 
                                  backgroundImage: comment.avatarUrl != null ? NetworkImage(comment.avatarUrl!) : null, 
                                  child: comment.avatarUrl == null ? const Icon(Icons.person, size: 20) : null,
                                  backgroundColor: Colors.grey[200]
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(comment.authorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                          const SizedBox(width: 8),
                                          Text(comment.timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(comment.content, style: const TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[300]!))),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18, 
                        backgroundImage: userAvatar != null ? NetworkImage(userAvatar) : null,
                        backgroundColor: Colors.grey[200],
                        child: userAvatar == null ? const Icon(Icons.person) : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Thêm bình luận...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                            filled: true,
                            fillColor: const Color(0xFFF3F4F6),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send_rounded, color: Color(0xFF52B794)),
                        onPressed: () {
                          if (commentController.text.trim().isNotEmpty) {
                            viewModel.addComment(post.id, commentController.text.trim());
                            commentController.clear();
                            Navigator.pop(context); 
                            _showCommentsBottomSheet(context, viewModel);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
