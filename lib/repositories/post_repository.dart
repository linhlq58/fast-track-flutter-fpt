import 'package:dio/dio.dart';
import 'package:fast_track_flutter_fpt/core/errors/app_failure.dart';
import 'package:fast_track_flutter_fpt/repositories/posts_repository.dart';

import '../core/network/dio_client.dart';
import '../models/post.dart';

class PostRepository implements PostsRepository {
  PostRepository({required DioClient client})
      : _dioClient = client;

  final DioClient _dioClient;

  @override
  Future<List<Post>> getPosts() async {
    try {
      final response = await _dioClient.dio.get<List<dynamic>>('/posts');

      final data = response.data ?? [];

      return data
          .map(
            (json) => Post.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException {
      throw const ParseFailure();
    } on TypeError {
      throw const ParseFailure();
    }
  }

  AppFailure _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;

        if (statusCode == 401) {
          return const UnauthorizedFailure();
        }

        if (statusCode != null && statusCode >= 500) {
          return ServerFailure(statusCode);
        }

        return ClientFailure(statusCode);

      case DioExceptionType.cancel:
        // Cancellation is not necessarily an application failure.
        return const UnknownFailure();

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
      default:
        return const UnknownFailure();
    }
  }
}
