import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/post.dart';

class PostsRemoteDataSource {
  const PostsRemoteDataSource(this._client);
  final DioClient _client;

  Future<List<Post>> fetchPosts() async {
    final response = await _client.dio.get<List<dynamic>>('/posts');
    final data = response.data;
    if (data == null) throw const FormatException('Missing posts response.');
    return data.map((item) {
      if (item is! Map) throw const FormatException('Post must be a JSON object.');
      return Post.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }
}
