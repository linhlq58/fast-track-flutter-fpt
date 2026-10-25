# Day 19 – Multi-screen navigation, data passing (Concept/Lecture, 90 mins)

1. Navigation Fundamentals (≈15 mins)
	•	Flutter manages screens as a stack of routes: push adds a screen on top, pop removes it and returns to the previous one
	•	Navigator 1.0 (imperative): Navigator.push, Navigator.pop, pushReplacement, pushAndRemoveUntil, named routes
	•	Navigator 2.0 / Router (declarative): the route stack is derived from app state, which supports deep links and web URLs. It is powerful but verbose, which is why packages wrap it
	•	Intermediate expectation: understand the back stack and choose the right method for each case (e.g., after login use pushReplacement or go, so the user cannot press Back to the login screen)

2. Basic Navigation with Navigator (≈15 mins)
	•	Push and pop:
```dart
Navigator.of(context).push(    
    MaterialPageRoute(builder: (_) => const DetailScreen()),  
);   
Navigator.of(context).pop();
```
	•	Named routes via routes: / onGenerateRoute in MaterialApp: simple, but weakly typed and limited for complex apps
	•	Common mistake: using context after an await when the widget may be unmounted. Always check if (!context.mounted) return; (recap of the mounted check from Day 6)

3. Passing Data Between Screens (≈20 mins)
	•	Forward (constructor arguments, preferred):
```dart
Navigator.push(    
    context,    
    MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),  
);
```
Type-safe, and the compiler catches missing parameters
	•	Via route arguments (settings.arguments): works with named routes but is untyped and needs casting, so use it only when necessary
	•	Backward (returning a result):

```dart
final result = await Navigator.push<bool>(    
    context,    
    MaterialPageRoute(builder: (_) => const EditScreen()),  
);  
if (result == true && context.mounted) {    
    // refresh the list  
}  
// In EditScreen  
Navigator.pop(context, true);
```
	•	Best practice: pass IDs or small objects, not large mutable state. For shared data, use state management (Unit 5-6) instead of passing it screen to screen
	•	Brief note on WillPopScope / PopScope for intercepting the back button (e.g., “discard changes?” dialog)

4. Declarative Routing with go_router (≈25 mins)
	•	Why go_router: URL-based routes, deep link support, redirect logic, and simpler setup than raw Navigator 2.0
```dart
final router = GoRouter(    
    initialLocation: '/',    
    routes: [      
        GoRoute(        
            path: '/',        
            builder: (context, state) => const HomeScreen(),        
            routes: [          
                GoRoute(            
                    path: 'product/:id',            
                    builder: (context, state) =>                
                        ProductDetailScreen(id: state.pathParameters['id']!
                    ),          
                ),       
            ],      
        ),      
        GoRoute(        
            path: '/login',        
            builder: (context, state) => const LoginScreen(),      
        ),    
    ],    
    redirect: (context, state) {      
        final loggedIn = authState.isLoggedIn;      
        if (!loggedIn && state.matchedLocation != '/login') return '/login';      
        return null;    
    },  
);   
// Usage  c
ontext.go('/product/42');     
// replaces the stack  
context.push('/product/42');   // pushes on top of the stack
```
	•	Key distinction: go vs push. go rebuilds the stack to match the location, while push adds a route on top
	•	Path parameters (:id), query parameters (?tab=2), and extra for passing objects (use sparingly, since it is not preserved on web deep links)
	•	Redirect/guard logic for authentication, which ties back to the Day 17 login feature
	•	Preview: bottom navigation with ShellRoute / StatefulShellRoute (mention only, not in scope)
    
5. Common Pitfalls & Wrap-up (≈15 mins)
	•	Pitfalls to review:
	◦	Calling Navigator.push inside build() (causes repeated navigation)
	◦	Using the wrong context (e.g., one above the Navigator)
	◦	Forgetting to handle the back stack after login/logout
	◦	Passing heavy objects through routes instead of IDs
	•	Discussion (≈5 mins): for each case, which method and why?
	1.	Splash screen to Home
	2.	Product list to product detail
	3.	Edit form that returns “saved” to the list
	•	Bridge to Day 20 (Navigation practice): learners build a 3-screen flow (list → detail → edit) with data passing and correct back-stack behavior, matching the rubric already defined
	•	Self-learning before Day 20: read the official Flutter “Navigation and routing” docs and the go_router package page


# Day 20: Navigation practice
 
Task: Build a 3-screen flow with data passing (e.g., list → detail → edit). 
Deliverable: Working navigation flow with correct back-stack behavior.
Evidence: Demo video + Git commit. 
Rubric: Correct navigation setup (40%), data passing accuracy (30%), UX flow (30%).

# Assignment evidence:
![./assets/demo_recording.mov](./assets/demo_recording.mov)