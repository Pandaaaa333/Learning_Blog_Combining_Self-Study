class AdminPostModel {
  final String id;
  final String authorName;
  final String avatarUrl;
  final String contentSnippet;
  final String fullContent;
  final int likes;
  final int commentsCount;
  final String postDate;
  final bool isReported;

  AdminPostModel({
    required this.id,
    required this.authorName,
    required this.avatarUrl,
    required this.contentSnippet,
    required this.fullContent,
    required this.likes,
    required this.commentsCount,
    required this.postDate,
    this.isReported = false,
  });

  factory AdminPostModel.fromJson(Map<String, dynamic> json) {
    String content = json['content'] ?? '';
    return AdminPostModel(
      id: json['id'] ?? '',
      authorName: json['userName'] ?? 'Unknown',
      avatarUrl: json['userAvatar'] ?? 'https://i.pravatar.cc/150',
      contentSnippet: content.length > 50 ? '${content.substring(0, 50)}...' : content,
      fullContent: content,
      likes: json['likeCount'] ?? 0,
      commentsCount: json['commentCount'] ?? 0,
      postDate: json['createdAt'] != null ? DateTime.parse(json['createdAt']).toLocal().toString().substring(0, 16) : '',
      isReported: false, // Default since backend doesn't seem to have it in PostDto
    );
  }
}
