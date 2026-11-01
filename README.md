# Day 21 – Dio/http, JSON parsing (freezed/json_serializable) (Concept/Lecture, 90 mins)
1. REST API Recap & Flutter Networking Overview (≈10 mins)
Quick recap of REST concepts: HTTP methods (GET/POST/PUT/PATCH/DELETE), status codes (2xx/4xx/5xx), headers, JSON body
In Flutter, networking is asynchronous, so everything from Day 3 (Future, async/await) applies directly
Intermediate expectation: do not call APIs directly from widgets. Network code belongs in a data layer (repository/data source), which prepares for Unit 11 (Architecture) and the Bloc pattern from Day 15

2. http vs Dio (≈20 mins)
http package: lightweight, official, enough for simple calls

```dart
final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));  
if (response.statusCode == 200) {    
    final json = jsonDecode(response.body) as Map<String, dynamic>;  
}
```
Limitations: no built-in interceptors, no automatic JSON decoding, manual timeout/cancel handling, manual status-code checking
Dio package: feature-rich HTTP client
BaseOptions (baseUrl, connectTimeout, receiveTimeout, default headers)
Interceptors: attach auth tokens, log requests/responses, refresh tokens, centralize error mapping
Automatic JSON decoding, FormData for uploads, CancelToken, download/upload progress
 
```dart
final dio = Dio(BaseOptions(    
    baseUrl: 'https://jsonplaceholder.typicode.com',    
    connectTimeout: const Duration(seconds: 10),    
    receiveTimeout: const Duration(seconds: 10),  
));   

dio.interceptors.add(
    InterceptorsWrapper(    
        onRequest: (options, handler) {      
            options.headers['Authorization'] = 'Bearer $token';      
            handler.next(options);    
        },    
        onError: (e, handler) {      // map to app-level error      
            handler.next(e);    
        },  
    ));   
    
    final response = await dio.get('/posts/1');  
    print(response.data); // already decoded
```

Comparison and guidance: use http for small demos or very simple needs; use Dio in real projects that need interceptors, timeouts, and consistent error handling
Course convention: labs use Dio

3. Manual JSON Parsing (≈15 mins)
Understand the basics before using code generation:
 
```dart
  class Post {    
    final int id;    
    final String title;    
    final String? body;     
    const Post({required this.id, required this.title, this.body});     
    
    factory Post.fromJson(Map<String, dynamic> json) => Post(          
        id: json['id'] as int,          
        title: json['title'] as String,          
        body: json['body'] as String?,        
    );     
    
    Map<String, dynamic> toJson() => {'id': id, 'title': title, 'body': body};  }
```

Link to Day 1: factory constructors and null safety (String?) are applied directly here
Pain points of manual parsing: boilerplate, typos in string keys, casting errors at runtime, hard to maintain for nested/large models
Handling lists and nesting: (json['items'] as List).map((e) => Item.fromJson(e)).toList()

4. Code Generation: json_serializable & freezed (≈25 mins)
Why code generation: compile-time safety, less boilerplate, consistent models
json_serializable:
 
```dart
import 'package:json_annotation/json_annotation.dart';  
part 'post.g.dart';   
  
@JsonSerializable()  
  class Post {    
    final int id;    
    final String title;    
    @JsonKey(name: 'user_id')    
    final int userId;     
    
    const Post({required this.id, required this.title, required this.userId});     
    
    factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);    
    Map<String, dynamic> toJson() => _$PostToJson(this);  }
```
Useful annotations: @JsonKey(name:, defaultValue:, includeIfNull:), explicitToJson: true for nested objects
freezed (builds on json_serializable): immutable models with copyWith, value equality, union types
 
```dart
import 'package:freezed_annotation/freezed_annotation.dart';  
part 'post.freezed.dart';  
part 'post.g.dart';   
  
@freezed  class Post with _$Post {    
    const factory Post({      
        required int id,      
        required String title,      
        @JsonKey(name: 'user_id') 
        required int userId,    
    }) = _Post;     
    
    factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);  
}
```

Connects back to Day 15: freezed gives the immutable state, copyWith, and equality that Bloc relies on, without hand-written Equatable code
Run the generator:
 
```bash
  dart run build_runner build --delete-conflicting-outputs  # or during development  
  dart run build_runner watch --delete-conflicting-outputs
```

Practical tips: commit or ignore generated files according to team convention, and fix “part directive” errors (missing part line or wrong file name), which are the most common beginner mistake

5. Repository Pattern & Wrap-up (≈15 mins)
Place API calls in a repository so UI/Bloc never see Dio directly:
 
```dart
class PostRepository {    
    final Dio _dio;    
    PostRepository(this._dio);     
    Future<List<Post>> getPosts() async {      
        final response = await _dio.get('/posts');      
        return (response.data as List).map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();    
    }  
}
```

Benefits: easy to mock in tests (links to FakeProductRepository in Day 15), single place to change endpoints or libraries
Preview of Day 23-24 (Error handling): this lecture only covers the happy path, and failures (timeouts, 4xx/5xx, no network) will be handled next
Bridge to Day 22 (API integration lab): learners call a public API with Dio, parse it with freezed/json_serializable, and show the data on screen, matching the rubric already defined
Self-learning before Day 22: read the Dio README, and the freezed and json_serializable package pages. Trainer to share the mock/public API list before this session, as noted in the Logistics section


# Day 22: API integration lab
 
Task: Integrate a public REST API using Dio, parse response with freezed/json_serializable.
Deliverable: Screen displaying parsed API data.
Evidence: Demo video + Git commit + generated model files.
Rubric: Correct API call (30%), correct JSON parsing (40%), code structure (30%).

# Assignment evidence:
* Parsed response with freezed/json_serializable in ./lib/models/
* ![Demo recording in ./assets/demo_recording.mov](./assets/demo_recording.mov)