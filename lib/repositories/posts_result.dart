import '../models/post.dart';

class PostsResult {
  const PostsResult({
    required this.posts,
    required this.isFromCache,
    this.cachedAt,
  });

  final List<Post> posts;
  final bool isFromCache;
  final DateTime? cachedAt;
}
