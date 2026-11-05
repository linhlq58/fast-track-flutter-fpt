import 'package:fast_track_flutter_fpt/features/posts/widgets/empty_view.dart';
import 'package:fast_track_flutter_fpt/features/posts/widgets/error_view.dart';
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
              return const SizedBox.shrink();

            case PostsStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case PostsStatus.failure:
              return ErrorView(
                message: state.failure?.message ??
                    'Something went wrong.',
                onRetry: state.failure?.isRecoverable == true
                    ? () {
                        context
                            .read<PostsBloc>()
                            .add(const PostsRequested());
                      }
                    : null,
              );

            case PostsStatus.empty:
              return const EmptyView(
                message: 'No posts yet.',
              );

            case PostsStatus.success:
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
      )
    );
  }
}
