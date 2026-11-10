import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/network/dio_client.dart';
import 'features/posts/data/datasources/posts_local_data_source.dart';
import 'features/posts/data/datasources/posts_remote_data_source.dart';
import 'features/posts/data/repositories/post_repository_impl.dart';
import 'features/posts/domain/repositories/post_repository.dart';
import 'features/posts/domain/usecases/get_posts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox<dynamic>('posts_cache');
  // Composition root: the only place concrete infrastructure is assembled.
  final remote = PostsRemoteDataSource(DioClient());
  final local = PostsLocalDataSource(box);
  final PostRepository repository = PostRepositoryImpl(remote: remote, local: local);
  runApp(MyApp(getPosts: GetPosts(repository)));
}
