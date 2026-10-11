# Day 10 – Custom reusable widgets (Concept/Lecture, 60 mins)

1. Why Build Custom Widgets? (≈10 mins)
	•	At Junior level, developers often duplicate UI code across screens (copy-paste a card, a button style, a list tile) — this creates maintenance problems when design changes
	•	Intermediate-level mindset: "If you build it twice, extract it into a widget."
	•	Benefits: consistency across the app, easier testing, easier design-system updates, smaller/more readable build() methods
2. Composition Over Inheritance (≈15 mins)
	•	Flutter strongly favors composition — building complex widgets by combining smaller ones — rather than extending existing widget classes
	•	Anti-pattern to flag: extending Container or Text directly to "customize" it — instead, wrap it:

```dart
class AppCard extends StatelessWidget {
	final Widget child;    
	const AppCard({super.key, required this.child});     
	
	@override    
	Widget build(BuildContext context) {      
		return Container(        
			padding: const EdgeInsets.all(16),        
			decoration: BoxDecoration(          
				color: Colors.white,          
				borderRadius: BorderRadius.circular(12),          
				boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],        
			),        
			child: child,      
		);    
	}  
}
```

	•	This mirrors how Flutter's own framework is built (e.g., Padding, Center, Container are themselves composed of simpler RenderObjects)

3. Designing a Reusable Widget API (≈20 mins)
	•	Key design questions when extracting a widget:
	◦	What should be fixed (part of the widget's own design) vs configurable (passed in via constructor)?
	◦	Use named, required/optional parameters with sensible defaults:
 
```dart
class PrimaryButton extends StatelessWidget {      
	final String label;      
	final VoidCallback onPressed;      
	final bool isLoading;       
	
	const PrimaryButton({        
		super.key,        
		required this.label,        
		required this.onPressed,        
		this.isLoading = false,      
	});      
	
	@override      
	Widget build(BuildContext context) {        
		return ElevatedButton(          
			onPressed: isLoading ? null : onPressed,          
			child: isLoading ? const SizedBox(
				width: 16, 
				height: 16, 
				child: CircularProgressIndicator(strokeWidth: 2), 
			) : Text(label),        
		);     
	}   
}
```

	•	Accepting a child or Widget Function(BuildContext) builder parameter for flexible content slots (similar to how ListView.builder works)
	•	Naming conventions: prefix app-specific widgets clearly (e.g., AppCard, AppButton) to distinguish from Flutter's built-in widgets

4. Organizing Reusable Widgets in a Project (≈10 mins)
	•	Folder structure convention: lib/widgets/ or lib/core/widgets/ for shared components, separate from feature-specific widgets
	•	Briefly preview: this organization connects directly to Unit 11 (Project Architecture) — reusable widgets typically live in a shared/core layer, independent of business logic
	•	Mention: a small internal widget catalog/showcase screen (optional) can help the team see what's already available before building something new — reduces duplication at scale

5. Common Pitfalls (≈5 mins)
	•	Over-engineering too early: making a widget overly generic/configurable before there are 2-3 real use cases to justify it
	•	Under-engineering: leaving const colors/sizes hardcoded instead of using theme values (connects to design consistency)
	•	Forgetting to pass through a key parameter — important for widget identity in lists (preview for Day 11's rebuild optimization topic)


# Day 11 – Rebuild optimization (const/keys) (Concept/Lecture, 60 mins)

1. How Flutter Rebuilds Work (≈10 mins)
Recap from Day 6: build() is called whenever setState() runs, a parent rebuilds, or an InheritedWidget dependency changes
Rebuilding is cheap by design (widgets are lightweight, immutable configurations), but not free: a large subtree rebuilt 60 times/second can cause dropped frames (jank)
Intermediate-level mindset: the goal is not to eliminate rebuilds, but to avoid unnecessary rebuilds of large or expensive subtrees
Key concept: Flutter compares the new widget with the old one at the same position in the Element Tree. If they are identical instances (e.g., const), Flutter skips rebuilding that subtree entirely

2. const Constructors (≈15 mins)
A const widget is created once at compile time and reused, so Flutter can skip rebuilding it

``` dart

Plain Text
  // Rebuilt every time the parent rebuilds  Padding(padding: EdgeInsets.all(8), child: Text('Hello'))   // Created once, skipped during rebuilds  const Padding(padding: EdgeInsets.all(8), child: Text('Hello'))
```

Rules for using const:
All fields must be final, and the constructor must be declared const
All arguments passed must also be compile-time constants
A const parent makes its entire subtree const

Reinforce from Day 10: custom reusable widgets should declare const constructors so callers can use them
Tooling tip: enable lint rules prefer_const_constructors and prefer_const_literals_to_create_immutables in analysis_options.yaml, and use IDE quick-fixes to apply them
Limitation to mention: const only helps when values are truly static. Widgets that depend on runtime data cannot be const

3. Keys (≈15 mins)

What a Key is: an identifier that helps Flutter match widgets to Elements when the widget list changes
Problem demo: reorder/remove items in a list of Stateful widgets without keys, and the state (e.g., a checkbox or text field) stays at the old position and "jumps" to the wrong item
Types of keys:
ValueKey — based on a simple value (e.g., item ID). Most common for list items
ObjectKey — based on object identity
UniqueKey — new on every build (forces state reset; use carefully)
GlobalKey — unique across the whole app; allows accessing a widget's state from elsewhere (use sparingly, as it is costly and can create tight coupling)
PageStorageKey — preserves scroll position across navigation

Rule of thumb: keys are not needed for Stateless widgets in static layouts. They matter when reordering/inserting/removing Stateful widgets in a collection

```dart
  ListView.builder(    
	itemCount: items.length,    
	itemBuilder: (context, index) => TodoTile(      
		key: ValueKey(items[index].id),      
		item: items[index],    
	),
)
```

4. Other Rebuild Reduction Techniques (≈10 mins)

Push setState() down: move the stateful part into a small separate widget so only that subtree rebuilds, instead of the whole screen
Extract widgets into classes, not helper methods: a Widget _buildHeader() method rebuilds with its parent, whereas a separate widget class (especially a const one) can be skipped
Use ListView.builder / GridView.builder: only visible items are built (recap from Day 8)
Brief preview: state management tools (Provider Selector/Consumer, Bloc BlocBuilder with buildWhen) give fine-grained control over which widgets rebuild (Unit 5-6)

5. Measuring Rebuilds with Flutter DevTools (≈10 mins)

Demo: open Flutter DevTools → Performance / Widget Inspector, and enable "Track widget rebuilds" (or use debugPrint inside build() for a quick check)
Show a before/after example: a screen where one counter update rebuilds the whole page, then fix it with const + extracted widgets, and compare rebuild counts
This links directly to the Day 12 lab (Refactor widget lab), where learners must provide before/after rebuild evidence as defined in the lab rubric
Warning: always profile in profile mode on a real device, because debug mode performance numbers are not representative


# Day 12: Refactor widget lab

Task: Refactor Day 7–9 widgets into reusable components; apply const/keys optimization.
Deliverable: Refactored code with reduced rebuild count (before/after).
Evidence: Flutter DevTools rebuild count screenshot (before/after).
Rubric: Reusability (30%), correct const/key usage (40%), measurable rebuild reduction (30%).


# Assignment evidence:
![Go to ./assets/demo_recording.mov](./assets/demo_recording.mov)