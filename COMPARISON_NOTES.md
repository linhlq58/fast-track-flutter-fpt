# Day 16 — Habit Tracker: Bloc vs Provider

## What changed
- `HabitProvider extends ChangeNotifier` was replaced by `HabitBloc extends Bloc<HabitEvent, HabitState>`.
- UI actions dispatch explicit events: `HabitAdded`, `HabitToggled`, and `HabitRemoved`.
- The Bloc processes events and emits a new immutable `HabitState`.
- `BlocBuilder` renders the habit list; `BlocSelector` reads the summary values.
- The `Habit` model, add dialog, and habit tile remain presentation/model concerns rather than state-management concerns.

## Event → State flow
1. User checks a habit.
2. UI dispatches `HabitToggled(habit.id)`.
3. `HabitBloc` handles the event and creates a new habits list.
4. Bloc emits a new `HabitState`.
5. `BlocBuilder` and `BlocSelector` rebuild from the new state.

## Provider vs Bloc comparison

| Area | Provider (`ChangeNotifier`) | Bloc (`Bloc<Event, State>`) |
|---|---|---|
| Trigger | Call a method such as `toggleHabit(id)` | Add an event such as `HabitToggled(id)` |
| Update | Mutate internal data then call `notifyListeners()` | Handle event and `emit(newState)` |
| State shape | Often fields/getters on the notifier | Explicit state object |
| UI integration | `watch`, `read`, `select` | `BlocBuilder`, `BlocSelector`, `BlocListener` |
| Traceability | Method calls are direct and concise | Events make user intentions explicit and traceable |
| Boilerplate | Lower; quick for small features | More files/classes and setup |
| Testing | Test notifier methods and resulting fields | Test event sequences and emitted states |
| Best fit | Small/simple state, lightweight apps | Larger or event-driven features with clear transitions and test needs |

## Trade-offs / reflection
**Provider strengths:** less boilerplate and a straightforward mental model for this small feature.

**Bloc strengths:** events make intent explicit; state changes are centralized and easier to inspect or test as sequences. The UI doesn't directly call state mutation methods.

**Bloc costs:** more types and files for only three simple actions. For a small local feature, Provider may be faster to build; Bloc becomes more valuable as rules, asynchronous operations, errors, and tests grow.

## Scope / limitations
- This demo uses in-memory state only. Habits reset when the app process restarts.
- There is no repository or persistence layer because the assignment is focused on practicing Event–State.
- `Equatable` provides value equality for events, states, and habits.

## Manual test checklist
- [ ] App starts with five example habits.
- [ ] Add a non-empty habit; it appears in the list and total count increases.
- [ ] Submit a blank habit; dialog stays open and no habit is added.
- [ ] Complete and uncomplete a habit; checkbox, strikethrough, percentage, and progress bar update.
- [ ] Remove a habit; it disappears and total/progress update.
- [ ] Remove all habits; empty-state message appears and progress is 0%.

## Demo video outline (about 45–90 seconds)
1. Show the initial five habits and progress summary.
2. Add a new habit.
3. Mark one complete and show progress changing.
4. Uncheck it to show the reverse transition.
5. Remove a habit and show the total update.
6. Briefly show `habit_event.dart`, `habit_state.dart`, and `habit_bloc.dart` in the editor.

## Suggested Git commit
`feat: rebuild habit tracker with Bloc event-state pattern`
