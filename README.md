# Day 13 – Provider vs Bloc comparison (Concept/Lecture, 90 mins)
1. Why State Management? (≈15 mins)
	•	Recap from Day 6: setState() works for local state inside one widget, but breaks down when multiple screens or distant widgets need the same data (e.g., user session, cart, auth status)
	•	Problems that appear in real projects without a structured approach:
	◦	"Prop drilling": passing data through many constructor layers
	◦	Business logic mixed into UI code, which is hard to test
	◦	Unnecessary rebuilds of large subtrees (links to Day 11)
	•	Local (ephemeral) state vs App (shared) state: the decision rule is whether more than one widget/screen needs to read or change it
	•	Intermediate-level expectation: not just using a library, but being able to justify why a solution fits a given module (this supports LO4 and the "Future" outcome of proposing a solution)

2. Provider Overview (≈20 mins)
	•	Core idea: Provider is a wrapper around InheritedWidget that makes dependency injection and state sharing simpler
	•	Key building blocks:
	◦	ChangeNotifier — holds state and calls notifyListeners() when it changes
	◦	ChangeNotifierProvider — exposes the notifier to the widget subtree
	◦	Consumer, context.watch<T>(), context.read<T>(), context.select<T, R>()

```dart
class CartModel extends ChangeNotifier {    
    final List<Item> _items = [];    
    List<Item> get items => List.unmodifiable(_items);     
    
    void add(Item item) {      
        _items.add(item);      
        notifyListeners();    
    }  
}
// Consume  final cart = context.watch<CartModel>();
```
	•	Rule to emphasize: watch inside build() (rebuilds on change), read inside callbacks such as onPressed (no rebuild). Mixing these up is a very common bug
	•	Strengths: low boilerplate, easy to learn, officially recommended starting point
	•	Weaknesses: no enforced structure, so logic can become inconsistent across a team; state transitions are implicit (just mutate and notify), which makes debugging and testing harder on large projects
    
3. Bloc / Cubit Overview (≈25 mins)
	•	Core idea: Bloc separates events/input from states/output with a predictable, one-directional flow
	◦	Cubit — simpler form: methods call emit(newState) directly
	◦	Bloc — event-driven: add(Event) → handler maps it to emit(State)
	•	Key widgets: BlocProvider, BlocBuilder (rebuild UI), BlocListener (side effects such as navigation or snackbars), BlocConsumer (both), buildWhen / listenWhen for fine-grained control
 
```dart
 
// Cubit example  
class CounterCubit extends Cubit<int> {    
    CounterCubit() : super(0);    
    
    void increment() => emit(state + 1);  
}

// Bloc example (event-driven)  
sealed class AuthEvent {}  
class LoginRequested extends AuthEvent {    
    final String email, password;    
    LoginRequested(this.email, this.password);  
}   

class AuthBloc extends Bloc<AuthEvent, AuthState> {    
    AuthBloc() : super(AuthInitial()) {      
        on<LoginRequested>((event, emit) async {        
            emit(AuthLoading());        
            try {          
                // call repository          
                emit(AuthSuccess());        
            } catch (e) {          
                emit(AuthFailure(e.toString()));        
            }      
        });    
    }  
}
```

	•	Connect back to Day 4: Bloc exposes Stream<State>, so the Stream knowledge from Unit 1 applies directly
	•	State modeling: use immutable states (ideally with Equatable or freezed) so Bloc can skip duplicate emissions
	•	Strengths: predictable and traceable state transitions, strong separation of UI and logic, very testable (bloc_test), scales well for larger teams
	•	Weaknesses: more boilerplate, steeper learning curve, can be overkill for simple screens

4. Side-by-Side Comparison (≈20 mins)
	•	Discussion activity (≈10 mins, group): give 3 scenarios and ask learners to choose and justify:
	1.	A theme toggle (light/dark)
	2.	A multi-step checkout with loading/error/retry
	3.	A product list with search and pagination
	•	Expected insight: there is no universal winner, the choice depends on complexity, team size, and testing needs

5. Wrap-up & Bridge to Labs (≈10 mins)
	•	Recap the decision criteria so learners can present a justification in their own words
	•	Preview Day 14 (Provider practice) and Day 16 (Bloc practice): learners will implement the same feature in both approaches and write comparison notes, matching the rubric already defined for those labs
	•	Self-learning before Day 14: read the official Provider docs (the "Simple app state management" page on flutter.dev) and the flutter_bloc "Getting Started" guide


# Day 14: Provider practice
 
Task: Build a counter/cart feature using Provider for state management. 
Deliverable: Working feature with state persisted across widget rebuilds.
Evidence: Demo video + Git commit. 
Rubric: Correct Provider setup (40%), state update logic (30%), code organization (30%).


# Assignment demo
![./assets/demo_recording.mov](./assets/demo_recording.mov)