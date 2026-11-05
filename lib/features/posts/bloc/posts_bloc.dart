import 'package:fast_track_flutter_fpt/repositories/posts_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/app_failure.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc({
    required PostsRepository postRepository,
  })  : _postRepository = postRepository,
        super(const PostsState()) {
    on<PostsRequested>(_onPostsRequested);
  }

  final PostsRepository _postRepository;

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
      final posts = await _postRepository.getPosts();

      if (posts.isEmpty) {
        emit(
          state.copyWith(
            status: PostsStatus.empty,
            posts: posts,
            clearFailure: true,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: PostsStatus.success,
          posts: posts,
          clearFailure: true,
        ),
      );
    } on AppFailure catch (failure) {
      emit(
        state.copyWith(
          status: PostsStatus.failure,
          failure: failure,
        ),
      );
    } catch (error, stackTrace) {
      // Unexpected programming or runtime error.
      // Log error and stackTrace in a real application.
      addError(error, stackTrace);

      emit(
        state.copyWith(
          status: PostsStatus.failure,
          failure: const UnknownFailure(),
        ),
      );
    }
  }
}