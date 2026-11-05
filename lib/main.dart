import 'package:fast_track_flutter_fpt/core/network/dio_client.dart';
import 'package:fast_track_flutter_fpt/repositories/debug_post_repository.dart';
import 'package:fast_track_flutter_fpt/repositories/post_repository.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  // final dioClient = DioClient();

  // final postRepository = PostRepository(
  //   client: dioClient,
  // );

  // to mock the response for testing error handling
  const postRepository = DebugPostRepository(
    scenario: DebugScenario.empty,
  );

  runApp(
    MyApp(
      postRepository: postRepository,
    ),
  );
}
