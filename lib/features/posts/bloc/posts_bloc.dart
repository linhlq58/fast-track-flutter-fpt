import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/app_failure.dart';
import '../../../repositories/post_repository.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc({
    required PostRepository postRepository,
  })  : _postRepository = postRepository,
        super(const PostsState()) {
    on<PostsRequested>(_onPostsRequested);
  }

  final PostRepository _postRepository;

  Future<void> _onPostsRequested(
    PostsRequested event,
    Emitter<PostsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PostsStatus.loading,
        clearFailure: true,
      ),
    );

    try {
      final result = await _postRepository.getPosts();

      emit(
        state.copyWith(
          status: result.posts.isEmpty
              ? PostsStatus.empty
              : PostsStatus.success,
          posts: result.posts,
          isFromCache: result.isFromCache,
          cachedAt: result.cachedAt,
          clearCachedAt: !result.isFromCache,
          clearFailure: true,
        ),
      );
    } on AppFailure catch (failure) {
      emit(
        state.copyWith(
          status: PostsStatus.failure,
          failure: failure,
          isFromCache: false,
          clearCachedAt: true,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);

      emit(
        state.copyWith(
          status: PostsStatus.failure,
          failure: const UnknownFailure(),
          isFromCache: false,
          clearCachedAt: true,
        ),
      );
    }
  }
}
