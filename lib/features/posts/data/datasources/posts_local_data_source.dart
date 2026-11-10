import 'dart:convert';
import 'package:hive_ce/hive.dart';
import '../models/post.dart';

class CachedPosts {
  const CachedPosts({required this.posts, required this.cachedAt});
  final List<Post> posts;
  final DateTime cachedAt;
}

class PostsLocalDataSource {
  const PostsLocalDataSource(this._box);
  final Box<dynamic> _box;
  static const _payloadKey = 'posts_payload_v2';
  static const _legacyPostsKey = 'posts';
  static const _legacyTimeKey = 'cachedAt';

  Future<void> cachePosts(List<Post> posts) async {
    final payload = jsonEncode({
      'posts': posts.map((post) => post.toJson()).toList(),
      'cachedAt': DateTime.now().millisecondsSinceEpoch,
    });
    // A single Hive write prevents a mismatched timestamp and post list.
    await _box.put(_payloadKey, payload);
  }

  Future<CachedPosts?> getCachedPosts() async {
    final payload = _box.get(_payloadKey);
    try {
      if (payload is String) {
        final value = jsonDecode(payload);
        if (value is! Map) throw const FormatException('Invalid cache payload');
        return _parse(value['posts'], value['cachedAt']);
      }
      // Backwards compatibility with Day 27's two-key cache.
      final legacyPosts = _box.get(_legacyPostsKey);
      final legacyTime = _box.get(_legacyTimeKey);
      if (legacyPosts is String && legacyTime is int) {
        return _parse(jsonDecode(legacyPosts), legacyTime);
      }
      return null;
    } catch (_) {
      await clearCache();
      return null;
    }
  }

  CachedPosts _parse(Object? value, Object? time) {
    if (value is! List || time is! int) throw const FormatException('Invalid cached posts');
    final posts = value.map((item) {
      if (item is! Map) throw const FormatException('Invalid cached post');
      return Post.fromJson(Map<String, dynamic>.from(item));
    }).toList();
    return CachedPosts(posts: posts, cachedAt: DateTime.fromMillisecondsSinceEpoch(time));
  }

  Future<void> clearCache() async {
    await _box.delete(_payloadKey);
    await _box.delete(_legacyPostsKey);
    await _box.delete(_legacyTimeKey);
  }
}
