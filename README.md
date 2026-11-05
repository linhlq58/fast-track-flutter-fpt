# Day 23 – Error handling patterns (Concept/Lecture, 60 mins)

1. Why Error Handling Matters (≈10 mins)
Day 21 covered only the happy path. In production, failures are normal: no network, timeouts, server errors, malformed JSON, expired tokens
Junior-level symptoms: app crashes with a red screen, spinner that never stops, blank screen with no explanation, raw exception text shown to the user
Intermediate expectation: every async operation has three explicit outcomes (loading, success, error), and every error is mapped to something the user can understand and act on
Connects to LO6 and to the Day 24 lab (3 error scenarios: network error, timeout, empty state)

2. Types of Errors in a Flutter App (≈10 mins)
Network errors: no connectivity, DNS failure (SocketException, DioExceptionType.connectionError)
Timeouts: connect, send, receive (DioExceptionType.connectionTimeout, receiveTimeout)
HTTP errors: 4xx (client: 400 validation, 401 unauthorized, 404 not found) vs 5xx (server)
Parsing errors: FormatException, TypeError when the JSON shape differs from the model
Business/domain errors: valid response but a failed operation (e.g., “insufficient balance”)
Empty state: not an exception, but a valid result with no data. It must still be handled in the UI
Key distinction: recoverable (retry may help: timeout, 503) vs non-recoverable (retry will not help: 404, 400, parse error)

3. Error Handling in the Data Layer (≈15 mins)
Do not let raw DioException leak into UI/Bloc. Map it into app-level errors in the repository:
 
```dart
sealed class AppFailure {    
    final String message;    
    const AppFailure(this.message);  
}  

class NetworkFailure extends AppFailure {    
    const NetworkFailure() : super('No internet connection');  
}  
    
class TimeoutFailure extends AppFailure {    
    const TimeoutFailure() : super('The request timed out');  
}  

class ServerFailure extends AppFailure {    
    final int? statusCode;    
    const ServerFailure(this.statusCode) : super('Server error');  
}  

class ParseFailure extends AppFailure {    
    const ParseFailure() : super('Unexpected data format');  
}
```

Mapping in the repository:
 
```dart
  Future<List<Post>> getPosts() async {    
    try {      
        final response = await _dio.get('/posts');      
        return (response.data as List)          
            .map((e) => Post.fromJson(e as Map<String, dynamic>))          
            .toList();    
    } on DioException catch (e) {      
        switch (e.type) {        
            case DioExceptionType.connectionTimeout:        
            case DioExceptionType.receiveTimeout:        
            case DioExceptionType.sendTimeout:          
                throw const TimeoutFailure();        
            case DioExceptionType.connectionError:          
                throw const NetworkFailure();        
            case DioExceptionType.badResponse:          
                throw ServerFailure(e.response?.statusCode);        
            default:          
                throw const ServerFailure(null);      
        }    
    } on FormatException {      
        throw const ParseFailure();    
    } on TypeError {      
        throw const ParseFailure();    
    }  
}
```

Alternative to mention (not required): a Result<T> / Either type instead of throwing, so the compiler forces callers to handle failures
Centralize mapping in a Dio interceptor when many endpoints share the same rules (e.g., 401 handling)
Never swallow errors silently (catch (_) {}). Always log or rethrow

4. Representing Loading / Error / Empty / Success in UI State (≈15 mins)
Model all four outcomes explicitly. Recap from Day 15 (status enum + copyWith), extended with an error object and an empty check:
 
```dart
  enum ListStatus { initial, loading, success, empty, failure }
```

UI rendering pattern:
 
```dart
switch (state.status) {    
    case ListStatus.loading:      
        return const Center(child: CircularProgressIndicator());    
    case ListStatus.failure:      
        return ErrorView(        
            message: state.failure?.message ?? 'Something went wrong',        
            onRetry: () => context.read<PostBloc>().add(PostsFetched()),      
        );    
    case ListStatus.empty:      
        return const EmptyView(message: 'No posts yet');    
    case ListStatus.success:      
        return PostList(posts: state.posts);    
    case ListStatus.initial:      
        return const SizedBox.shrink();  
}
```

UX guidelines:
Show a retry action for recoverable errors
Use clear, non-technical messages (no stack traces for users)
Keep previously loaded data visible when a refresh fails (show a SnackBar instead of wiping the screen)
Use BlocListener for one-off feedback (SnackBar) and BlocBuilder for persistent error views (recap from Day 15)
Reuse from Day 10: build ErrorView and EmptyView as reusable widgets

5. Global Error Handling & Wrap-up (≈10 mins)
Safety nets for unexpected errors:
FlutterError.onError for framework errors
PlatformDispatcher.instance.onError for uncaught async errors
runZonedGuarded (older pattern, still seen in existing projects)
Mention crash reporting tools (Firebase Crashlytics, Sentry) at a high level only
Retry strategies: manual retry button (course scope) vs automatic retry with exponential backoff (mention only)
Common pitfalls recap:
Showing e.toString() directly to users
Forgetting to reset the loading state in the failure branch (the “spinner never stops” bug from Day 3)
Treating an empty list as an error, or ignoring it
Using context after await without mounted checks
Bridge to Day 24 (Error handling practice): learners add handling for 3 scenarios (network error, timeout, empty state) to the Day 22 feature and provide a screenshot of each state, matching the rubric already defined
Self-learning before Day 24: read the Dio docs on error handling (DioException) and the Flutter docs on FlutterError.onError


# Day 24: Error handling practice

Task: Add error handling (network error, timeout, empty state) to Day 22 feature. 
Deliverable: Feature handling 3 error scenarios gracefully (UI feedback). 
Evidence: Screenshots of each error state handled.
Rubric: Coverage of error cases (40%), UX clarity (30%), code robustness (30%)


# Assignment evidence:

## 1. Network Error
![Network Error](./assets/network_error_case.png)

## 2. Timeout Error
![Timeout Error](./assets/request_timeout_case.png)

## 3. Empty State
![Empty State](./assets/empty_case.png)

## 4. Success State
![Success State](./assets/successful_case.png)