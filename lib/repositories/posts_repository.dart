import 'package:fast_track_flutter_fpt/models/post.dart';

abstract interface class PostsRepository {
  Future<List<Post>> getPosts();
}