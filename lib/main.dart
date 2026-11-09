import 'package:fast_track_flutter_fpt/core/network/dio_client.dart';
import 'package:fast_track_flutter_fpt/data/local/posts_local_data_source.dart';
import 'package:fast_track_flutter_fpt/repositories/post_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  final postsBox = await Hive.openBox<dynamic>('posts_cache');
  final localDataSource = PostsLocalDataSource(postsBox);

  final dioClient = DioClient();

  final postRepository = PostRepository(
    client: dioClient,
    localDataSource: localDataSource,
  );

  runApp(
    MyApp(
      postRepository: postRepository,
    ),
  );
}
