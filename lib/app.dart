import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/posts/domain/usecases/get_posts.dart';
import 'features/posts/presentation/bloc/posts_bloc.dart';
import 'features/posts/presentation/bloc/posts_event.dart';
import 'features/posts/presentation/pages/posts_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.getPosts});
  final GetPosts getPosts;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Posts Explorer',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo), useMaterial3: true),
    home: BlocProvider(
      create: (_) => PostsBloc(getPosts: getPosts)..add(const PostsRequested()),
      child: const PostsScreen(),
    ),
  );
}
