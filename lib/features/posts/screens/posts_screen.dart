import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/posts_bloc.dart';
import '../bloc/posts_event.dart';
import '../bloc/posts_state.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts Explorer'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<PostsBloc>().add(
                    const PostsRequested(),
                  );
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          switch (state.status) {
            case PostsStatus.initial:
            case PostsStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case PostsStatus.failure:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    const Text('Unable to load posts'),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage ?? 'Unknown error',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PostsBloc>().add(
                              const PostsRequested(),
                            );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );

            case PostsStatus.success:
              if (state.posts.isEmpty) {
                return const Center(
                  child: Text('No posts found'),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.posts.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final post = state.posts[index];

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Post #${post.id} · User #${post.userId}',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(post.body),
                        ],
                      ),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
