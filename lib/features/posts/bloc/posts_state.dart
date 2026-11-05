import 'package:equatable/equatable.dart';

import '../../../core/errors/app_failure.dart';
import '../../../models/post.dart';

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
  });

  final PostsStatus status;
  final List<Post> posts;
  final AppFailure? failure;

  PostsState copyWith({
    PostsStatus? status,
    List<Post>? posts,
    AppFailure? failure,
    bool clearFailure = false,
  }) {
    return PostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, posts, failure];
}