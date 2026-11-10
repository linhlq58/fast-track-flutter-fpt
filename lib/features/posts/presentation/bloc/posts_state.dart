import 'package:equatable/equatable.dart';
import 'package:fast_track_flutter_fpt/core/errors/app_failure.dart';
import '../../domain/entities/post.dart';

enum PostsStatus {
  initial,
  loading,
  success,
  empty,
  failure,
}

class PostsState extends Equatable {
  const PostsState({
    this.status = PostsStatus.initial,
    this.posts = const [],
    this.failure,
    this.isFromCache = false,
    this.cachedAt,
  });

  final PostsStatus status;
  final List<Post> posts;
  final AppFailure? failure;
  final bool isFromCache;
  final DateTime? cachedAt;

  PostsState copyWith({
    PostsStatus? status,
    List<Post>? posts,
    AppFailure? failure,
    bool clearFailure = false,
    bool? isFromCache,
    DateTime? cachedAt,
    bool clearCachedAt = false,
  }) {
    return PostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      failure: clearFailure ? null : failure ?? this.failure,
      isFromCache: isFromCache ?? this.isFromCache,
      cachedAt: clearCachedAt ? null : cachedAt ?? this.cachedAt,
    );
  }

  @override
  List<Object?> get props => [
        status,
        posts,
        failure,
        isFromCache,
        cachedAt,
      ];
}
