import 'package:fast_track_flutter_fpt/core/network/dio_client.dart';
import 'package:fast_track_flutter_fpt/repositories/post_repository.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  final dioClient = DioClient();

  final postRepository = PostRepository(
    client: dioClient,
  );

  runApp(
    MyApp(
      postRepository: postRepository,
    ),
  );
}
