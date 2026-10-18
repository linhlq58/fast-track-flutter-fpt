# Day 15 – Bloc pattern deep-dive (Concept/Lecture, 90 mins)

1. Recap & Bloc Architecture (≈15 mins)
	•	Quick recap from Day 13: Cubit vs Bloc, and why Bloc suits complex flows
	•	Unidirectional data flow: UI → Event → Bloc → State → UI
	•	The three layers in a Bloc-based feature:
	◦	Presentation: widgets that dispatch events and render states
	◦	Business logic: Bloc/Cubit that transforms events into states
	◦	Data: repositories/data sources that the Bloc calls (the Bloc never talks to the API directly)
	•	Why this matters at Intermediate level: the Bloc should hold no UI code and no direct network code, which keeps it testable and reusable (connects forward to Unit 11, Architecture)

2. Designing Events and States (≈20 mins)
	•	Events describe what happened (user intent), named in the past tense: LoginSubmitted, ProductListRefreshed
	•	States describe what the UI should show. Two common modeling approaches:
	◦	Multiple state classes: Initial, Loading, Success, Failure
	◦	Single state class with status enum (more flexible for complex screens):
 
```dart
enum ListStatus { initial, loading, success, failure }     

class ProductState extends Equatable {      
    final ListStatus status;      
    final List<Product> products;      
    final String? errorMessage;       
    
    const ProductState({        
        this.status = ListStatus.initial,        
        this.products = const [],        
        this.errorMessage,      
    });       
    
    ProductState copyWith({        
        ListStatus? status,        
        List<Product>? products,        
        String? errorMessage,      
    }) {        
        return ProductState(          
            status: status ?? this.status,          
            products: products ?? this.products,          
            errorMessage: errorMessage ?? this.errorMessage,        
        );      
    }       
    
    @override      
    List<Object?> get props => [status, products, errorMessage];    
}
```

	•	Immutability + Equatable: Bloc only emits/rebuilds when the new state is not equal to the previous one. Without value equality, duplicate states cause unnecessary rebuilds or, conversely, missed updates
	•	Common mistake: mutating the existing list/state object and re-emitting it (state.products.add(x); emit(state)). Bloc sees the same instance and ignores it
	•	Link to Day 10-11: copyWith pattern + const constructors keep states cheap and predictable

3. Implementing a Bloc End-to-End (≈25 mins)
	•	Live-coding walkthrough of a Product List feature:
 
```dart
sealed class ProductEvent {}
class ProductsFetched extends ProductEvent {}  
class ProductsRefreshed extends ProductEvent {}   

class ProductBloc extends Bloc<ProductEvent, ProductState> {    
    final ProductRepository _repository;     
    
    ProductBloc(this._repository) : super(const ProductState()) {      
        on<ProductsFetched>(_onFetched);      
        on<ProductsRefreshed>(_onFetched);    
    }     
    
    Future<void> _onFetched(      
        ProductEvent event,      
        Emitter<ProductState> emit,    
    ) async {      
        emit(state.copyWith(status: ListStatus.loading));`      
        try {        
            final products = await _repository.getProducts();        
            emit(state.copyWith(status: ListStatus.success, products: products));      
        } catch (e) {        
            emit(state.copyWith(          
                status: ListStatus.failure,          
                errorMessage: e.toString(),        
            ));      
        }   
    }  
}
```
	•	Wire it into the UI:
 
```dart
 BlocProvider(    
    create: (context) => ProductBloc(
        context.read<ProductRepository>())..add(ProductsFetched()), 
        child: const ProductListView(),  
)
```
	•	Explain Emitter and why emit must only be called while the handler is active (using await emit.forEach / emit.onEach for Streams)
	•	Highlight that the async handler uses the Future knowledge from Day 3

4. UI Integration: Builder, Listener, Consumer (≈15 mins)
	•	BlocBuilder → rebuilds UI from state; use buildWhen to limit rebuilds
	•	BlocListener → one-time side effects (SnackBar, navigation, dialogs); never put side effects inside builder
	•	BlocConsumer → both in one widget
	•	BlocSelector → rebuild only when a selected part of the state changes
	•	context.read vs context.watch for Bloc: read to dispatch events, watch/BlocBuilder to render
 
```dart
BlocBuilder<ProductBloc, ProductState>(    
    buildWhen: (prev, curr) => prev.status != curr.status,    
    builder: (context, state) {      
        switch (state.status) {        
            case ListStatus.loading:          
                return const Center(child: CircularProgressIndicator());        
            case ListStatus.failure:          
                return Text(state.errorMessage ?? 'Something went wrong');        
            case ListStatus.success:          
                return ProductList(products: state.products);        
            case ListStatus.initial:          
                return const SizedBox.shrink();      
            }    
        },  
    )
```

5. Event Transformers, Debugging & Testing (≈10 mins)
	•	Event transformers (bloc_concurrency): droppable(), restartable(), sequential(), with a use case for each:
	◦	restartable() → search-as-you-type (cancel the previous request)
	◦	droppable() → prevent double-tap on submit
	•	BlocObserver for logging all events/transitions, which is useful for debugging and for code review
	•	Brief intro to bloc_test: given an event, expect a sequence of states
 
```dart
blocTest<ProductBloc, ProductState>(    
    'emits [loading, success] when fetch succeeds',    
    build: () => ProductBloc(FakeProductRepository()),    
    act: (bloc) => bloc.add(ProductsFetched()),    
    expect: () => [      
        const ProductState(status: ListStatus.loading),      
        isA<ProductState>().having((s) => s.status, 'status', ListStatus.success),    
    ],  
);
```

6. Wrap-up & Bridge to Lab (≈5 mins)
	•	Recap the checklist for a well-built Bloc: immutable states, Equatable, no UI/network code inside, side effects in BlocListener, correct use of buildWhen
	•	Preview Day 16 (Bloc practice): learners rebuild the Day 14 Provider feature with Bloc/Cubit and write comparison notes
	•	Self-learning before Day 16: read the official flutter_bloc docs on “Architecture” and “Modeling State”


# Day 16: Bloc practice
 
Task: Rebuild the same feature (Day 14) using Bloc/Cubit.
Deliverable: Working feature with Bloc pattern (Event–State).
Evidence: Demo video + Git commit. 
Rubric: Correct Bloc structure (40%), event/state handling (30%), comparison notes vs Provider (30%).


# Assignment evidence:
* Provider vs Bloc comparison notes (./COMPARISON_NOTES.md)
* Demo recording: ![./assets/demo_recording.mov](./assets/demo_recording.mov)