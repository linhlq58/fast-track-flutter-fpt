import 'package:equatable/equatable.dart';

import '../../../models/post.dart';

enum PostsStatus {
  initial,
  loading,
  success,
  failure,
}

class PostsState extends Equatable {
  const PostsState({
    this.status = PostsStatus.initial,
    this.posts = const [],
    this.errorMessage,
  });

  final PostsStatus status;
  final List<Post> posts;
  final String? errorMessage;

  PostsState copyWith({
    PostsStatus? status,
    List<Post>? posts,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        posts,
        errorMessage,
      ];
}