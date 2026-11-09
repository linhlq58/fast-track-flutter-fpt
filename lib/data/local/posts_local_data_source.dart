import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

import '../../models/post.dart';
import 'cached_posts.dart';

class PostsLocalDataSource {
  PostsLocalDataSource(this._box);

  final Box<dynamic> _box;

  static const _postsKey = 'posts';
  static const _cachedAtKey = 'cachedAt';

  Future<void> cachePosts(List<Post> posts) async {
    final jsonList = posts.map((post) => post.toJson()).toList();

    // Store the payload and timestamp together so they describe the same cache.
    await _box.put(_postsKey, jsonEncode(jsonList));
    await _box.put(
      _cachedAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<CachedPosts?> getCachedPosts() async {
    final raw = _box.get(_postsKey);
    final timestamp = _box.get(_cachedAtKey);

    if (raw is! String || timestamp is! int) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        throw const FormatException('Cached posts must be a JSON list.');
      }

      final posts = decoded.map((item) {
        if (item is! Map) {
          throw const FormatException('Cached post must be a JSON object.');
        }

        return Post.fromJson(Map<String, dynamic>.from(item));
      }).toList();

      return CachedPosts(
        posts: posts,
        cachedAt: DateTime.fromMillisecondsSinceEpoch(timestamp),
      );
    } catch (error, stackTrace) {
      // A corrupt or outdated cache must not prevent the app from starting.
      debugPrint('Unable to read cached posts: $error');
      debugPrintStack(stackTrace: stackTrace);
      await clearCache();
      return null;
    }
  }

  Future<void> clearCache() async {
    await _box.delete(_postsKey);
    await _box.delete(_cachedAtKey);
  }
}
