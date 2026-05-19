import 'package:flutter/material.dart';

class CommentModel {
  final String id;
  final String authorName;
  final String avatarUrl;
  final String content;
  final String timeAgo;

  CommentModel({
    required this.id,
    required this.authorName,
    required this.avatarUrl,
    required this.content,
    required this.timeAgo,
  });
}

class PostModel {
  final String id;
  final String authorId;
  final String authorName;
  final String avatarUrl;
  final String timeAgo;
  final String content;
  int likes;
  List<CommentModel> comments; // Danh sách bình luận
  bool isLikedByMe;

  PostModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.avatarUrl,
    required this.timeAgo,
    required this.content,
    this.likes = 0,
    List<CommentModel>? comments,
    this.isLikedByMe = false,
  }) : comments = comments ?? [];
}

class FeedViewModel extends ChangeNotifier {
  final String currentUserId = 'me_123';

  final List<PostModel> _allPosts = [
    PostModel(
      id: '1', 
      authorId: 'user_456', 
      authorName: 'Đức Anh',
      avatarUrl: 'https://i.pravatar.cc/150?u=user_456', 
      timeAgo: '29 phút trước', 
      content: 'Mọi người cho mình hỏi bài này giải sao với?', 
      likes: 36, 
      comments: [
        CommentModel(id: 'c1', authorName: 'Lan Hương', avatarUrl: 'https://i.pravatar.cc/150?u=user_789', content: 'Dùng định lý Pitago nhé!', timeAgo: '10 phút trước')
      ],
    ),
    PostModel(
      id: '2', 
      authorId: 'user_789', 
      authorName: 'Lan Hương',
      avatarUrl: 'https://i.pravatar.cc/150?u=user_789', 
      timeAgo: '2 giờ trước', 
      content: 'Có ai đi học nhóm thư viện không?', 
      likes: 10,
    ),
  ];

  List<PostModel> get feedPosts => _allPosts;
  List<PostModel> get myPosts => _allPosts.where((p) => p.authorId == currentUserId).toList();
  List<PostModel> get likedPosts => _allPosts.where((p) => p.isLikedByMe).toList();

  void toggleLike(String postId) {
    final index = _allPosts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _allPosts[index].isLikedByMe = !_allPosts[index].isLikedByMe;
      _allPosts[index].likes += _allPosts[index].isLikedByMe ? 1 : -1;
      notifyListeners();
    }
  }

  void addComment(String postId, String content) {
    final index = _allPosts.indexWhere((p) => p.id == postId);
    if (index != -1 && content.trim().isNotEmpty) {
      _allPosts[index].comments.add(CommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorName: 'Thiên Bảo',
        avatarUrl: 'https://i.pravatar.cc/150?u=me_123',
        content: content,
        timeAgo: 'Vừa xong',
      ));
      notifyListeners();
    }
  }

  void addPost(String content) {
    _allPosts.insert(0, PostModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorId: currentUserId,
      authorName: 'Thiên Bảo',
      avatarUrl: 'https://i.pravatar.cc/150?u=me_123',
      timeAgo: 'Vừa xong',
      content: content,
    ));
    notifyListeners();
  }
}