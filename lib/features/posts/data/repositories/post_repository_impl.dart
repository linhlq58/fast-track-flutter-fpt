import 'package:dio/dio.dart';
import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/posts_result.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/posts_local_data_source.dart';
import '../datasources/posts_remote_data_source.dart';
import '../models/post_mapper.dart';

class PostRepositoryImpl implements PostRepository {
  const PostRepositoryImpl({required PostsRemoteDataSource remote, required PostsLocalDataSource local})
      : _remote = remote, _local = local;
  final PostsRemoteDataSource _remote;
  final PostsLocalDataSource _local;

  @override
  Future<PostsResult> getPosts() async {
    try {
      final models = await _remote.fetchPosts();
      // Cache failures must not hide a successful network response.
      try { await _local.cachePosts(models); } catch (_) { /* Best-effort cache. */ }
      return PostsResult(posts: models.map((m) => m.toEntity()).toList(), isFromCache: false);
    } catch (error) {
      final failure = _mapFailure(error);
      try {
        final cached = await _local.getCachedPosts();
        if (cached != null) {
          return PostsResult(
            posts: cached.posts.map((m) => m.toEntity()).toList(),
            isFromCache: true,
            cachedAt: cached.cachedAt,
          );
        }
      } catch (_) { /* Fall through to mapped network error. */ }
      throw failure;
    }
  }

  AppFailure _mapFailure(Object error) {
    if (error is AppFailure) return error;
    if (error is FormatException || error is TypeError) return const ParseFailure();
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const TimeoutFailure();
        case DioExceptionType.connectionError:
          return const NetworkFailure();
        case DioExceptionType.badResponse:
          final status = error.response?.statusCode;
          return status != null && status >= 500 ? const ServerFailure() : const ClientFailure();
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
