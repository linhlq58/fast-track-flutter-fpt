import 'package:flutter_bloc/flutter_bloc.dart';

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
        clearError: true,
      ),
    );

    try {
      final posts = await _postRepository.getPosts();

      emit(
        state.copyWith(
          status: PostsStatus.success,
          posts: posts,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PostsStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}