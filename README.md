# Day 6 – Stateless/Stateful, lifecycle
1. Widget Tree, Element Tree, Render Tree (≈15 mins)

Flutter builds UI through 3 parallel trees:
Widget Tree — the immutable configuration/blueprint (what you write in code)
Element Tree — the mutable instance that manages the widget's lifecycle and links widget :left_right_arrow: render object (persists across rebuilds when possible)
Render Tree — handles actual layout, painting, and hit-testing on screen

Key insight for Intermediate level: widgets are cheap and immutable — Flutter doesn't recreate the Element/Render objects on every rebuild, it just diffs the new widget against the old one (this is why const constructors matter — covered in Unit 4)
Quick diagram-style explanation of how setState() triggers a rebuild of the Widget Tree, but the Element Tree decides what actually needs to change

2. StatelessWidget (≈10 mins)

A widget with no mutable state — once built, it doesn't change unless its parent passes new data (new widget instance)
Lifecycle is simple: constructor → build()
Use case: static UI pieces (a label, an icon, a card with fixed content passed via constructor)

```dart
Plain Text
  class UserBadge extends StatelessWidget {    
    final String name;    
    const UserBadge({super.key, required this.name});     
    
    @override    
    Widget build(BuildContext context) {      
        return Text(name);    
    }  
}
```

Common Junior→Intermediate mistake: overusing StatefulWidget when a StatelessWidget + parent-managed state would be simpler and more performant

3. StatefulWidget & Lifecycle Methods (≈25 mins)

A StatefulWidget is split into two classes: the immutable Widget and its mutable State<T> — explain why (so Flutter can preserve state across rebuilds while the widget itself is recreated)
Full lifecycle walkthrough, in order:
createState() — called once when the widget is first inserted
initState() — called once; used for one-time setup (subscriptions, controllers, initial async calls)
didChangeDependencies() — called after initState() and whenever an InheritedWidget it depends on changes
build() — called every time the widget needs to render; must be fast and side-effect-free
didUpdateWidget(oldWidget) — called when the parent rebuilds this widget with new configuration (compare old vs new props)
setState() — triggers build() to run again; only call when data actually changes
deactivate() — called when the widget is temporarily removed from the tree
dispose() — called when the widget is permanently removed; must clean up controllers, streams, listeners here to avoid memory leaks

Visual diagram recommended here (lifecycle flow chart) — trainer should draw/show this on slide
Real code example combining initState() + dispose():

```dart

class CounterWidget extends StatefulWidget {    
    const CounterWidget({super.key});    
    
    @override    
    State<CounterWidget> createState() => _CounterWidgetState();  
}   

class _CounterWidgetState extends State<CounterWidget> {    
    late StreamSubscription _subscription;    
    int _count = 0;     
    
    @override    
    void initState() {      
        super.initState();      
        _subscription = countStream().listen((value) {        
            setState(() => _count = value);      
        });    
    }     
    
    @override    
    void dispose() {      
        _subscription.cancel();      
        super.dispose();    
    }     
    
    @override    
    Widget build(BuildContext context) {      
        return Text('Count: $_count');    
    }  
}
```

4. Choosing Stateless vs Stateful in Real Projects (≈10 mins)

Decision framework: "Does this widget need to change on its own, independent of its parent rebuilding it?" → if yes, Stateful; if no, Stateless
Connect forward: this lifecycle knowledge is essential for Unit 4 (rebuild optimization) and Unit 5–6 (state management), since Provider/Bloc listeners are typically set up in initState() and torn down in dispose()
Common bug pattern to highlight: calling setState() after dispose() (e.g., from a delayed async callback) → causes a runtime error; briefly mention the mounted check as a safeguard

                 StatefulWidget
                       │
                       ▼
                  createState()
                       │
                       ▼
                   initState()
                       │
                       ▼
            didChangeDependencies()
                       │
                       ▼
                     build()
                       │
              ┌────────┴────────┐
              │                 │
        setState()        Parent rebuilds
              │                 │
              │                 ▼
              │         didUpdateWidget()
              │                 │
              └────────┬────────┘
                       ▼
                     build()
                       │
                       │
              Widget removed
                       ▼
                  deactivate()
                       │
                       ▼
                    dispose()

# Day 7: Assignment
 Build simple widgets

Task: Build 3 static widgets (Stateless) and 1 Stateful widget with lifecycle logging. 
Deliverable: Flutter screen combining all 4 widgets.
Evidence: Screenshot/APK build + Git commit.
Rubric: Correct widget type usage (40%), lifecycle understanding (30%), UI correctness (30%).

# Assignment evidence:
![▶️ Watch demo video](./assets/demo_recordings.mov)
![▶️ Screenshot](./assets/demo_screenshot.png)