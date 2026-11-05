import '../core/errors/app_failure.dart';
import '../models/post.dart';
import 'posts_repository.dart';

enum DebugScenario {
  networkError,
  timeout,
  empty,
  success,
}

class DebugPostRepository implements PostsRepository {
  const DebugPostRepository({
    required this.scenario,
  });

  final DebugScenario scenario;

  @override
  Future<List<Post>> getPosts() async {
    switch (scenario) {
      case DebugScenario.networkError:
        throw const NetworkFailure();

      case DebugScenario.timeout:
        await Future.delayed(const Duration(seconds: 2));
        throw const TimeoutFailure();

      case DebugScenario.empty:
        await Future.delayed(const Duration(milliseconds: 500));
        return [];

      case DebugScenario.success:
        await Future.delayed(const Duration(milliseconds: 500));

        return const [
          Post(
            userId: 1,
            id: 1,
            title: 'Example post',
            body: 'This is an example post.',
          ),
        ];
    }
  }
}