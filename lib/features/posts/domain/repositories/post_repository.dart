import '../entities/posts_result.dart';

abstract interface class PostRepository {
  Future<PostsResult> getPosts();
}
