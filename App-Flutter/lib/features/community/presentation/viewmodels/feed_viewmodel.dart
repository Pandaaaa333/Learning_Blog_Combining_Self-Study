import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fe_mobile/core/models/subject_model.dart';
import '../../data/services/community_service.dart';

class CommentModel {
  final String id;
  final String content;
  final String authorName;
  final String? avatarUrl;
  final String timeAgo;

  CommentModel({
    required this.id,
    required this.content,
    required this.authorName,
    this.avatarUrl,
    required this.timeAgo,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(json['createdAt']);
    return CommentModel(
      id: json['id'],
      content: json['content'],
      authorName: json['userName'],
      avatarUrl: json['userAvatar'],
      timeAgo: _formatTimeAgo(createdAt),
    );
  }

  static String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 7) return DateFormat('dd/MM/yyyy').format(dateTime);
    if (diff.inDays > 0) return '${diff.inDays} ngày trước';
    if (diff.inHours > 0) return '${diff.inHours} giờ trước';
    if (diff.inMinutes > 0) return '${diff.inMinutes} phút trước';
    return 'Vừa xong';
  }
}

class PostModel {
  final String id;
  final String authorId;
  final String authorName;
  final String? avatarUrl;
  final String? imageUrl;
  final String timeAgo;
  final String content;
  final String subjectName;
  int likes;
  int commentCount;
  bool isLikedByMe;
  List<CommentModel> comments;

  PostModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.avatarUrl,
    this.imageUrl,
    required this.timeAgo,
    required this.content,
    required this.subjectName,
    this.likes = 0,
    this.commentCount = 0,
    this.isLikedByMe = false,
    this.comments = const [],
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(json['createdAt']);
    return PostModel(
      id: json['id'],
      authorId: json['userId'],
      authorName: json['userName'],
      avatarUrl: json['userAvatar'],
      imageUrl: json['imageUrl'],
      timeAgo: CommentModel._formatTimeAgo(createdAt),
      content: json['content'],
      subjectName: json['subjectName'] ?? '',
      likes: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      isLikedByMe: json['isLiked'] ?? false,
    );
  }
}

class FeedViewModel extends ChangeNotifier {
  final CommunityService _communityService = CommunityService();
  
  List<PostModel> _feedPosts = [];
  List<SubjectModel> _allSubjects = [];
  List<SubjectModel> _userSubjects = [];
  
  bool _isLoading = false;
  String? _currentUserId;

  // Leaderboard State
  List<dynamic> _leaderboardUsers = [];
  bool _isLeaderboardLoading = false;
  String? _leaderboardError;

  List<PostModel> get feedPosts => _feedPosts;
  List<PostModel> get followingPosts => _feedPosts.where((p) => _followingUserIds.contains(p.authorId)).toList();
  List<PostModel> get myPosts => _currentUserId != null ? _feedPosts.where((p) => p.authorId == _currentUserId).toList() : [];
  List<SubjectModel> get allSubjects => _allSubjects;
  List<SubjectModel> get userSubjects => _userSubjects;
  bool get isLoading => _isLoading;
  String? get currentUserId => _currentUserId;

  // Leaderboard Getters
  List<dynamic> get leaderboardUsers => _leaderboardUsers;
  bool get isLeaderboardLoading => _isLeaderboardLoading;
  String? get leaderboardError => _leaderboardError;

  void setCurrentUserId(String id) {
    if (_currentUserId != id) {
      _currentUserId = id;
      notifyListeners();
    }
  }

  FeedViewModel() {
    refreshAll();
  }

  Future<void> refreshAll() async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.wait([
        fetchPosts(),
        fetchAllSubjects(),
        fetchUserSubjects(),
        fetchLeaderboard(),
      ]);
    } catch (e) {
      debugPrint('Error refreshing feed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLeaderboard({int limit = 10}) async {
    _isLeaderboardLoading = true;
    _leaderboardError = null;
    notifyListeners();

    try {
      _leaderboardUsers = await _communityService.getLeaderboard(limit: limit);
    } catch (e) {
      debugPrint('Error fetching leaderboard: $e');
      _leaderboardError = 'Không thể tải bảng xếp hạng. Vui lòng thử lại!';
    } finally {
      _isLeaderboardLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPosts() async {
    try {
      final postsData = await _communityService.getPosts();
      _feedPosts = postsData.map((json) => PostModel.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAllSubjects() async {
    try {
      final subjectsData = await _communityService.getSubjects();
      _allSubjects = subjectsData.map((json) => SubjectModel.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchUserSubjects() async {
    try {
      final subjectsData = await _communityService.getUserSubjects();
      _userSubjects = subjectsData.map((json) => SubjectModel.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserSubjects(List<String> subjectIds) async {
    try {
      await _communityService.updateUserSubjects(subjectIds);
      await fetchUserSubjects();
      await fetchPosts(); // Tải lại bài viết dựa trên sở thích mới
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleLike(String postId) async {
    final index = _feedPosts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _feedPosts[index];
    final wasLiked = post.isLikedByMe;

    // Optimistic UI update
    post.isLikedByMe = !wasLiked;
    post.likes += post.isLikedByMe ? 1 : -1;
    notifyListeners();

    try {
      if (wasLiked) {
        await _communityService.unlikePost(postId);
      } else {
        await _communityService.likePost(postId);
      }
    } catch (e) {
      // Revert if failed
      post.isLikedByMe = wasLiked;
      post.likes += wasLiked ? 1 : -1;
      notifyListeners();
    }
  }

  Future<void> addComment(String postId, String content) async {
    try {
      await _communityService.addComment(postId, content);
      // Re-fetch comments or the whole post to update UI
      final postsData = await _communityService.getPosts();
      _feedPosts = postsData.map((json) => PostModel.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CommentModel>> fetchComments(String postId) async {
    try {
      final commentsData = await _communityService.getComments(postId);
      return commentsData.map((json) => CommentModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  List<PostModel> get likedPosts => _feedPosts.where((p) => p.isLikedByMe).toList();
  final List<String> _followingUserIds = [];

  List<PostModel> getPostsByUser(String userId) {
    return _feedPosts.where((p) => p.authorId == userId).toList();
  }

  bool isFollowing(String userId) => _followingUserIds.contains(userId);

  void toggleFollow(String userId) {
    if (_followingUserIds.contains(userId)) {
      _followingUserIds.remove(userId);
    } else {
      _followingUserIds.add(userId);
    }
    notifyListeners();
  }

  Future<void> createPost({
    required String content,
    required String subjectId,
    List<int>? imageBytes,
    String? imageName,
  }) async {
    try {
      await _communityService.createPost(
        content: content,
        subjectId: subjectId,
        imageBytes: imageBytes,
        imageName: imageName,
      );
      await refreshAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _communityService.deletePost(postId);
      _feedPosts.removeWhere((p) => p.id == postId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reportPost(String postId, String reason) async {
    try {
      await _communityService.reportPost(postId, reason);
    } catch (e) {
      rethrow;
    }
  }
}