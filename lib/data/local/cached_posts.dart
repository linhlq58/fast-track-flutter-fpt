import '../../models/post.dart';

class CachedPosts {
  const CachedPosts({
    required this.posts,
    required this.cachedAt,
  });

  final List<Post> posts;
  final DateTime cachedAt;
}
