import 'package:fast_track_flutter_fpt/repositories/posts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/posts/bloc/posts_bloc.dart';
import 'features/posts/bloc/posts_event.dart';
import 'features/posts/screens/posts_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.postRepository,
  });

  final PostsRepository postRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => PostsBloc(
          postRepository: postRepository,
        )..add(const PostsRequested()),
        child: const PostsScreen(),
      ),
    );
  }
}