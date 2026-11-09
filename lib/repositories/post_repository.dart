import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/errors/app_failure.dart';
import '../core/network/dio_client.dart';
import '../data/local/posts_local_data_source.dart';
import '../models/post.dart';
import 'posts_result.dart';

class PostRepository {
  PostRepository({
    required DioClient client,
    required PostsLocalDataSource localDataSource,
  })  : _dioClient = client,
        _localDataSource = localDataSource;

  final DioClient _dioClient;
  final PostsLocalDataSource _localDataSource;

  /// Network-first strategy:
  /// 1. Fetch fresh posts.
  /// 2. Save them locally.
  /// 3. If the request fails, return the last saved response if available.
  Future<PostsResult> getPosts() async {
    try {
      final response = await _dioClient.dio.get<List<dynamic>>('/posts');
      final data = response.data ?? <dynamic>[];

      final posts = data.map((json) {
        if (json is! Map) {
          throw const FormatException('Post must be a JSON object.');
        }

        return Post.fromJson(Map<String, dynamic>.from(json));
      }).toList();

      // Cache failure should not turn a successful API request into a failed
      // screen. Log it, but still return the fresh server response.
      try {
        await _localDataSource.cachePosts(posts);
      } catch (error, stackTrace) {
        debugPrint('Unable to save posts cache: $error');
        debugPrintStack(stackTrace: stackTrace);
      }

      return PostsResult(
        posts: posts,
        isFromCache: false,
      );
    } catch (error) {
      final failure = _mapFailure(error);

      final cached = await _readCacheSafely();
      if (cached != null) {
        return PostsResult(
          posts: cached.posts,
          isFromCache: true,
          cachedAt: cached.cachedAt,
        );
      }

      throw failure;
    }
  }

  Future<dynamic> _readCacheSafely() async {
    try {
      return await _localDataSource.getCachedPosts();
    } catch (error, stackTrace) {
      debugPrint('Unable to retrieve posts cache: $error');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  AppFailure _mapFailure(Object error) {
    if (error is AppFailure) return error;

    if (error is FormatException || error is TypeError) {
      return const ParseFailure();
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const TimeoutFailure();

        case DioExceptionType.connectionError:
          return const NetworkFailure();

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode != null && statusCode >= 500) {
            return const ServerFailure();
          }
          return const ClientFailure();

        case DioExceptionType.cancel:
          return const UnknownFailure();

        case DioExceptionType.badCertificate:
        case DioExceptionType.unknown:
        default:
          return const NetworkFailure();
      }
    }

    return const UnknownFailure();
  }
}
