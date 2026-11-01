import '../core/network/dio_client.dart';
import '../models/post.dart';

class PostRepository {
  PostRepository({required DioClient client})
      : _dioClient = client;

  final DioClient _dioClient;

  Future<List<Post>> getPosts() async {
    final response = await _dioClient.dio.get<List<dynamic>>(
      '/posts',
    );

    final data = response.data ?? [];

    return data.map(
      (json) => Post.fromJson(
        json as Map<String, dynamic>,
      ),
    ).toList();
  }
}
