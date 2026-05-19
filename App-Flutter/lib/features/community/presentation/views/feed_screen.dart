import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/feed_viewmodel.dart';
import '../widgets/post_card_widget.dart';
import 'other_profile_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../../profile/presentation/viewmodels/profile_viewmodel.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../notifications/presentation/views/notification_screen.dart';
import '../widgets/leaderboard_widget.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FeedViewModel>();
    final profileViewModel = context.watch<ProfileViewModel>();
    final userAvatar = profileViewModel.user?['avatarUrl'];
    const primaryColor = Color(0xFF52B794);

    // Set current user id to FeedViewModel so myPosts can filter correctly
    if (profileViewModel.user != null) {
      final userId = profileViewModel.user!['id'].toString();
      // Use addPostFrameCallback or Future.microtask to avoid state mutation during build
      Future.microtask(() => viewModel.setCurrentUserId(userId));
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 16,
          title: CircleAvatar(
            radius: 20,
            backgroundImage: userAvatar != null && userAvatar.isNotEmpty ? NetworkImage(userAvatar) : null,
            child: (userAvatar == null || userAvatar.isEmpty) ? const Icon(Icons.person, color: Colors.grey) : null,
          ),
          actions: [
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.black,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ),
                        );
                      },
                    ),
                    if (notificationProvider.unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${notificationProvider.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[700],
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF52B794), Color(0xFF3EA380)],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF52B794).withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                tabs: const [
                  Tab(text: 'Feed'),
                  Tab(text: 'Leaderboard'),
                  Tab(text: 'My Posts'),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFECF7F3),
                Color(0xFFF8FAFC),
              ],
            ),
          ),
          child: TabBarView(
            children: [
              // Tab 1: Bảng tin
              _buildPostList(context, viewModel.feedPosts, showHeader: true),
              // Tab 2: Bảng xếp hạng học tập
              const LeaderboardWidget(),
              // Tab 3: Bài viết của tôi
              _buildPostList(context, viewModel.myPosts),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostList(
    BuildContext context,
    List<PostModel> posts, {
    bool showHeader = false,
  }) {
    final viewModel = context.read<FeedViewModel>();
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: posts.length + (showHeader ? 1 : 0),
      itemBuilder: (context, index) {
        if (showHeader && index == 0)
          return _buildCreatePostHeader(context, viewModel);

        final post = posts[showHeader ? index - 1 : index];
        return GestureDetector(
          onTap: () {
            if (post.authorId != viewModel.currentUserId) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OtherProfileScreen(
                    userId: post.authorId,
                    userName: post.authorName,
                  ),
                ),
              );
            }
          },
          child: PostCardWidget(
            post: post,
            onLike: () => viewModel.toggleLike(post.id),
          ),
        );
      },
    );
  }

  Widget _buildCreatePostHeader(BuildContext context, FeedViewModel viewModel) {
    final profileViewModel = context.watch<ProfileViewModel>();
    final userAvatar = profileViewModel.user?['avatarUrl'];

    return GestureDetector(
      onTap: () => _showAddPostBottomSheet(context, viewModel),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF52B794).withOpacity(0.18), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF52B794).withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: userAvatar != null && userAvatar.isNotEmpty ? NetworkImage(userAvatar) : null,
              child: (userAvatar == null || userAvatar.isEmpty) ? const Icon(Icons.person, color: Colors.grey) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Do you have any homework questions?',
                style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.image_outlined, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showAddPostBottomSheet(BuildContext context, FeedViewModel viewModel) {
    final contentController = TextEditingController();
    String? selectedSubjectId = viewModel.userSubjects.isNotEmpty
        ? viewModel.userSubjects.first.id
        : null;
    Uint8List? imageBytes;
    String? imageName;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Create Post',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (contentController.text.trim().isNotEmpty &&
                              selectedSubjectId != null) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            try {
                              await viewModel.createPost(
                                content: contentController.text.trim(),
                                subjectId: selectedSubjectId!,
                                imageBytes: imageBytes,
                                imageName: imageName,
                              );
                              if (context.mounted) {
                                Navigator.pop(context); // Close loading
                                Navigator.pop(context); // Close bottom sheet
                              }
                            } catch (e) {
                              if (context.mounted)
                                Navigator.pop(context); // Close loading
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          } else if (selectedSubjectId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a subject'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF52B794),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Post',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (viewModel.userSubjects.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSubjectId,
                          hint: const Text('Select Subject'),
                          isExpanded: true,
                          items: viewModel.userSubjects.map((s) {
                            return DropdownMenuItem(
                              value: s.id,
                              child: Text(s.name),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => selectedSubjectId = val),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: contentController,
                    autofocus: true,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Enter post content...',
                      border: InputBorder.none,
                    ),
                  ),
                  if (imageBytes != null)
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: MemoryImage(imageBytes!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => setState(() {
                              imageBytes = null;
                              imageName = null;
                            }),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.image_outlined,
                          color: Color(0xFF52B794),
                        ),
                        onPressed: () async {
                          final picker = ImagePicker();
                          final image = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 70,
                          );
                          if (image != null) {
                            final bytes = await image.readAsBytes();
                            setState(() {
                              imageBytes = bytes;
                              imageName = image.name;
                            });
                          }
                        },
                      ),
                      const Text(
                        'Add Image',
                        style: TextStyle(
                          color: Color(0xFF52B794),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
