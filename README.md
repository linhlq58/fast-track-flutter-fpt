# Day 28 – Clean Architecture/MVVM (Concept/Lecture, 90 mins)

1. Why Architecture Matters (≈10 mins)
By now learners have built features across Days 2-27: UI, state management, navigation, API, and local storage. Without structure, these pieces tend to tangle: widgets calling Dio directly, Bloc containing JSON parsing, models shared everywhere
Symptoms of poor architecture: hard to test, hard to change one part without breaking another, new team members cannot find where logic lives
Intermediate expectation (LO9, B4 – Analyze): not only follow an existing structure, but explain why it is shaped that way and propose a structure for a new module
Key principle to introduce: Separation of Concerns, where each layer has one responsibility and knows as little as possible about the others

2. Layered Architecture & the Dependency Rule (≈20 mins)
The three layers commonly used in Flutter projects:
Presentation: widgets, screens, Bloc/Cubit/ViewModel (Unit 2-7 content)
Domain: business entities, use cases, repository interfaces (pure Dart, no Flutter or package imports)
Data: repository implementations, remote data sources (Dio, Day 21), local data sources (Hive, Day 26), DTO/models with fromJson
The Dependency Rule: dependencies point inward. Presentation → Domain ← Data. The Domain layer depends on nothing, and Data implements the interfaces that Domain defines
 
```Plain Text
  Presentation  ──►  Domain  ◄──  Data
  (UI, Bloc)      (entities,     (repo impl,
                   use cases,     Dio, Hive,
                   repo interfaces) DTOs)
```

Why this matters: you can swap Dio for another client, or Hive for another store, without touching business logic or UI
Entity vs Model (DTO):
Entity (domain): what the business cares about, no JSON concerns
Model/DTO (data): mirrors the API/storage shape, converts to entity via toEntity()
 
```dart
// domain  
class Post {    
    final int id;    
    final String title;    
    const Post({required this.id, required this.title});  
}   
    
// domain: contract only  
abstract interface class PostRepository {    
    Future<List<Post>> getPosts();  
}   

// data  
class PostModel {    
    final int id;    
    final String title;    
    const PostModel({required this.id, required this.title});     
    factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(id: json['id'] as int, title: json['title'] as String);     
    Post toEntity() => Post(id: id, title: title);  
}   

class PostRepositoryImpl implements PostRepository {    
    final PostRemoteDataSource _remote;    
    final PostLocalDataSource _local;    
    PostRepositoryImpl(this._remote, this._local);     
    
    @override    
    Future<List<Post>> getPosts() async {      
        // cache-then-network from Day 26      
        final models = await _remote.fetchPosts();      
        return models.map((m) => m.toEntity()).toList();    
    }  
}
```

Link to Day 1: abstract interface class and implements are applied here directly

3. MVVM in Flutter (≈15 mins)
MVVM: Model (data/domain) – View (widgets) – ViewModel (holds UI state and logic, exposes it to the View)
In Flutter, the ViewModel is typically a ChangeNotifier (Provider) or a Cubit/Bloc. The pattern is the same as what learners already built: View observes the ViewModel, user actions call ViewModel methods, the ViewModel talks to the domain/repository
Mapping to the course:
Rules for the View: no business logic, no direct API/storage calls. Rules for the ViewModel: no BuildContext, no widget imports (keeps it unit-testable)
Clean Architecture vs MVVM: they are not competing choices. MVVM describes the presentation layer; Clean Architecture describes how the whole app is layered. Many projects combine them
Mention: Flutter’s official architecture guidance also uses a View / ViewModel / Repository / Service structure, so learners will recognize it in other codebases

4. Project Structure & Dependency Injection (≈20 mins)
Two common folder strategies:
Layer-first: lib/presentation, lib/domain, lib/data. Simple, but features get scattered
Feature-first (recommended for growing apps): each feature contains its own layers
 
```Plain Text
    lib/
      core/
        network/        # Dio setup, interceptors
        error/          # AppFailure (Day 23)
        widgets/        # reusable widgets (Day 10)
        utils/
      features/
        posts/
          data/
            datasources/
            models/
            repositories/
          domain/
            entities/
            repositories/
            usecases/
          presentation/
            bloc/
            pages/
            widgets/
        auth/
          ...
      main.dart
```

Use cases (optional layer): one class per business action, such as GetPosts. Useful when logic is non-trivial; for simple CRUD it can be over-engineering. Discuss when to skip it
Dependency Injection: classes receive their dependencies instead of creating them, which keeps layers decoupled and testable
 
```dart
final getIt = GetIt.instance;   
void setupDependencies() {    
    getIt.registerLazySingleton(() => Dio(BaseOptions(baseUrl: '...')));    getIt.registerLazySingleton<PostRemoteDataSource>(        () => PostRemoteDataSource(getIt()));    getIt.registerLazySingleton<PostRepository>(        () => PostRepositoryImpl(getIt(), getIt()));    getIt.registerFactory(() => PostBloc(getIt()));  
}
```

Alternative: constructor injection with RepositoryProvider/Provider, which needs no extra package
Pitfall: using getIt inside widgets or domain classes (service locator anti-pattern). Resolve dependencies at the composition root and pass them in

5. Trade-offs & Proposing a Solution (≈15 mins)
Architecture has a cost: more files, more boilerplate, more concepts for newcomers. Match the structure to the size and lifespan of the project
Discussion activity (group, ≈10 mins): give a new module brief (e.g., “Order history with offline cache and search”) and ask learners to sketch the folders, layers, and key classes, and justify each choice. This supports the “Future” outcome of proposing and justifying a solution
Common mistakes to review: leaking DTOs into the UI, putting Flutter imports in the domain layer, creating one use case per trivial getter, over-abstracting before there is a second implementation

6. Wrap-up & Bridge to Lab (≈10 mins)
Checklist for a well-structured feature: dependencies point inward, UI contains no data-access code, domain is pure Dart, errors are mapped at the data boundary (Day 23), dependencies are injected
Bridge to Day 29 (Refactor to architecture pattern): learners restructure the accumulated project (Days 2-27) into data/domain/presentation layers and provide a before/after folder diagram, matching the rubric already defined
Self-learning before Day 29: read the official Flutter “Architecture” guide and skim the get_it package page
Situation	Suggested approach
Prototype / small app	Light layering, Provider/Cubit + repository
Medium app, small team	Feature-first, Bloc + repository, use cases only where logic is complex
Large app, multiple teams, long-lived	Full Clean Architecture, strict dependency rule, modularization
 
MVVM role	Flutter implementation
View	Screens and widgets (Unit 2-4)
ViewModel	ChangeNotifier (Day 14) or Bloc/Cubit (Day 15-16)
Model	Repository + entities (Day 21-26)

# Day 29: Refactor to architecture pattern
 
Task: Refactor accumulated code (Day 2–27) into Clean Architecture/MVVM layers.
Deliverable: Restructured project with clear layer separation (data/domain/presentation).
Evidence: Git commit showing folder structure + before/after diagram.
Rubric: Correct layer separation (40%), dependency direction correctness (30%), maintainability (30%).

## "Before" folder structure diagram:
lib/
├── core/
│   ├── errors/
│   └── network/
├── data/
│   ├── local
├── features/
│   └── bloc/
│   └── screens/
├── models/
├── repositories/
├── app.dart
└── main.dart

## "After" folder structure diagram:
lib/
├── core/
│   ├── errors/
│   └── network/
├── features/
│   └── posts/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           └── pages/
├── app.dart
└── main.dart