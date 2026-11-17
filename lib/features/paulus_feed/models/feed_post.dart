class FeedPost {
  const FeedPost({
    required this.id,
    required this.club,
    required this.initials,
    required this.category,
    required this.title,
    required this.message,
    required this.imagePath,
    required this.likes,
  });

  final String id;
  final String club;
  final String initials;
  final String category;
  final String title;
  final String message;
  final String imagePath;
  final int likes;

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    return FeedPost(
      id: json['id'] as String,
      club: json['club'] as String,
      initials: json['initials'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      imagePath: json['image_path'] as String,
      likes: (json['likes'] as num).toInt(),
    );
  }
}
