import '../entities/posts_result.dart';
import '../repositories/post_repository.dart';

class GetPosts {
  const GetPosts(this._repository);
  final PostRepository _repository;
  Future<PostsResult> call() => _repository.getPosts();
}
