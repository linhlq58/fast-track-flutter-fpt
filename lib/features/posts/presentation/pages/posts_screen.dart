import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/posts_bloc.dart';
import '../bloc/posts_event.dart';
import '../bloc/posts_state.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  String _formatCacheTime(DateTime? dateTime) {
    if (dateTime == null) return 'Saved previously';

    final local = dateTime.toLocal();
    final date =
        '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
    final time =
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';

    return 'Last saved: $date $time';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts Explorer'),
        actions: [
          IconButton(
            tooltip: 'Refresh posts',
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
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_off_outlined,
                        size: 52,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Unable to load posts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.failure?.message ??
                            'Something went wrong. Please try again.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () {
                          context.read<PostsBloc>().add(
                                const PostsRequested(),
                              );
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'No saved posts are available offline.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );

            case PostsStatus.empty:
              return Column(
                children: [
                  if (state.isFromCache) _offlineBanner(state),
                  const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 56,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text('No posts available'),
                        ],
                      ),
                    ),
                  ),
                ],
              );

            case PostsStatus.success:
              return Column(
                children: [
                  if (state.isFromCache) _offlineBanner(state),
                  Expanded(
                    child: ListView.separated(
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
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }

  Widget _offlineBanner(PostsState state) {
    return MaterialBanner(
      leading: const Icon(Icons.cloud_off_outlined),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Offline – showing saved posts'),
          Text(
            _formatCacheTime(state.cachedAt),
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
      actions: const [SizedBox.shrink()],
    );
  }
}
